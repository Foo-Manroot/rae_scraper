import 'package:html/dom.dart' as dom;

import 'enums.dart';
import 'Acepc.dart';
import 'Definic.dart';

/**
 * Representación de una expresión popular.
 */
class Expr extends Definic {

    /**
     * Texto de la expresión.
     */
    final String texto;

    /**
     * Lista de acepciones con las que se define esta frase hecha.
     */
    final List<Acepc> definiciones;

    /*******************/
    /** CONSTRUCTORES **/
    /*******************/

    /**
     * Constructor por defecto.
     * Simplemente inicializa los atributos
     */
    Expr (String this.texto
        , { String id = null, List<Acepc> definiciones = null }
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
