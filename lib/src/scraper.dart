import 'dart:async';
import 'dart:io' as io;
import 'dart:convert' show Utf8Decoder, jsonDecode;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:logging/logging.dart';

import 'modelos/Entrada.dart';
import 'modelos/Resultado.dart';
import 'modelos/Palabra.dart';
import 'modelos/verbos/Conjug.dart';

/**
 * Scraper para obtener definiciones de la RAE.
 */
class Scraper {

    final _log = Logger ("Scraper");

    /**
     * Cadena con la descripción del último error producido.
     */
    String reason = null;

    /**
     * User-Agent a enviar. La página oficial de la RAE bloquea las peticiones con
     * determinados User-Agent
     */
    String userAgent = "Mozilla/5.0 (X11; Linux x86_64; rv:75.0) "
                    + "Gecko/20100101 Firefox/75.0";

    /**
     * URL base sobre la que realizar las peticiones
     */
    final String url;

    /**
     * Cliente usado para realizar las peticiones HTTP
     */
    final io.HttpClient _cliente = io.HttpClient ();

    /**
     * Cache para aumentar disminuir el tráfico de red necesario.
     * Cada entrada tiene como clave la URL y como valor tiene un mapa con la siguiente
     * estructura:
     * {
     *      "html": <STRING>,
     *      "insertado": <TIMESTAMP>
     * }
     * La fecha de inserción sirve para luego borrar las entradas antiguas si se llena la
     * cache.
     */
    final Map<String, Map<String, dynamic>> _cache = {};

    /**
     * Configuración del número máximo de elementos permitidos en la cache.
     * Cuando se llegue al límite, los nuevos elementos substituirán a los más antiguos.
     */
    int MAX_CACHE_SIZE = 100;

    /******************/
    /******************/

    /**
     * Constructor por defecto.
     * En este caso, la URL de base es https://dle.rae.es
     *
     * ¡ATENCIÓN!
     * Es muy importante llamar al método [dispose()] al terminar, para evitar fugas de
     * memoria y ceerrar todas las conexiones que se hayan quedado abiertas.
     *
     * Dependiendo de cuál sea el recurso objetivo, es posible que sea importante que
     * 'url' no acabe en '/'
     *
     * @param url: [String]
     *          URL base sobre la que hacer peticiones
     *
     */
    Scraper ({ this.url = "https://dle.rae.es" });


    /**
     * Representación de este objeto en una cadena de texto
     */
    @override
    String toString () {

        return "Atributos de esta instancia de 'Scraper':\n"
            + "=> User-Agent: ${this.userAgent}\n"
            + "=> URL: ${this.url}\n"
            + "=> Cliente HTTP: ${this._cliente}\n"
        ;
    }



    /*************************************/
    /* Implementación de métodos propios */
    /*****************************+*******/


    /**
     * Añade el valor especificado a la cache.
     *
     * @param clave
     *      Clave usada para insertar en la cache.
     *
     * @param html
     *      Texto de la respuesta sin interpretar devuelta por el servidor.
     */
    void _insertarEnCache (String clave, String html) {

        int timestamp = DateTime.now ().millisecondsSinceEpoch;

        if (_cache.length >= (MAX_CACHE_SIZE - 1)) {


            /* Tiene que buscar primero la entrada más antigua y reemplazarla */
            int timestamp_antiguo = timestamp;
            String clave_antiguo = null;

            _cache.forEach (
                (String k, Map<String, dynamic> v) {

                    /* Debe buscar el valor más antiguo => el que tenga menor timestamp */
                    if (v ["insertado"] <= timestamp_antiguo) {

                        clave_antiguo = k;
                        timestamp_antiguo = v ["insertado"];
                    }
                }
            );

            _log.info ("Alcanzado MAX_CACHE_SIZE ($MAX_CACHE_SIZE). "
                    + "Se elimina la clave '$clave_antiguo'"
            );
            _cache.removeWhere ( (k, _) => (k == clave_antiguo) );
        }

        _cache [clave] = { "html": html, "insertado": timestamp };
        _log.fine ("Añadido valor en cache con clave '$clave'");
    }

