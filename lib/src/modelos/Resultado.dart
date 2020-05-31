import 'package:json_annotation/json_annotation.dart';
import 'dart:io';

import 'Entrada.dart';
import 'Definic.dart';

import 'enums.dart';
import 'Acepc.dart';
import 'Expr.dart';
import 'Uso.dart';

/* Para la serialización */
part 'Resultado.g.dart';

/**
 * Clase para representar el conjunto de entradas que conforman un resultado.
 */
@JsonSerializable(
    fieldRename: FieldRename.snake,
    explicitToJson: true
)
class Resultado {

    /**
     * Entradas mostradas en esta página.
     */
    @JsonKey(required: true)
    final List<Entrada> entradas;

    /**
     * Lista con enlaces a otras entradas.
     */
    @JsonKey(required: true)
    final List<String> otras;

    /*******************/
    /** SERIALIZACIÓN **/
    /*******************/
    /* https://flutter.dev/docs/development/data-and-backend/json#code-generation */

    /// A necessary factory constructor for creating a new User instance
    /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
    /// The constructor is named after the source class, in this case, User.
    factory Resultado.fromJson(Map<String, dynamic> json) => _$ResultadoFromJson (json);

    /// `toJson` is the convention for a class to declare support for serialization
    /// to JSON. The implementation simply calls the private, generated
    /// helper method `_$UserToJson`.
    Map<String, dynamic> toJson () => _$ResultadoToJson (this);



    /**
     * Constructor por defecto.
     * Simplemente inicializa los atributos con los valores proporcionados.
     */
    Resultado (List<Entrada> this.entradas, List<String> this.otras);



    /**
     * Devuelve un texto con la información de este resultado en formato legible.
     */
    String obtenerTexto () {

        String ret_val = "Entradas:\n\n";
        for (Entrada e in entradas) {

            ret_val += "\n${e.title}\n";
            ret_val += "-> Etimología: ${e.etim}\n";

            for (Definic d in e.definiciones) {

                switch (d.clase) {

                    case ClaseAcepc.manual:
                    case ClaseAcepc.normal:
                        Acepc acepc = (d as Acepc);

                        String usos = "";
                        for (Uso u in acepc.uso) {

                            usos += u.abrev + " ";
                        }

                        ret_val += ("${acepc.num_acep}. ${acepc.gram} "
                                + "| ${usos}${acepc.texto}\n");
                        break;

                    case ClaseAcepc.frase_hecha:
                        Expr expr = (d as Expr);

                        ret_val += "-> ${expr.texto}\n";
                        for (Acepc def in expr.definiciones) {

                            String usos = "";
                            for (Uso u in def.uso) {

                                usos += u.abrev + " ";
                            }

                            ret_val += ("${def.num_acep}. ${def.gram} "
                                + "| ${usos}${def.texto}\n");
                        }
                        break;

                    case ClaseAcepc.enlace:
                        Acepc acepc = (d as Acepc);
                        ret_val += "${acepc.texto}\n";

                        break;

                    default:
                        ret_val += "-> ${d.toString ()}\n";
                }
            }
        }


        ret_val += "\n======\n\n";
        ret_val += "Otras entradas:\n\n";
        for (String o in otras) {

            ret_val += "-> ${o}\n\n";
        }

        return ret_val;
    }


    /**
     * Imprime por pantalla los resultados
     */
    void mostrarResultados () => stdout.write (this.obtenerTexto ());



    /**
     * Representación de este objeto en una cadena de texto
     */
    @override
    String toString () {

        return "Atributos de esta instancia de 'Resultado':\n"
            + "=> Entradas: ${this.entradas}\n"
            + "=> Otras entradas: ${this.otras}\n"
        ;
    }

}
