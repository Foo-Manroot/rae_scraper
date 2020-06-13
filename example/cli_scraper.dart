import 'package:rae_scraper/rae_scraper.dart';
import 'package:logging/logging.dart';


void main (List<String> argv) async {

    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
        print('${record.level.name} @ ${record.loggerName}: ${record.time}: ${record.message}');
    });

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
                Scraper a = Scraper ()
                                ..MAX_CACHE_SIZE = 20
                ;
                print (a.toString ());

                await a.obtenerDef (
                    argv [0],
                    manejadorExcepc: (e) => print ("Excepción en petic. 1 => $e"),
                    manejadorError: (e) => print ("Excepción en petic. 1 => $e")
                ).then (
                    (Resultado res) => (res == null)? null :  res.mostrarResultados ()
                );

                for (int i = 0; i <= 4; i++)  {
                    /* Cache hit */
                    await a.obtenerDef (
                        "gato",
                        manejadorExcepc: (e) => print ("Excepción en petic. 1 => $e"),
                        manejadorError: (e) => print ("Excepción en petic. 1 => $e")
//                  ).then (
//                      (Resultado res) => (res == null)? null :  res.mostrarResultados ()
//                ).whenComplete (
//                    () => a.dispose ()
                    );
                }

                /********************/
                /* Segunda petición */
                /********************/

                Palabra p = Palabra (
                      "asdf", dataId: "XhbjsNo#ETrKQH3"
                );

                for (int i = 0; i <= 4; i++)  {
                    await p.obtenerDef (a);
                }

                for (int i = 0; i <= 4; i++)  {
                    await a.obtenerDef ("asdf");
                }

                for (int i = 0; i <= 4; i++)  {
                    await a.obtenerDef ("pepinillo").whenComplete (
                        () => a.dispose ()
                    );
                }
        }

    } else {

        print ("ERROR: se necesita un solo argumento\n\n" + texto_ayuda);
    }

    print ("Fin de main()");
}
