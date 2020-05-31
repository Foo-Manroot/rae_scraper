import 'package:json_annotation/json_annotation.dart';

/* Para la serialización */
part 'Uso.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake,
    explicitToJson: true
)
class Uso {

    /** Abreviatura usada para denotar este uso. */
    @JsonKey(required: true)
    final String abrev;

    /** Lista con las posibles interpretaciones de la abreviación. */
    @JsonKey(required: true)
    final List<String> significado;


    /*******************/
    /** SERIALIZACIÓN **/
    /*******************/
    /* https://flutter.dev/docs/development/data-and-backend/json#code-generation */

    /// A necessary factory constructor for creating a new User instance
    /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
    /// The constructor is named after the source class, in this case, User.
    factory Uso.fromJson(Map<String, dynamic> json) => _$UsoFromJson (json);

    /// `toJson` is the convention for a class to declare support for serialization
    /// to JSON. The implementation simply calls the private, generated
    /// helper method `_$UserToJson`.
    Map<String, dynamic> toJson () => _$UsoToJson (this);





    /** Constructor por defecto.
     * Simplemente inicializa todas las variables.
     */
    Uso (this.abrev, this.significado);


    /**
     * Representación de este objeto en una cadena de texto
     */
    @override
    String toString () {

        return "\tAtributos de esta instancia de 'Uso':\n"
            + "\t=> Abreviatura: ${this.abrev}\n"
            + "\t=> Significado: ${this.significado}\n"
        ;
    }

}
