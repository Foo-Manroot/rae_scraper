import 'Indicativo.dart';
import 'Subjuntivo.dart';
import 'Imperativo.dart';

class Conjug {

    /*
        Todos los verbos van a tener siempre todos los tiempos verbales. Si no, es que el
        Apocalipsis ha llegado y ya nada merece la pena...
    */

    /* FORMAS NO PERSONALES */

    final String infinitivo;
    final String participio;
    final String gerundio;

    /* FORMAS PERSONALES */

    /*============*/
    /* INDICATIVO */
    /*============*/

    /**
     * Presente.
     * Indicativo.
     */
    final Indicativo presente;

    /**
     * Pretérito imperfecto.
     * Indicativo.
     */
    final Indicativo pret_imperf;

    /**
     * Pretérito perfecto simple.
     * Indicativo.
     */
    final Indicativo pret_perf_simple;

    /**
     * Futuro simple.
     * Indicativo.
     */
    final Indicativo futuro;

    /**
     * Condicional simple.
     * Indicativo.
     */
    final Indicativo condicional;

    /*============*/
    /* SUBJUNTIVO */
    /*============*/

    /**
     * Presente simple.
     * Sub
     */
    final Subjuntivo presente_subj;


    Conjug (
        this.presente
    );
}
