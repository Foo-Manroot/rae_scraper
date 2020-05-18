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

    String userAgent = "Mozilla/5.0 (X11; Linux x86_64; rv:75.0) "
                    + "Gecko/20100101 Firefox/75.0";

    final String url;

    /******************/
    /******************/

    /**
     * Constructor.
     *
     * @param url: [String]
     *          URL base sobre la que hacer peticiones
     */
    Scraper.baseUrl (this.url);


    /**
     * Constructor por defecto.
     * En este caso, la URL de base es https://dle.rae.es
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
        ;
    }



    /*************************************/
    /* Implementación de métodos propios */
    /*****************************+*******/

    /**
     * Realiza una petición a la URL especificada y devuelve el contenido
     *
     * @param recurso: [String]
     *          URL a la que se va a hacer la petición.
     *
     * @return: [io.HttpClientResponse]
     */
    Future<io.HttpClientResponse> realizarGet (String url) async {

        io.HttpClient cliente = new io.HttpClient ();

        Uri uri = Uri.parse (url).normalizePath ();

        print ("Realizando petición a ${uri}");

        var petic = await cliente.getUrl (uri)
                ..headers.add (io.HttpHeaders.userAgentHeader, this.userAgent)
        ;

        /* No se espera que haya más peticiones cercanas en el tiempo, por lo que no
        conviene dejar la conexión abierta */
        cliente.close ();
        return petic.close ();
    }


    /**
     * En base al elemento de entrada, obtiene todas las entradas (elementos de tipo
     * 'article') y sus acepciones.
     *
     * @param resultados: [dom.Element]
     *          Elemento con id="resultados" que contiene todas las entradas en el
     *
     *
     * @return: [List<Entrada>]
     *          Una lista con todas las entradas encontradas.
     */
    List<Entrada> obtenerEntradas (dom.Element resultados) {

        return [];
    }


    /**
     * Dada una palabra, obtiene su definición
     *
     * @param palabra: [String]
     *          Palabra cuya definición se quiere obtener.
     */
    Future<Resultado> obtenerDef (String palabra) async {

        io.HttpClientResponse respuesta = await realizarGet (this.url + "/" + palabra);
        String html = "";
        await for (var texto in respuesta.transform (Utf8Decoder ())) {

             html += texto;
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

        if (res.entradas.isEmpty) {

            print ("¡ERROR! No se ha encontrado ningún resultado\n");
            res = null;

        } else {

            res.mostrarResultados ();
        }

        return res;
    }

}



