import 'Entrada.dart';
import 'Definic.dart';

import 'enums.dart';
import 'Acepc.dart';
import 'Expr.dart';

/**
 * Clase para representar el conjunto de entradas que conforman un resultado.
 */
class Resultado {

    /**
     * Entradas mostradas en esta página.
     */
    final List<Entrada> entradas;

    /**
     * Lista con enlaces a otras entradas.
     */
    final List<String> otras;

    /**
     * Constructor por defecto.
     * Simplemente inicializa los atributos con los valores proporcionados.
     */
    Resultado (List<Entrada> this.entradas, List<String> this.otras);


    /**
     * Imprime por pantalla los resultados
     */
    void mostrarResultados () {

        print ("Entradas:\n");
        for (Entrada e in entradas) {

            print ("\n${e.title}");
            print ("-> Etimología: ${e.etim}");

            for (Definic d in e.definiciones) {

                switch (d.clase) {

                    case ClaseAcepc.manual:
                    case ClaseAcepc.normal:
                        Acepc acepc = (d as Acepc);
                        print ("${acepc.num_acep}. ${acepc.gram} "
                                + "| ${acepc.uso} | ${acepc.texto}");
                        break;

                    case ClaseAcepc.frase_hecha:
                        Expr expr = (d as Expr);
                        print ("-> ${expr.texto}");
                        for (Acepc def in expr.definiciones) {

                            print ("${def.num_acep}. ${def.gram} "
                                + "| ${def.uso} | ${def.texto}");
                        }
                        break;

                    case ClaseAcepc.enlace:
                        Acepc acepc = (d as Acepc);
                        print ("${acepc.texto}");

                        break;

                    default:
                        print ("-> ${d.toString ()}");
                }
            }
        }


        print ("\n======\n");
        print ("Otras entradas:\n");
        for (String o in otras) {

            print ("-> ${o}\n");
        }
    }



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
