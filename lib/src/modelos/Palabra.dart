import 'dart:async';
import 'Entrada.dart';


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
     * @param urlBase: [String]
     *          URL sobre a que pedir el recurso especificado. No debería acabar en "/",
     *      aunque es posible que no sea un problema.
     *
     *
     * @return: [List<Entrada>]
     *          Una lista con todas las entradas relativas a esta palabra.
     */
    Future<List<Entrada>> obtenerDef ([String urlBase = "https://dle.rae.es"]) async {

        return [];
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
