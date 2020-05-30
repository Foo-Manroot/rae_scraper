

class Uso {

    /** Abreviatura usada para denotar este uso. */
    final String abrev;

    /** Lista con las posibles interpretaciones de la abreviación. */
    final List<String> significado;


    /** Constructor por defecto.
     * Simplemente inicializa todas las variables.
     */
    Uso (this.abrev, this.significado);


    /**
     * Representación de este objeto en una cadena de texto
     */
    @override
    String toString () {

        return "\tAtributos de esta instancia de 'Uso':\n"
            + "\t=> Abreviatura: ${this.abrev}\n"
            + "\t=> Significado: ${this.significado}\n"
        ;
    }

}
