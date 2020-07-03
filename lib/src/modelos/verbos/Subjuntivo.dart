import 'TiempoVerbal.dart';

class Subjuntivo {

    /**
     * Presente.
     */
    final TiempoVerbal presente;

    /**
     * Futuro simple.
     */
    final TiempoVerbal futuro;

    /**
     * Pretérito imperfecto.
     */
    final TiempoVerbal pret_imperf;

    Subjuntivo (
        this.presente,
        this.futuro,
        this.pret_imperf
    );
}
