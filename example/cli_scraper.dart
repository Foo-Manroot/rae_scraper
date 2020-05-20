import 'package:rae_scraper/rae_scraper.dart';



void main (List<String> argv) {


    String texto_ayuda = "Uso: dart cli_scraper.dart [opciones | <PALABRA>]\n"
            + "\n"
            + "Donde:\n"
            + "\t<PALABRA>\n"
                + "\t\tPalabra que se desea buscar, incluyendo todas las tildes "
                + "necesarias\n"
            + "\n"
            + "\t-h\n"
            + "\t--help\n"
                + "\t\tMuestra este texto de ayuda\n"
    ;

    if (argv.length == 1) {

        switch (argv [0]) {

            case "-h":
            case "--help":
                print (texto_ayuda);
                break;

            default:
                Scraper a = Scraper ();
                print (a.toString ());
                a.obtenerDef (
                    argv [0],
                    manejadorExcepc: (e) => print ("Excepción => $e")
                );
        }

    } else {

        print ("ERROR: se necesita un solo argumento\n\n" + texto_ayuda);
    }

    print ("Fin de main()");
}
