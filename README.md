# RAE scraper

Este es un pequeño scraper para obtener las definiciones de una palabra.
La idea con este proyecto es aprender a programar en Dart, por lo que puede que haya algunas decisiones de diseño que no tengan más sentido que aprender a usar funcionalidades nuevas.


La idea es que se pueda usar como una biblioteca.
Un ejemplo de uso para implementar una utilidad por línea de comandos se encuentra en `examples/rae_scraper.dart`.



Para usar la biblioteca, simplemente basta con añadir la dependencia en el _pubspec.yaml_ del proyecto:

```
dependencies:
  rae_scraper:
    git:
      url: git://github.com/Foo-Manroot/rae_scraper.git
      ref: master
```

e importartla en el archivo actual:

```
import 'package:rae_scraper/rae_scraper.dart';
```


Una vez importado el paquete, se pueden obtener las definiciones instanciando un objeto tal como se muestra aquí:
```
Scraper a = Scraper ();
a.obtenerDef ([PALABRA A BUSCAR]);
```


Esto devuelve los resultados obtenidos y los muestra por pantalla.
El resultado que se devuelve es una instancia de la clase `Resultado` (en un `Future`, lo que hay que tener en cuenta si se quieren manipular estos resultados).

Este resultado tiene los siguientes atributos (se puede consultar con más detalle el código fuente en `lib/src/modelos/Resultado.dart`):
  - `List<Entrada> entradas`: Lista de entradas aplicables a esta palabra
  - `List<String> otras`: Enlaces a otras entradas similares


Por su parte, `Entrada` tiene los siguientes atributos:
  - `List<Definic> definiciones`: Lista con todas las acepciones encontradas
  - `String title`: Normalmente, _"definición de [PALABRA]"_
  - `String etim`: Etimología
  - `String id`: Identificador dentro del HTML, referenciable mediante la URL (con `#`)


`Definic` es una clase abstracta para albergar todos los tipos de definiciones posibles (`Acepc` y `Expr`). Los atributos comunes para todas son:
  - `String id`: Identificador dentro del HTML, referenciable mediante la URL (con `#`)
  - `ClaseAcepc clase`: Permite diferenciar el tipo de acepción


En concreto, las clases implementadoras son:

`Acepc`, una acepción normal. Sus atributos son:
  - `int num_acep`: Número de la acepción
  - `String gram`: Clasificación gramatical
  - `List<String> uso`: Especificaciones extra sobre el uso, como la zona en la que se usa, si es un vulgarismo, etc.
  - `String texto`: Texto plano de la acepción.
  - `List<Palabra> palabras`:Objetos de tipo Palabra que componen esta acepción.


`Expr`, una expresión popular, con los siguientes atributos:
  - `String texto`: Texto de la expresión.
  - `List<Acepc> definiciones`: Lista de acepciones con las que se define esta frase hecha.



Por último, las unidades mínimas semánticas se almacenan en el objeto `Palabra`.
Este objeto permite guardar los enlaces directos a sus definiciones.
Estos enlaces son de la forma `[urlBase]/?e=1&id=[dataId]&w=[texto]` (el último parámetro parece ser opcional) y generan menos tráfico de red porque devuelven directamente el HTML de la entrada, sin el resto de la página.
Sus atributos son:

  - `String abbr`: Si se puede abreviar (por ejemplo, centímetro -> cm.), se usa este atributo para almacenar la abreviatura.
  - `String texto`: Texto completo de la palabra. Si se trata de una abreviatura, en este atributo se almacenará la palabra completa.
  - `String dataId`: Identificador para obtener la definición de esta palabra (explicado un párrafo más arriba). Complementario de `enlaceRecurso`, siendo este último la opción preferente.
  - `String enlaceRecurso`: Enlace al recurso necesario para obtener la definción de esta palabra, si está disponible. Se crea en base a `dataId` al construir el objeto.



----


**TODO**:

  1. Obtener la palabra del día
  2. Implementar `Palabra.obtenerDef()`
