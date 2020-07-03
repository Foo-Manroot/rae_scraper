import 'TiempoVerbal.dart';

class Indicativo {

    /**
     * Presente.
     */
    final TiempoVerbal presente;

    /**
     * Pretérito imperfecto.
     */
    final TiempoVerbal pret_imperf;

    /**
     * Pretérito perfecto simple.
     */
    final TiempoVerbal pret_perf_simple;

    /**
     * Futuro simple.
     */
    final TiempoVerbal futuro;

    /**
     * Condicional simple.
     */
    final TiempoVerbal condicional;



    Indicativo (
        this.presente,
        this.pret_imperf,
        this.pret_perf_simple,
        this.futuro,
        this.condicional
    );
}
