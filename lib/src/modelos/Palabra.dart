import 'dart:async';

import 'Resultado.dart';
import '../scraper.dart';


/**
 * Clase para representar una palabra
 */
class Palabra {

    /**
     * Si se puede abreviar (por ejemplo, centímetro -> cm.), se usa este atributo para
     * almacenar la abreviatura.
     */
    final String abbr;

    /**
     * Texto completo de la palabra. Si se trata de una abreviatura, en este atributo se
     * almacenará la palabra completa. La abreviatura se encontrará en [abbr].
     */
    final String texto;


    /**
     * Identificador para obtener la definición de esta palabra. El método [obtenerDef()]
     * se encarga de pedir <URL>/?e=1&id=[dataId]&w=[texto], lo que devuelve el HTML con
     * la definición de la palabra.
     */
    final String dataId;

    /**
     * Enlace al recurso necesario para obtener la definción de esta palabra, si está
     * disponible.
     */
    final String enlaceRecurso;


    /*****************/
    /* CONSTRUCTORES */
    /*****************/

     /**
     * Constructor por defecto.
     * Simplemente inicializa los atributos
     */
    Palabra (String this.texto
        , { String dataId = null, String abbr = null, String enlaceRecurso = null }
    ):
        this.dataId = dataId
        , this.abbr = abbr
        /* Si está definido "dataId", construye un enlace en base a eso */
        , this.enlaceRecurso = (enlaceRecurso == null)?
                (dataId == null)?
                    null
                    : "/?e=1&id=${dataId}"
                : enlaceRecurso
    ;

    /***********/
    /* MÉTODOS */
    /***********/


    /**
     * Realiza una petición a [urlBase]/?e=1&id=[dataId]&w=[texto] para obtener las
     * definiciones de esta palabra.
     *
     * @param scraper: [Scraper]
     *          Objeto encargado de realizar las peticiones.
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
    Future<Resultado> obtenerDef (
        Scraper scraper,
         { Function (Exception) manejadorExcepc = null,
        Function (Error) manejadorError = null }
    ) async {

        return scraper.buscarPalabra (this,
            manejadorError: manejadorError,
            manejadorExcepc: manejadorExcepc
        );
    }

    /**
     * Representación de este objeto en una cadena de texto
     */
    @override
    String toString () {

        return "\tAtributos de esta instancia de 'Palabra':\n"
            + "\t\t=> Texto: ${this.texto}\n"
            + ((this.abbr == null)? "": "\t\t=> Abreviación: ${this.abbr}\n")
            + ((this.dataId == null)? "": "\t\t=> Data-ID: ${this.dataId}\n")
            + ((this.enlaceRecurso == null)? "": "\t\t=> Enlace: ${this.enlaceRecurso}\n")
        ;
    }

}
