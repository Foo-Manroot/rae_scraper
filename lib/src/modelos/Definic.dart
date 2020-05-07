import 'enums.dart';
import 'Acepc.dart';
import 'Expr.dart';

/**
 * Clase base para cualquier tipo de definición (frases hechas, definiciones normales...)
 */
abstract class Definic {

    /**
     * Identificador (HTML) de la acepción (si existe).
     */
    final String id;

    /**
     * Tipo de acepción, por si se necesita diferenciar en algún momento
     */
    final ClaseAcepc clase;


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