    /**
     * Realiza una petición a la URL especificada y devuelve el contenido.
     *
     * Toda excepción producida (por ejemplo, no poder contactar con el servidor) será
     * responsabilidad de quien llamó a este método.
     *
     *
     * @param recurso: [String]
     *          URL a la que se va a hacer la petición. Se da por hecho que la URL ya
     *      viene codificada para URL. En este método no se hace ninguna conversión.
     *
     * @return: [Future<String>]
     *          El texto devuelto en la respuesta.
     */
    Future<String> _realizarGet (String url) async {

        Uri uri = Uri.parse (url).normalizePath ();
        String contenido = "";

        /* Aparte de por la ruta, las entradas pueden distinguirse por los parámetros id
        o 'q' */
        String clave = (
            uri.path + (uri.queryParameters.containsKey ("id")?
                "?id=" + uri.queryParameters ["id"]
                : (uri.queryParameters.containsKey ("q")?
                    "?q=" + uri.queryParameters ["q"]
                    : ""
                )
            )
        );

        if (_cache.containsKey (clave)) {

            _log.finer ("Clave encontrada en cache: '$clave'");
            return _cache [clave]["html"];

        } else {

            _log.finer ("Clave '$clave' no encontrada en cache. "
                    + "Realizando petición a $uri"
            );

            var petic = await _cliente.getUrl (uri)
                    ..headers.add (io.HttpHeaders.userAgentHeader, this.userAgent)
                    ..followRedirects = true
                    ..maxRedirects = 3
            ;

            io.HttpClientResponse respuesta = await petic.close ();
            await for (var texto in respuesta.transform (Utf8Decoder ())) {

                contenido += texto;
            }
            _insertarEnCache (clave, contenido);
        }

        return contenido;
    }


    /**
     * Dado un objeto de tipo [Palabra], obtiene su definición.
     *
     * @param palabra: [Palabra]
     *          Objeto que contiene la información a buscar.
     *
     * @param manejadorExcepc: [Function(Exception)]
     *          Función a ejecutar si se produce alguna excepción al realizar la
     *      petición HTTP. Si no se especifica, se ignora cualquier excepción.
     *
     * @param manejadorError: [Function(Error)]
     *          Función a ejecutar si se produce alguna excepción al realizar la
     *      petición HTTP. Si no se especifica, se ignora cualquier excepción.
     *
     *
     * @return
     *          El resultado (cuando se complete el GET)
     *          ó
     *          null, si no se pudo obtener la definición. La razón se podrá obtener
     *          usando el atributo [this.reason].
     */
    Future<Resultado> buscarPalabra (Palabra palabra,
        { Function (Exception) manejadorExcepc = null,
        Function (Error) manejadorError = null }
    ) async {

        /* Si no hay enlace, busca por palabra */
        if (palabra.enlaceRecurso == null) {

            _log.finer ("Palabra sin enlace, buscando por texto");
            return this.obtenerDef (palabra.texto,
                manejadorExcepc: manejadorExcepc,
                manejadorError: manejadorError
            );
        }

        String html = "";
        try {

            html = await _realizarGet (this.url + palabra.enlaceRecurso);

        } catch (e) {

            /* Si llega una excepción de tipo "Error" no se puede usar este manejador */
            if ((e is Exception) && (manejadorExcepc != null)) {

                manejadorExcepc (e);

            } else if ((e is Error) && (manejadorError != null)) {

                manejadorError (e);
            }

            _log.severe (e.toString ());
            this.reason = e.toString ();
            return null;
        }

        Map<String,dynamic> json = jsonDecode (html);
        /* El único atributo que interesa es "html" */
        if (json ["html"] == null) {

            _log.severe ("Clave 'html' no encontrada en "
                        + "JSON de respuesta: '${json.keys}'"
            );
            this.reason = "No such key 'html' in JSON: $json";
            return null;
        }

        /* En el atributo "html" de json se encuentra toda la información, estructurada
        del siguiente modo:
            <article id="...">
            ├── <header> <-- Debería ser title="Definición de <palabra>"
            ├── <p class="n2"> <-- Etimología
            └── <p class="??"> <-- Acepción

            Las acepciones pueden ser de distinto tipo, indicado por su clase:
                j
                j2
                    Definición

                k5 (+m)
                    Expresión. En el siguiente elemento, con clase "m", está su
                    definición

                l
                l3
                    Entradas secundarias. Enlaces a otras entradas. Por ejemplo: dentro
                    de "gato" aparece "ojo de gato" con clase "l", que redirige a la
                    definición principal, dentro de "ojo".
        */
        dom.Element resultados = parse (json ["html"], encoding: "utf-8").body;

        List<Entrada> entradas = [];
        List<String> otras = [];
        for (dom.Element elem in resultados.children) {

            switch (elem.localName) {

                case "article":
                    entradas.add (new Entrada.article (elem));
                    break;

                case "div":
                    if (elem.className == "otras") {

                        for (dom.Element enlace in elem.querySelectorAll ("a")) {

                            if (enlace.attributes.containsKey ("href")) {

                                otras.add (enlace.attributes ["href"]);
                            }
                        }
                    }
                    break;
            }
        }

        Resultado res = new Resultado (palabra, entradas, otras);

        if ((res == null) || res.entradas.isEmpty) {

            _log.info ("No se ha encontrado ningún resultado");
            this.reason = "¡ERROR! No se ha encontrado ningún resultado\n";
            res = null;
        }

        return (res == null || res.entradas.isEmpty)? null : res;
    }


