import 'package:html/dom.dart' as dom;
import 'package:json_annotation/json_annotation.dart';

import 'Imperativo.dart';
import 'Indicativo.dart';
import 'Subjuntivo.dart';
import 'TiempoVerbal.dart';

/* Para la serialización */
part 'Conjug.g.dart';


@JsonSerializable(
    fieldRename: FieldRename.snake,
    explicitToJson: true
)
class Conjug {

    /*
        Todos los verbos van a tener siempre todos los tiempos verbales. Si no, es que el
        Apocalipsis ha llegado y ya nada merece la pena...
    */

    /* FORMAS NO PERSONALES */

    @JsonKey(required: true)
    final String infinitivo;
    @JsonKey(required: true)
    final String participio;
    @JsonKey(required: true)
    final String gerundio;

    /* FORMAS PERSONALES */

    /**
     * Indicativo.
     */
    @JsonKey(required: true)
    final Indicativo indicativo;

    /**
     * Subjuntivo.
     */
    @JsonKey(required: true)
    final Subjuntivo subjuntivo;

    /**
     * Imperativo.
     */
    @JsonKey(required: true)
    final Imperativo imperativo;

    /*******************/
    /** SERIALIZACIÓN **/
    /*******************/
    /* https://flutter.dev/docs/development/data-and-backend/json#code-generation */

    /// A necessary factory constructor for creating a new User instance
    /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
    /// The constructor is named after the source class, in this case, User.
    factory Conjug.fromJson(Map<String, dynamic> json) => _$ConjugFromJson (json);

    /// `toJson` is the convention for a class to declare support for serialization
    /// to JSON. The implementation simply calls the private, generated
    /// helper method `_$UserToJson`.
    Map<String, dynamic> toJson () => _$ConjugToJson (this);



    Conjug (
        this.infinitivo,
        this.participio,
        this.gerundio,
        this.indicativo,
        this.subjuntivo,
        this.imperativo
    );


