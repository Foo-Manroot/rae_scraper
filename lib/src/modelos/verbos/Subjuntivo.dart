import 'package:json_annotation/json_annotation.dart';

import 'TiempoVerbal.dart';

/* Para la serialización */
part 'Subjuntivo.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake,
    explicitToJson: true
)
class Subjuntivo {

    /**
     * Presente.
     */
    @JsonKey(required: true)
    final TiempoVerbal presente;

    /**
     * Futuro simple.
     */
    @JsonKey(required: true)
    final TiempoVerbal futuro;

    /**
     * Pretérito imperfecto.
     */
    @JsonKey(required: true)
    final TiempoVerbal pret_imperf;

    /*******************/
    /** SERIALIZACIÓN **/
    /*******************/
    /* https://flutter.dev/docs/development/data-and-backend/json#code-generation */

    /// A necessary factory constructor for creating a new User instance
    /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
    /// The constructor is named after the source class, in this case, User.
    factory Subjuntivo.fromJson(Map<String, dynamic> json) => _$SubjuntivoFromJson (json);

    /// `toJson` is the convention for a class to declare support for serialization
    /// to JSON. The implementation simply calls the private, generated
    /// helper method `_$UserToJson`.
    Map<String, dynamic> toJson () => _$SubjuntivoToJson (this);


    Subjuntivo (
        this.presente,
        this.futuro,
        this.pret_imperf
    );

    /**
     * Representación de este objeto en una cadena de texto
     */
    @override
    String toString () {

        return "Subjuntivo:\n"
                + "$presente"
                + "\n-----------------\n"
                + "$pret_imperf"
                + "\n-----------------\n"
                + "$futuro"
        ;
    }

}
