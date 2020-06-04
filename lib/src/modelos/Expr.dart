import 'package:json_annotation/json_annotation.dart';
import 'package:html/dom.dart' as dom;

import 'enums.dart';
import 'Acepc.dart';
import 'Definic.dart';

/* Para la serialización */
part 'Expr.g.dart';

/**
 * Representación de una expresión popular.
 */
@JsonSerializable(
    fieldRename: FieldRename.snake,
    explicitToJson: true
)
class Expr extends Definic {

    /**
     * Texto de la expresión.
     */
    @JsonKey(required: true)
    final String texto;

    /**
     * Lista de acepciones con las que se define esta frase hecha.
     */
    @JsonKey(defaultValue: [])
    final List<Acepc> definiciones;

    /*******************/
    /** SERIALIZACIÓN **/
    /*******************/
    /* https://flutter.dev/docs/development/data-and-backend/json#code-generation */

    /// A necessary factory constructor for creating a new User instance
    /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
    /// The constructor is named after the source class, in this case, User.
    factory Expr.fromJson(Map<String, dynamic> json) => _$ExprFromJson (json);

    /// `toJson` is the convention for a class to declare support for serialization
    /// to JSON. The implementation simply calls the private, generated
    /// helper method `_$UserToJson`.
    Map<String, dynamic> toJson () => _$ExprToJson (this);


    /*******************/
    /** CONSTRUCTORES **/
    /*******************/

    /**
     * Constructor por defecto.
     * Simplemente inicializa los atributos
     *
     * El parámetro "clase" se declara explícitamente para poder serializar correctamente
     * (ver https://github.com/dart-lang/json_serializable/issues/274).
     */
    Expr (String this.texto
        , { String id = null, List<Acepc> definiciones = null , ClaseAcepc clase}
    ):
        this.definiciones = (definiciones == null)? [] : definiciones
        , super (id, ClaseAcepc.frase_hecha)
    ;



    /**
     * Extrae la información necesaria de la expresión.
     *
     * @param par: [dom.Element]
     *              Párrafo inicial del bloque, con el texto de la frase hecha.
     *          Este debería ser el bloque con clase "k5" o "k6".
     *
     * @param definiciones: [List<dom.Element>]
     *              Lista con el resto de párrafos con clase "m" antes de la siguiente
     *          frase hecha.
     */
    factory Expr.claseK (dom.Element par, List<dom.Element> definiciones) {


        List<Acepc> acepciones = [];
        for (dom.Element def in definiciones) {

            acepciones.add (Acepc.claseM (def));
        }

        return Expr (par.text, id: par.id, definiciones: acepciones);
    }



    /**
     * Representación de este objeto en una cadena de texto
     */
    @override
    String toString () {

        return "\tAtributos de esta instancia de 'Expr':\n"
            + ((this.id == null)? "": "\t=> ID de la entrada: ${this.id}\n")
            + "\t=> Tipo de entrada: ${this.clase}\n"
            + "\t=> Frase hecha: ${this.texto}\n"
            + "\t=> Definiciones: ${this.definiciones}\n"
        ;
    }

}
