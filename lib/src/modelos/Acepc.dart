import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';

import 'enums.dart';
import 'package:html/dom.dart' as dom;

import 'Palabra.dart';
import 'Definic.dart';
import 'Uso.dart';


/* Para la serialización */
part 'Acepc.g.dart';

/**
 * Clase para representar una acepción.
 */
@JsonSerializable(
    fieldRename: FieldRename.snake,
    explicitToJson: true
)
class Acepc extends Definic {

    /**
     * Número de acepción.
     * (<span class="n_acep">)
     */
    @JsonKey(required: true)
    final int num_acep;

    /**
     * Clasificación gramatical.
     * (<abbr class="g" title="...">)
     */
    @JsonKey(required: true)
    final String gram;

    /**
     * Especificaciones extra sobre el uso, como la zona en la que se usa, si es un
     * vulgarismo, etc.
     */
    @JsonKey(defaultValue: [])
    final List<Uso> uso;

    /**
     * Texto plano de la acepción. Esta se compone de los elementos [Palabra.texto] de
     * [palabras].
     */
    @JsonKey(required: true)
    final String texto;

    /**
     * Objetos de tipo Palabra que componen esta acepción.
     */
    @JsonKey(required: true)
    final List<Palabra> palabras;


    /*******************/
    /** SERIALIZACIÓN **/
    /*******************/
    /* https://flutter.dev/docs/development/data-and-backend/json#code-generation */

    /// A necessary factory constructor for creating a new User instance
    /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
    /// The constructor is named after the source class, in this case, User.
    factory Acepc.fromJson(Map<String, dynamic> json) => _$AcepcFromJson (json);

    /// `toJson` is the convention for a class to declare support for serialization
    /// to JSON. The implementation simply calls the private, generated
    /// helper method `_$UserToJson`.
    Map<String, dynamic> toJson () => _$AcepcToJson (this);


    /*******************/
    /** CONSTRUCTORES **/
    /*******************/

    /**
     * Constructor por defecto.
     * Simplemente inicializa los atributos
     */
    Acepc (int this.num_acep, String this.gram, String this.texto
        , List<Palabra> this.palabras
        , { ClaseAcepc clase = ClaseAcepc.manual, List<Uso> uso = null
            , String id = null }
    ):
        this.uso = (uso == null)? [] : uso
        , super (id, clase)
    ;



