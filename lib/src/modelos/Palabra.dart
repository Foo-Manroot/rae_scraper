import 'package:json_annotation/json_annotation.dart';
import 'dart:async';

import 'Resultado.dart';
import '../scraper.dart';

/* Para la serialización */
part 'Palabra.g.dart';

/**
 * Clase para representar una palabra
 */
@JsonSerializable(
    fieldRename: FieldRename.snake,
    explicitToJson: true
)
class Palabra {

    /**
     * Si se puede abreviar (por ejemplo, centímetro -> cm.), se usa este atributo para
     * almacenar la abreviatura.
     */
    @JsonKey(defaultValue: null)
    final String abbr;

    /**
     * Texto completo de la palabra. Si se trata de una abreviatura, en este atributo se
     * almacenará la palabra completa. La abreviatura se encontrará en [abbr].
     */
    @JsonKey(required: true)
    final String texto;


    /**
     * Identificador para obtener la definición de esta palabra. El método [obtenerDef()]
     * se encarga de pedir <URL>/?e=1&id=[dataId]&w=[texto], lo que devuelve el HTML con
     * la definición de la palabra.
     */
    @JsonKey(defaultValue: null)
    final String dataId;

    /**
     * Enlace al recurso necesario para obtener la definción de esta palabra, si está
     * disponible.
     */
    @JsonKey(defaultValue: null)
    String enlaceRecurso;

    /*******************/
    /** SERIALIZACIÓN **/
    /*******************/
    /* https://flutter.dev/docs/development/data-and-backend/json#code-generation */

    /// A necessary factory constructor for creating a new User instance
    /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
    /// The constructor is named after the source class, in this case, User.
    factory Palabra.fromJson(Map<String, dynamic> json) => _$PalabraFromJson (json);

    /// `toJson` is the convention for a class to declare support for serialization
    /// to JSON. The implementation simply calls the private, generated
    /// helper method `_$UserToJson`.
    Map<String, dynamic> toJson () => _$PalabraToJson (this);


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

        if (this.enlaceRecurso == null) {

            this.enlaceRecurso = (this.dataId == null)? null : "/?e=1&id=${this.dataId}";
        }

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
