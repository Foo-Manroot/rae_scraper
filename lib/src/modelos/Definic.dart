import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';
import 'Acepc.dart';
import 'Expr.dart';


/* Para la serialización */
part 'Definic.g.dart';

/**
 * Clase base para cualquier tipo de definición (frases hechas, definiciones normales...),
 */
@JsonSerializable(
    fieldRename: FieldRename.snake,
    explicitToJson: true,
    createFactory: false
)
abstract class Definic {

    /**
     * Identificador (HTML) de la acepción (si existe).
     */
    @JsonKey(defaultValue: null)
    final String id;

    /**
     * Tipo de acepción, por si se necesita diferenciar en algún momento
     */
    @JsonKey(defaultValue: ClaseAcepc.manual)
    final ClaseAcepc clase;


    /*******************/
    /** SERIALIZACIÓN **/
    /*******************/
    /* https://flutter.dev/docs/development/data-and-backend/json#code-generation */

    /**
     * Al ser una clase abstracta, hay que crear un constructor propio:
     * https://github.com/dart-lang/json_serializable/issues/606#issuecomment-587993029
     */
    factory Definic.fromJson(Map<String, dynamic> json) {

        switch (json ["clase"]) {

            /* Al serializar no se usan los valores 'ClaseAcepc', sino sus
            representaciones como String */
            case "manual":
            case "normal":
            case "enlace":
                return Acepc.fromJson (json);

            case "frase_hecha":
                return Expr.fromJson (json);

            default:
                throw ArgumentError ("Invalid value provided: ${json["clase"]}. "
                                    " Should be one of ${ClaseAcepc.values}"
                );
        }
    }

    /// `toJson` is the convention for a class to declare support for serialization
    /// to JSON. The implementation simply calls the private, generated
    /// helper method `_$UserToJson`.
    Map<String, dynamic> toJson () => _$DefinicToJson (this);



    Definic (String this.id, ClaseAcepc this.clase);


    /**
     * Representación de este objeto en una cadena de texto.
     * Se devuelve la cadena correspondiente en función de la clase de acepción que sea.
     */
    @override
    String toString () {

        String str = "";
        switch (clase) {

            case ClaseAcepc.manual:
            case ClaseAcepc.normal:
                str = (this as Acepc).toString ();
                break;

            case ClaseAcepc.frase_hecha:
                str = (this as Expr).toString ();
                break;

            case ClaseAcepc.enlace:
            default:
                str = "\tAtributos de esta instancia de 'Definic':\n"
                    + ((this.id == null)? "": "\t=> ID de la entrada: ${this.id}\n")
                    + "\t=> Tipo de entrada: ${this.clase}\n"
                ;
        }

        return str;
    }

}
