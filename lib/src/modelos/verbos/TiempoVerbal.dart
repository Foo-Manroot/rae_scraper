
/**
 * Almacena todas las formas verbales de un tiempo verbal (pretérito pluscuamperfecto,
 * futuro simple...) para todos los sujetos
 */
class TiempoVerbal {

    /**
     * Nombre del tiempo verbal (presente simple, pretérito imperfecto...)
     */
    final String nombre;

    /* En todos los modos, existe al menos la segunda persona del singular y plural. El
    resto son opcionales (el imperativo sólo tiene segunda persona) */

    /*==========*/
    /* SINGULAR */
    /*==========*/

    /**
     * Primera persona del singular: Yo
     */
    final String sing_prim;

    /**
     * Segunda persona del singular: Tú / Vos / Usted
     */
    final String sing_seg;

    /**
     * Tercera persona del singular: Ella / Él
     */
    final String sing_terc;


    /*========*/
    /* PLURAL */
    /*========*/

    /**
     * Primera persona del plural: Nosotras / Nosotros
     */
    final String plural_prim;

    /**
     * Segunda persona del plural: Vosotras / Vosotros / Ustedes
     */
    final String plural_seg;

    /**
     * Tercera persona del plural: Ellas / Ellos
     */
    final String plural_terc;



    TiempoVerbal (
        this.nombre,
        this.sing_seg,
        this.plural_seg,

        { this.sing_prim,
        this.sing_terc,

        this.plural_prim,
        this.plural_terc }
    );

}
