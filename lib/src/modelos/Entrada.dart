import 'package:html/dom.dart' as dom;
import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';

import 'Definic.dart';
import 'Acepc.dart';
import 'Expr.dart';

/* Para la serialización */
part 'Entrada.g.dart';

/**
 * Clase para representar una entrada, que es un conjunto de acepciones.
 */
@JsonSerializable(
    fieldRename: FieldRename.snake,
    explicitToJson: true
)
class Entrada {

    /**
     * Lista con todas las acepciones encontradas
     */
    @JsonKey(defaultValue: [])
    final List<Definic> definiciones;

    /**
     * Lo que haya en el atributo "title" del elemento <header>
     */
    @JsonKey(required: true)
    final String title;

    /**
     * Etimología
     */
    @JsonKey(required: true)
    final String etim;

    /**
     * Identificador (HTML) de la entrada (si existe).
     */
    @JsonKey(defaultValue: null)
    final String id;

    /*******************/
    /** SERIALIZACIÓN **/
    /*******************/
    /* https://flutter.dev/docs/development/data-and-backend/json#code-generation */

    /// A necessary factory constructor for creating a new User instance
    /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
    /// The constructor is named after the source class, in this case, User.
    factory Entrada.fromJson(Map<String, dynamic> json) => _$EntradaFromJson (json);

    /// `toJson` is the convention for a class to declare support for serialization
    /// to JSON. The implementation simply calls the private, generated
    /// helper method `_$UserToJson`.
    Map<String, dynamic> toJson () => _$EntradaToJson (this);


    /*******************/
    /** CONSTRUCTORES **/
    /*******************/

    /**
     * Constructor por defecto.
     * Simplemente inicializa los atributos
     */
    Entrada (String this.title, String this.etim
        , { String id = null, List<Definic> definiciones = null }
    ):
        this.definiciones = (definiciones == null)? [] : definiciones
        , this.id = id
    ;



    /**
     * Extrae toda la información necesaria del elemento de tipo 'article' especificado.
     *
     * @param article: [dom.Element]
     *              Elemento raíz que contiene toda la información de esta entrada.
     */
    factory Entrada.article (dom.Element article) {

        /*
            ├── <article> <-- Contenedor principal de la entrada
            │   ├── <header> <-- Debería ser title="Definición de <palabra>"
            │   ├── <p class="n2"> <-- Etimología
            │   └── <p class="??"> <-- Acepción
        */
        String id = article.id;
        String title = (article.children [0].attributes.containsKey ("title"))?
                            article.children [0].attributes ["title"]
                            : article.children [0].text
        ;

        List<dom.Element> listaN2 = article.getElementsByClassName ("n2");
        /* La etimología debería consistir de varios nodos, pero sólo interesa el texto */
        String etim = "";

        if (listaN2.length == 1) {

            etim += listaN2 [0].text;

        } else {

            Logger ("Entrada.article").warning ("Se esperaba un elemento en 'listaN2', "
                + "llegaron ${listaN2.length}"
            );
        }


        List<Definic> defs = [];

        dom.Element elemK5;
        dom.Element elemAux;
        List<dom.Element> elemsM = [];

        for (dom.Element elem in article.children) {

            String claseCss = elem.className;

            switch (claseCss) {
                case "j":
                case "j2":
                    /* Acepción normal */
                    defs.add (new Acepc.claseJ (elem));
                    break;

                case "k5":
                case "k6":
                    elemsM = [];
                    elemK5 = elem;
                    elemAux = elem.nextElementSibling;

                    /* Busca todos los elementos con clase "m" asociados a esta frase
                    hecha */
                    while ((elemAux != null) && (elemAux.className == "m")) {

                        elemsM.add (elemAux);
                        elemAux = elemAux.nextElementSibling;
                    }

                    defs.add (new Expr.claseK (elemK5, elemsM));
                    break;

                case "l":
                case "l3":
                    defs.add (new Acepc.claseL (elem));
                    break;
            }
        }


        return Entrada (title, etim, id: id, definiciones: defs);
    }


    /**
     * Representación de este objeto en una cadena de texto
     */
    @override
    String toString () {

        return "Atributos de esta instancia de 'Entrada':\n"
            + "=> Nombre: ${this.title}\n"
            + ((this.id == null)? "": "=> ID de la entrada: ${this.id}\n")
            + "=> Etimología: ${this.etim}\n"
            + "=> Definiciones: ${this.definiciones}\n"
        ;
    }


}

