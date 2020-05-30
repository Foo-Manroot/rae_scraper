import 'dart:async';
import 'dart:io' as io;
import 'dart:convert' show Utf8Decoder;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

import 'modelos/Entrada.dart';
import 'modelos/Resultado.dart';

/**
 * Scraper para obtener definiciones de la RAE.
 */
class Scraper {

    /**
     * Cadena con la descripción del último error producido.
     */
    String reason = null;

    String userAgent = "Mozilla/5.0 (X11; Linux x86_64; rv:75.0) "
                    + "Gecko/20100101 Firefox/75.0";

    final String url;


    final io.HttpClient _cliente = io.HttpClient ();

    /******************/
    /******************/

    /**
     * Constructor.
     *
     * ¡ATENCIÓN!
     * Es muy importante llamar al método [dispose()] al terminar, para evitar fugas de
     * memoria y ceerrar todas las conexiones que se hayan quedado abiertas.
     *
     * @param url: [String]
     *          URL base sobre la que hacer peticiones
     */
    Scraper.baseUrl (this.url);


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
     */
    Scraper () :
        url = "https://dle.rae.es"
    ;


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
     * Realiza una petición a la URL especificada y devuelve el contenido
     *
     * @param recurso: [String]
     *          URL a la que se va a hacer la petición. Se da por hecho que la URL ya
     *      viene codificada para URL. En este método no se hace ninguna conversión.
     *
     * @return: [io.HttpClientResponse]
     */
    Future<io.HttpClientResponse> _realizarGet (String url) async {

        Uri uri = Uri.parse (url).normalizePath ();

        var petic = await _cliente.getUrl (uri)
                ..headers.add (io.HttpHeaders.userAgentHeader, this.userAgent)
                ..followRedirects = true
                ..maxRedirects = 3
        ;

        return petic.close ();
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
     * @return
     *          El resultado (cuando se complete el GET)
     *          ó
     *          null, si no se pudo obtener la definición. La razón se podrá obtener
     *          usando el atributo [reason].
     */
    Future<Resultado> obtenerDef (String palabra,
        { Function (Exception) manejadorExcepc = null }
    ) async {

        String html = "";
        try {
            io.HttpClientResponse respuesta = await _realizarGet (
                this.url + "/" + Uri.encodeComponent (palabra)
            );
            await for (var texto in respuesta.transform (Utf8Decoder ())) {

                html += texto;
            }
        } catch (e) {

            if (manejadorExcepc != null) {

                manejadorExcepc (e);
            }
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

            return null;
        }

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

        Resultado res = new Resultado (entradas, otras);

        if ((res == null) || res.entradas.isEmpty) {

            this.reason = "¡ERROR! No se ha encontrado ningún resultado\n";
            res = null;
        }

        return (res == null || res.entradas.isEmpty)? null : res;
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