    /**
     * Dada una palabra, obtiene su definición.
     *
     * @param palabra: [String]
     *          Palabra cuya definición se quiere obtener. El contenido se normaliza
     *      (codificar en URL, poner en minúsculas...) dentro de esta función.
     *
     * @param manejadorExcepc: [Function(Exception)]
     *          Función a ejecutar si se produce alguna excepción al realizar la
     *      petición HTTP. Si no se especifica, se ignora cualquier excepción.
     *
     * @param manejadorError: [Function(Error)]
     *          Función a ejecutar si se produce alguna excepción al realizar la
     *      petición HTTP. Si no se especifica, se ignora cualquier excepción.
     *
     *
     * @return
     *          El resultado (cuando se complete el GET)
     *          ó
     *          null, si no se pudo obtener la definición. La razón se podrá obtener
     *          usando el atributo [this.reason].
     */
    Future<Resultado> obtenerDef (String palabra,
        { Function (Exception) manejadorExcepc = null,
        Function (Error) manejadorError = null }
    ) async {

        String html = "";
        try {

            html = await _realizarGet (
                this.url + "/" + Uri.encodeComponent (palabra.trim ())
            );

        } catch (e) {

            /* Si llega una excepción de tipo "Error" no se puede usar este manejador */
            if ((e is Exception) && (manejadorExcepc != null)) {

                manejadorExcepc (e);

            } else if ((e is Error) && (manejadorError != null)) {

                manejadorError (e);
            }

            _log.severe (e.toString ());
            this.reason = e.toString ();
            return null;
        }

        dom.Document domRespuesta = parse (html, encoding: "utf-8");

        /* Dentro de <div id="resultados"> se encuentra toda la información, estructurada
        del siguiente modo:
            #resultados
            ├── <article> <-- Contenedor principal de la entrada
            │   ├── <header> <-- Debería ser title="Definición de <palabra>"
            │   ├── <p class="n2"> <-- Etimología
            │   └── <p class="??"> <-- Acepción
            (...)
            └── <div class="otras"> <-- Opcional. Contiene enlaces a otras entradas

            Puede haber uno o varios "article" por cada una de las entradas

            A su vez, las acepciones pueden ser de distinto tipo, indicado por su clase:
                j
                j2
                    Definición

                k5 (+m)
                    Expresión. En el siguiente elemento, con clase "m", está su
                    definición

                l
                l3
                    Entradas secundarias. Enlaces a otras entradas. Por ejemplo: dentro
                    de "gato" aparece "ojo de gato" con clase "l", que redirige a la
                    definición principal, dentro de "ojo".
        */
        dom.Element resultados = domRespuesta.getElementById ("resultados");

        if ( (resultados == null) || (resultados.children.length <= 0)) {

            _log.severe ("Error al interpretar el html: $html");
            this.reason = "Error parsing html: $html";
            return null;
        }

        Conjug conjug;
        List<Entrada> entradas = [];
        List<String> otras = [];
        for (dom.Element elem in resultados.children) {

            switch (elem.localName) {

                case "article":
                    entradas.add (new Entrada.article (elem));
                    break;

                case "div":
                    if (elem.className == "otras") {

                        for (dom.Element enlace in elem.querySelectorAll ("a")) {

                            if (enlace.attributes.containsKey ("href")) {

                                otras.add (enlace.attributes ["href"]);
                            }
                        }
                    } else {

                        if (elem.id == "conjugacion") {

                            conjug = Conjug.fromDiv (elem);
                        }
                    }

                    break;
            }
        }

        Resultado res = new Resultado (
            Palabra (palabra), entradas, otras, conjug: conjug
        );

        if ((res == null) || res.entradas.isEmpty) {

            _log.info ("No se ha encontrado ningún resultado");
            this.reason = "¡ERROR! No se ha encontrado ningún resultado\n";
            res = null;
        }

        return (res == null || res.entradas.isEmpty)? null : res;
    }


