import 'package:json_annotation/json_annotation.dart';

import 'TiempoVerbal.dart';

/* Para la serialización */
part 'Indicativo.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake,
    explicitToJson: true
)
class Indicativo {

    /**
     * Presente.
     */
    @JsonKey(required: true)
    final TiempoVerbal presente;

    /**
     * Pretérito imperfecto.
     */
    @JsonKey(required: true)
    final TiempoVerbal pret_imperf;

    /**
     * Pretérito perfecto simple.
     */
    @JsonKey(required: true)
    final TiempoVerbal pret_perf_simple;

    /**
     * Futuro simple.
     */
    @JsonKey(required: true)
    final TiempoVerbal futuro;

    /**
     * Condicional simple.
     */
    @JsonKey(required: true)
    final TiempoVerbal condicional;

    /*******************/
    /** SERIALIZACIÓN **/
    /*******************/
    /* https://flutter.dev/docs/development/data-and-backend/json#code-generation */

    /// A necessary factory constructor for creating a new User instance
    /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
    /// The constructor is named after the source class, in this case, User.
    factory Indicativo.fromJson(Map<String, dynamic> json) => _$IndicativoFromJson (json);

    /// `toJson` is the convention for a class to declare support for serialization
    /// to JSON. The implementation simply calls the private, generated
    /// helper method `_$UserToJson`.
    Map<String, dynamic> toJson () => _$IndicativoToJson (this);



    Indicativo (
        this.presente,
        this.pret_imperf,
        this.pret_perf_simple,
        this.futuro,
        this.condicional
    );


    /**
     * Representación de este objeto en una cadena de texto
     */
    @override
    String toString () {

        return "Indicativo:\n"
                + "$presente"
                + "\n-----------------\n"
                + "$pret_imperf"
                + "\n-----------------\n"
                + "$pret_perf_simple"
                + "\n-----------------\n"
                + "$futuro"
                + "\n-----------------\n"
                + "$condicional"
        ;
    }

}
