import 'package:json_annotation/json_annotation.dart';

/* Para la serialización */
part 'TiempoVerbal.g.dart';

/**
 * Almacena todas las formas verbales de un tiempo verbal (pretérito pluscuamperfecto,
 * futuro simple...) para todos los sujetos
 */
@JsonSerializable(
    fieldRename: FieldRename.snake,
    explicitToJson: true
)
class TiempoVerbal {

    /**
     * Nombre del tiempo verbal (presente simple, pretérito imperfecto...)
     */
    @JsonKey(required: true)
    final String nombre;

    /* En todos los modos, existe al menos la segunda persona del singular y plural. El
    resto son opcionales (el imperativo sólo tiene segunda persona) */

    /*==========*/
    /* SINGULAR */
    /*==========*/

    /**
     * Primera persona del singular: Yo
     */
    @JsonKey(required: true)
    final String sing_prim;

    /**
     * Segunda persona del singular: [ Tú / Vos ], [ Usted ]
     */
    @JsonKey(required: true)
    final List<String> sing_seg;

    /**
     * Tercera persona del singular: Ella / Él
     */
    @JsonKey(required: true)
    final String sing_terc;


    /*========*/
    /* PLURAL */
    /*========*/

    /**
     * Primera persona del plural: Nosotras / Nosotros
     */
    @JsonKey(required: true)
    final String plural_prim;

    /**
     * Segunda persona del plural: [Vosotras / Vosotros],  [ Ustedes ]
     */
    @JsonKey(required: true)
    final List<String> plural_seg;

    /**
     * Tercera persona del plural: Ellas / Ellos
     */
    @JsonKey(required: true)
    final String plural_terc;

    /*******************/
    /** SERIALIZACIÓN **/
    /*******************/
    /* https://flutter.dev/docs/development/data-and-backend/json#code-generation */

    /// A necessary factory constructor for creating a new User instance
    /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
    /// The constructor is named after the source class, in this case, User.
    factory TiempoVerbal.fromJson(Map<String, dynamic> json) => _$TiempoVerbalFromJson (json);

    /// `toJson` is the convention for a class to declare support for serialization
    /// to JSON. The implementation simply calls the private, generated
    /// helper method `_$UserToJson`.
    Map<String, dynamic> toJson () => _$TiempoVerbalToJson (this);



    TiempoVerbal (
        this.nombre,
        this.sing_seg,
        this.plural_seg,

        { this.sing_prim,
        this.sing_terc,

        this.plural_prim,
        this.plural_terc }
    );


    /**
     * Representación de este objeto en una cadena de texto
     */
    @override
    String toString () {

        return "TiempoVerbal:\n"
                + "Nombre: $nombre\n"
                + (this.sing_prim == null? "" : "Yo $sing_prim\n")
                + "Tú / vos ${sing_seg [0]}\n"
                + "Usted ${sing_seg [1]}\n"
                + (this.sing_terc == null? "" : "Él / Ella $sing_terc\n")
                + (this.plural_prim == null? "" : "Nosotros / Nosotras $plural_prim\n")
                + "Vosotros / Vosotras ${plural_seg [0]}\n"
                + "Ustedes ${plural_seg [1]}\n"
                + (this.plural_terc == null? "" : "Ellos / Ellas $plural_terc\n")
        ;
    }

}