    /**
     * Extrae toda la información necesaria del elemento de tipo 'div' especificado.
     * Debería tener id="conjugacion", aunque eso no se comprueba en este método.
     *
     * @param article: [dom.Element]
     *              Elemento raíz que contiene toda la información de esta entrada.
     */
    factory Conjug.fromDiv (dom.Element div) {
        /*
            ├── <div id="conjugacion"> <-- Elemento que se le ha pasado a este método
            │   └── <article>
            │       └── <table>
            │            └── <tbody> <-- Contenedor principal de la conjugación


            Dentro de este "tbody", la información se presenta en diferentes filas (
            elementos de tipo <tr>). En orden (denominados por su índice en la lista),
            son:
             0: Contiene la cabecera "Formas no personales".
             1: Contiene las cabeceras "Infinitivo" y "Gerundio".
             2:
                <td> -+
                <td>  |- Vacíos
                <td> -+
                <td> --- this.infinitivo
                <td> --- this.gerundio
             3: Cabecera "Participio".
             4:
                <td> -+
                <td>  |- Vacíos
                <td> -+
                <td colspan="2"> --- this.participio
             5: Cabecera "Indicativo"
             6: Cabeceras "Presente" y "Pretérito imperfecto / copretérito".
             7-14:
                <td> -+
                <td>  |- Cabeceras
                <td> -+
                <td> -- Forma correspondiente del presente de indicativo
                <td> -- Forma correspondiente del pretérito imperfecto de indicativo
            15: Cabeceras "Pretérito perfecto simple" y "Futuro simple"
            16-23:
                <td> -+
                <td>  |- Cabeceras
                <td> -+
                <td> -- Forma correspondiente del pretérito perfecto simple de indicativo
                <td> -- Forma correspondiente del futuro de indicativo
            24: Cabecera "Condicional"
            25-32:
                <td> -+
                <td>  |- Cabeceras
                <td> -+
                <td colspan="2"> -- Forma correspondiente del condicional de indicativo
            33: Cabecera "Subjuntivo"
            34: Cabeceras "Presente" y "Futuro simple / futuro"
            35-42:
                <td> -+
                <td>  |- Cabeceras
                <td> -+
                <td> -- Forma correspondiente del presente de subjuntivo
                <td> -- Forma correspondiente del futuro de subjuntivo
            43: Cabecera "Pretérito imperfecto / pretérito"
            44-51:
                <td> -+
                <td>  |- Cabeceras
                <td> -+
                <td colspan="2"> -- Forma correspondiente del pretérito imperfecto de subjuntivo
            52: Cabecera "Imperativo"
            53: Cabeceras
            54-57:
                <td> -+
                <td>  |- Cabeceras
                <td> -+
                <td colspan="2"> -- Forma correspondiente del presente de imperativo
        */
        List<dom.Element> tabla = div.querySelector ("tbody").children;

        Function obtener = (i, j) => tabla [i].children [j].text;

        String infinitivo = tabla [2].children [3].text;
        String participio = tabla [4].children [3].text;
        String gerundio = tabla [2].children [4].text;

        Indicativo indicativo = Indicativo (
            /* presente */
            TiempoVerbal (
                /* nombre */
                "presente",
                /* sing_seg => tú/vos + " " + ustedes */
                [ obtener (8, 3), obtener (9, 3) ],
                /* plural_seg => vosotros/vosotras + " " + ustedes  */
                [ obtener (12, 3), obtener (13, 3) ],

                /* sing_prim */
                sing_prim: obtener (7, 3),
                /* sing_terc */
                sing_terc: obtener (10, 3),

                /* plural_prim */
                plural_prim: obtener (11, 3),
                /* plural_terc */
                plural_terc: obtener (14, 3),
            ),
            /* pret_imperf */
            TiempoVerbal (
                /* nombre */
                "pretérito imperfecto / copretérito",
                /* sing_seg => tú/vos + " " + ustedes */
                [ obtener (8, 4), obtener (9, 4)],
                /* plural_seg => vosotros/vosotras + " " + ustedes  */
                [ obtener (12, 4), obtener (13, 4)],

                /* sing_prim */
                sing_prim: obtener (7, 4),
                /* sing_terc */
                sing_terc: obtener (10, 4),

                /* plural_prim */
                plural_prim: obtener (11, 4),
                /* plural_terc */
                plural_terc: obtener (14, 4)
            ),
            /* pret_perf_simple */
            TiempoVerbal (
                /* nombre */
                "pretérito perfecto simple / pretérito",
                /* sing_seg => tú/vos + " " + ustedes */
                [ obtener (17, 3), obtener (18, 3) ],
                /* plural_seg => vosotros/vosotras + " " + ustedes  */
                [ obtener (21, 3), obtener (22, 3) ],

                /* sing_prim */
                sing_prim: obtener (16, 3),
                /* sing_terc */
                sing_terc: obtener (19, 3),

                /* plural_prim */
                plural_prim: obtener (20, 3),
                /* plural_terc */
                plural_terc: obtener (23, 3),
            ),
            /* futuro */
            TiempoVerbal (
                /* nombre */
                "futuro simple / futuro",
                /* sing_seg => tú/vos + " " + ustedes */
                [ obtener (17, 4), obtener (18, 4)],
                /* plural_seg => vosotros/vosotras + " " + ustedes  */
                [ obtener (21, 4), obtener (22, 4)],

                /* sing_prim */
                sing_prim: obtener (16, 4),
                /* sing_terc */
                sing_terc: obtener (19, 4),

                /* plural_prim */
                plural_prim: obtener (20, 4),
                /* plural_terc */
                plural_terc: obtener (23, 4),
            ),
            /* condicional */
            TiempoVerbal (
                /* nombre */
                "condicional simple / pospretérito",
                /* sing_seg => tú/vos + " " + ustedes */
                [ obtener (26, 3), obtener (27, 3) ],
                /* plural_seg => vosotros/vosotras + " " + ustedes  */
                [ obtener (30, 3), obtener (31, 3) ],

                /* sing_prim */
                sing_prim: obtener (25, 3),
                /* sing_terc */
                sing_terc: obtener (28, 3),

                /* plural_prim */
                plural_prim: obtener (29, 3),
                /* plural_terc */
                plural_terc: obtener (32, 3),
            ),
        );

        Subjuntivo subjuntivo = Subjuntivo (
            /* presente */
            TiempoVerbal (
                /* nombre */
                "presente",
                /* sing_seg => tú/vos + " " + ustedes */
                [ obtener (36, 3), obtener (37, 3) ],
                /* plural_seg => vosotros/vosotras + " " + ustedes  */
                [ obtener (40, 3), obtener (41, 3) ],

                /* sing_prim */
                sing_prim: obtener (35, 3),
                /* sing_terc */
                sing_terc: obtener (38, 3),

                /* plural_prim */
                plural_prim: obtener (39, 3),
                /* plural_terc */
                plural_terc: obtener (42, 3)
            ),
            /* futuro */
            TiempoVerbal (
                /* nombre */
                "futuro simple / futuro",
                /* sing_seg => tú/vos + " " + ustedes */
                [ obtener (36, 4), obtener (37, 4) ],
                /* plural_seg => vosotros/vosotras + " " + ustedes  */
                [ obtener (40, 4), obtener (41, 4) ],

                /* sing_prim */
                sing_prim: obtener (35, 4),
                /* sing_terc */
                sing_terc: obtener (38, 4),

                /* plural_prim */
                plural_prim: obtener (39, 4),
                /* plural_terc */
                plural_terc: obtener (42, 4)
            ),
            /* pretérito imperfecto */
            TiempoVerbal (
                /* nombre */
                "pretérito imperfecto / pretérito",
                /* sing_seg => tú/vos + " " + ustedes */
                [ obtener (45, 3), obtener (46, 3) ],
                /* plural_seg => vosotros/vosotras + " " + ustedes  */
                [ obtener (49, 3), obtener (50, 3) ],

                /* sing_prim */
                sing_prim: obtener (44, 3),
                /* sing_terc */
                sing_terc: obtener (47, 3),

                /* plural_prim */
                plural_prim: obtener (48, 3),
                /* plural_terc */
                plural_terc: obtener (51, 3),
            ),
        );

        Imperativo imperativo = Imperativo (
            /* presente */
            TiempoVerbal (
                "presente",
                /* sing_seg => tú/vos + " " + ustedes */
                [ obtener (54, 3), obtener (55, 3) ],
                /* plural_seg => vosotros/vosotras + " " + ustedes  */
                [ obtener (56, 3), obtener (57, 3) ]
            )
        );


        return Conjug (
            infinitivo,
            participio,
            gerundio,
            indicativo,
            subjuntivo,
            imperativo
        );
    }



    /**
     * Representación de este objeto en una cadena de texto
     */
    @override
    String toString () {

        return "Atributos de esta instancia de 'Conjug':\n"
                + "\t=> Infinitivo: $infinitivo\n"
                + "\t=> Participio: $participio\n"
                + "\t=> Gerundio: $gerundio\n"
                + "\t=> Indicativo: $indicativo\n"
                + "\t=> Subjuntivo: $subjuntivo\n"
                + "\t=> Imperativo: $imperativo\n";
    }

}
