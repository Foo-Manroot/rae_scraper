import 'package:json_annotation/json_annotation.dart';

import 'TiempoVerbal.dart';

/* Para la serialización */
part 'Imperativo.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake,
    explicitToJson: true
)
class Imperativo {

    /**
     * Presente.
     */
    @JsonKey(required: true)
    final TiempoVerbal presente;

    /*******************/
    /** SERIALIZACIÓN **/
    /*******************/
    /* https://flutter.dev/docs/development/data-and-backend/json#code-generation */

    /// A necessary factory constructor for creating a new User instance
    /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
    /// The constructor is named after the source class, in this case, User.
    factory Imperativo.fromJson(Map<String, dynamic> json) => _$ImperativoFromJson (json);

    /// `toJson` is the convention for a class to declare support for serialization
    /// to JSON. The implementation simply calls the private, generated
    /// helper method `_$UserToJson`.
    Map<String, dynamic> toJson () => _$ImperativoToJson (this);


    Imperativo (
        this.presente
    );

    /**
     * Representación de este objeto en una cadena de texto
     */
    @override
    String toString () {

        return "Indicativo:\n"
                + "$presente"
        ;
    }

}