    /**
     * Obtiene una lista con las sugerencias a partir de la cadena indicada.
     *
     * @param sub: [String]
     *              Cadena a partir de la cual formar las sugerencias.
     */
    Future<List<String>> obtenerSugerencias (String sub) async {

        String resultado = (
            await _realizarGet (this.url + "/srv/keys?q=" + sub)
        ).trim ();
        List<String> lista = [];

        /* Si no se encuentran resultados, no se devuelve una lista, sino un HTML con el
        mensaje de error */
        if (resultado [0] == "[") {

            try {

                lista = jsonDecode (resultado).cast <String>();

            } catch (e) {
                _log.warning ("No se pudo decodificar en JSON: '$e'");
            }
        } else {

            _log.fine ("La respuesta no es una lista JSON");
        }

        return lista;
    }


    /**
     * Obtiene la palabra del día.
     *
     *
     * @param manejadorExcepc: [Function(Exception)]
     *          Función a ejecutar si se produce alguna excepción al realizar la
     *      petición HTTP. Si no se especifica, se ignora cualquier excepción.
     *
     * @param manejadorError: [Function(Error)]
     *          Función a ejecutar si se produce alguna excepción al realizar la
     *      petición HTTP. Si no se especifica, se ignora cualquier excepción.
     *
     *
     * @return
     *          La [Palabra] (cuando se complete el GET)
     *          ó
     *          null, si no se pudo obtener la definición. La razón se podrá obtener
     *          usando el atributo [this.reason].
     */
    Future<Palabra> palabraDelDia (
        { Function (Exception) manejadorExcepc = null,
        Function (Error) manejadorError = null }
    ) async {

        Palabra palabra;

        /* Vale cualquier palabra para obtener la del día */
        List<String> aleatorio = [ "hola", "tanto", "palabra", "día" ]..shuffle ();

        String html = "";
        try {

            html = await _realizarGet (
                this.url + "/" + Uri.encodeComponent (aleatorio.first)
            );

        } catch (e) {

            /* Si llega una excepción de tipo "Error" no se puede usar este manejador */
            if ((e is Exception) && (manejadorExcepc != null)) {

                manejadorExcepc (e);

            } else if ((e is Error) && (manejadorError != null)) {

                manejadorError (e);
            }

            _log.severe (e.toString ());
            this.reason = e.toString ();
            return null;
        }

        dom.Document domRespuesta = parse (html, encoding: "utf-8");
        /* La palabra del día está dentro de un elemento con id="wotd" y sólo contiene
        un enlace a la palabra */
        dom.Element resultados = domRespuesta.getElementById ("wotd");

        if ( (resultados == null) || (resultados.children.length != 1)) {

            _log.severe ("Error al interpretar el html: $html");
            this.reason = "Error parsing html: $html";
            return null;
        }

        dom.Node info = resultados.children [0];

        palabra = Palabra (
            info.text,
            dataId: info.attributes ["href"],
            enlaceRecurso: info.attributes ["href"]
        );

        if (palabra == null) {

            _log.info ("No se ha podido obtener la palabra del día");
            this.reason = "No se ha podido obtener la palabra del día\n";
        }

        return palabra;
    }


    /**
     * Es muy importante llamar a este método al terminar de usar el objeto, para evitar
     * fugas de memoria y ceerrar todas las conexiones que se hayan quedado abiertas.
     *
     * Tras llamar a este método no se debería volver a usar este método.
     */
    void dispose () {

        this._cliente.close ();
    }

}