    /**
     * Constructor para las acepciones con class="j" o class="j2".
     * Extrae la información necesaria del elemento de tipo [dom.Element]
     *
     * Para otros tipos de acepciones, ver [Acepc.claseM()] y [Acepc.claseL()]
     *
     * @param par: [dom.Element]
     *      Párrafo dentro del cual está toda la información de esta acepción
     */
    factory Acepc.claseJ (dom.Element par) {

        /* Por ejemplo (CUIDADO CON EL PUNTO): <span class="n_acep">1.</span> */
        int n_acep = int.parse (par.firstChild.text.replaceAll (".", ""), radix: 10);

        /* Sólo importa "title": <abbr class="d" title="...">m. y f.</abbr> */
        String gram = par.children [1].attributes ["title"];

        /* A veces hay una serie de <abbr> para especificar el uso */
        List<Uso> uso = [ ];
        int idx = 2;
        dom.Node nodo;

        while (idx < par.nodes.length) {

            nodo = par.nodes [idx];

            if (nodo.nodeType == dom.Node.ELEMENT_NODE) {

                /* Termina el bucle si no se trataba de un nodo de tipo "abbr" */
                if (! (nodo as dom.Element).outerHtml.startsWith ("<abbr ")) {

                    break;
                }

                uso.add (Uso (nodo.text, nodo.attributes ["title"].split (",")));
            }

            idx ++;
        }


        /* A partir de aquí ya todo forma parte de la definición. Puede que haya más
        elementos del tipo "abbr" que haya que tratar de manera acorde.

        La sublista empieza se salta todos los elementos ya procesados más un
        primer espacio. */
        String def = "";
        List<Palabra> palabras = [];
        dom.Element elem;
        while (idx < par.nodes.length) {

            nodo = par.nodes [idx];
            switch (nodo.nodeType) {

                case dom.Node.ELEMENT_NODE:
                    elem = (nodo as dom.Element);
                    /* Elemento HTML */
                    if (elem.outerHtml.startsWith ("<abbr ")) {

                        /* En las abreviaciones la palabra completa está en "title" */
                        Palabra p = new Palabra (
                            elem.attributes ["title"]
                            , abbr: elem.text
                            , dataId: (elem.attributes.containsKey ("data-id"))?
                                       elem.attributes ["data-id"] : null
                        );
                        def += p.texto;
                        palabras.add (p);

                    } else if (elem.outerHtml.startsWith ("<a ")) {

                        /* Enlace => <a class="a" href="...">...</a>
                            A tener en cuenta: el href puede ser un enlace externo,
                            '/?id=...#...', o a un ID de esta misma página, '#...'

                            Si es el primer caso, cambia '/?id=...' por '/?e=1&id=...'
                        */
                        String href = elem.attributes ["href"];

                        if (href.startsWith ("/?id=")) {

                            href = "/?e=1&" + href.substring (2);
                        }

                        Palabra p = new Palabra (elem.text, enlaceRecurso: href);
                        def += p.texto;
                        palabras.add (p);

                    } else {

                        Palabra p = new Palabra (
                            elem.text
                            , dataId: (elem.attributes.containsKey ("data-id"))?
                                       elem.attributes ["data-id"] : null

                        );
                        def += p.texto;
                        palabras.add (p);
                    }

                    break;

                case dom.Node.TEXT_NODE:
                    /* Texto plano => se añade sin más */
                    Palabra p = new Palabra (nodo.text);
                    def += p.texto;
                    palabras.add (p);
                    break;

                default:
                    Logger ("Acepc.claseJ").warning ("Tipo de nodo desconocido: "
                        + "${nodo.nodeType} > $nodo"
                    );
            }

            idx++;
        }


        return Acepc (
            n_acep, gram, def, palabras
            , clase: ClaseAcepc.normal, uso: uso
            , id: par.id
        );
    }

    /**
     * Constructor para las acepciones con class="j" o class="j2".
     * Extrae la información necesaria del elemento de tipo [dom.Element]
     *
     * Para otros tipos de acepciones, ver [Acepc.claseJ()] y [Acepc.claseL()]
     *
     * @param par: [dom.Element]
     *      Párrafo dentro del cual está toda la información de esta acepción
     */
    factory Acepc.claseM (dom.Element par) {

        /* Las entradas son idénticas */
        return Acepc.claseJ (par);
    }


    /**
     * Constructor para las acepciones con class="l".
     * Extrae la información necesaria del elemento de tipo [dom.Element]
     *
     * Para otros tipos de acepciones, ver [Acepc.claseJ()] y [Acepc.claseM()]
     *
     * @param par: [dom.Element]
     */
    factory Acepc.claseL (dom.Element par) {

        /* Por ejemplo: <a class="a" href="/?id=OF9CzGo#BweCq9Y">mano de gato</a> */
        ClaseAcepc clase = ClaseAcepc.enlace;

        if (par.children.length != 1) {

            Logger ("Acepc.claseL").warning ("Se esperaba un elemento, llegaron "
                + "${par.children.length}"
            );
        }

        /* Se podría realizar una petición para obtener la definición; pero de momento
        se deja como está. */
        String href = par.firstChild.attributes ["href"];

        if (href.startsWith ("/?id=")) {

            href = "/?e=1&" + href.substring (2);
        }
        String def = par.firstChild.text;
        Palabra p = new Palabra (def, enlaceRecurso: href);

        return Acepc(-1, "", def, [ p ], clase: clase);
    }


    /**
     * Representación de este objeto en una cadena de texto
     */
    @override
    String toString () {

        return "\tAtributos de esta instancia de 'Acepc':\n"
            + ((this.id == null)? "": "\t=> ID de la entrada: ${this.id}\n")
            + "\t=> Tipo de entrada: ${this.clase}\n"
            + "\t=> Número de acepción: ${this.num_acep}\n"
            + "\t=> Gramática: ${this.gram}\n"
            + ((this.uso.isEmpty)? "": "\t=> Uso: ${this.uso}\n")
            + "\t=> Palabras: ${this.palabras}\n"
            + "\t=> Texto de la acepción: ${this.texto}\n"
        ;
    }

}

