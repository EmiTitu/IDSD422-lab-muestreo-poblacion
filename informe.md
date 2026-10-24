# Informe: Tipos de variables y muestras de clientes

Para: Gerencia de RetailAndina S.A. · De: Equipo de Business Intelligence
Fecha: 23/10/2026 · Asunto: Base de fidelización: tipos de variables y cálculo con muestras

---

## Resumen ejecutivo

Clasifiqué las 8 variables de la base de clientes y probé tres formas de elegir una muestra de 20 clientes (por conveniencia, al azar y por grupos) para calcular el ingreso mensual promedio de los 400 clientes de RetailAndina. La muestra por conveniencia solo tomó clientes de Quito y dejó fuera a Guayaquil y Cuenca, mientras que las otras dos sí incluyeron a las tres ciudades. Antes de decidir con una muestra, la gerencia debe saber que el resultado cambia según los clientes que salgan elegidos, y que importa más cómo se eligen que cuántos son.

## Parte A: Clasificación de las variables

Estos datos vienen del archivo clientes.csv (12 filas y 8 columnas).

| Variable | Tipo | Justificación (criterio) | Verificación en código |
|---|---|---|---|
| `cliente_id` | Cualitativa nominal (identificador) | Solo sirve para identificar a cada cliente. | dtype: object, 12 valores únicos. |
| `edad` | Cuantitativa discreta | Se registra en años completos. | dtype: int64, 12 valores únicos. |
| `numero_hijos` | Cuantitativa discreta | No existe la mitad de un hijo; solo hay números enteros. | dtype: int64, 5 valores únicos (0, 1, 2, 3, 4). |
| `genero` | Cualitativa nominal | Describe al cliente y sus opciones no tienen un orden. | dtype: object, 3 valores únicos (Femenino, Masculino, Otro). |
| `nivel_educacion` | Cualitativa ordinal | Sus opciones tienen un orden: Primaria, Secundaria, Universidad y Posgrado. | dtype: object, 4 valores únicos; se declaró el orden y el menor fue Primaria. |
| `ciudad` | Cualitativa nominal | Indica dónde vive el cliente y las ciudades no tienen un orden. | dtype: object, 3 valores únicos (Quito, Guayaquil, Cuenca). |
| `ingresos_mensuales` | Cuantitativa continua | Es dinero y puede tener centavos, o sea, tiene sentido la mitad de una unidad. | dtype: int64, 12 valores únicos. |
| `satisfaccion` | Cualitativa ordinal | Va de menos a más satisfacción, pero los números no son cantidades. | dtype: int64, 4 valores únicos (2, 3, 4, 5); se declaró con orden. |

P1. ¿Qué te dijo el dtype de `satisfaccion` y por qué no basta para clasificarla? ¿Qué pasa si una ordinal queda como texto sin declarar el orden?

La variable satisfaccion estaba guardada como número entero (int64), pero esos números son niveles de satisfacción, no cantidades: un 4 no significa el doble de un 2. Por eso el dtype no basta, porque solo dice cómo se guardó el dato y no qué significa. La declaré con orden para poder calcular bien la mediana y los percentiles. Si una variable ordinal queda como texto sin orden, el programa ordena sus opciones por letra (por ejemplo, Posgrado antes que Primaria) y los resultados salen mal.

## Parte B: Población vs. muestra

Estos datos vienen del archivo clientes_400.csv. Las cifras son de la ejecución en Python.

### La población y su parámetro

| Concepto | Valor |
|---|---|
| Población (N) | 400 clientes (Quito: 200, Guayaquil: 120, Cuenca: 80) |
| Variable de interés | `ingresos_mensuales` |
| Parámetro poblacional (media) | 1330.72 USD |

¿Por qué se usa una muestra si aquí el parámetro existe y se calculó? Porque en la vida real revisar a todos los clientes puede costar mucho, demorar o no se puede. En este ejercicio sí conocemos el valor real, así que sirve para ver qué tan bien funciona cada forma de elegir la muestra.

### Los tres diseños

| Diseño | n | Media estimada | Composición por ciudad | Diferencia vs. parámetro |
|---|---|---|---|---|
| Conveniencia (`head`) | 20 | 1348.50 USD | Quito: 20, Guayaquil: 0, Cuenca: 0 | +17.78 USD |
| Aleatorio simple (`sample`) | 20 | 1336.00 USD | Quito: 8, Guayaquil: 4, Cuenca: 8 | +5.28 USD |
| Estratificado (`groupby` + 5 %) | 20 | 1287.50 USD | Quito: 10, Guayaquil: 6, Cuenca: 4 | -43.22 USD |

Para ver cuánto cambia el resultado según los clientes que se sortean, repetí el muestreo aleatorio simple en Python con las semillas 1 a 5 y calculé la media de cada sorteo:

| Semilla | 1 | 2 | 3 | 4 | 5 |
|---|---|---|---|---|---|
| Media (USD) | 1336.00 | 1405.00 | 1235.00 | 1491.50 | 1288.00 |

P2. ¿Cuánto vale el parámetro poblacional y cuánto estimó cada diseño? ¿Cuál quedó más cerca y por qué eso no alcanza para declarar un ganador?

El promedio real de ingresos de los 400 clientes es 1330.72 USD. La muestra por conveniencia dio 1348.50 USD, la aleatoria simple 1336.00 USD y la estratificada 1287.50 USD. La que quedó más cerca fue la aleatoria simple, con una diferencia de solo +5.28 USD. Pero eso no alcanza para decir que es la mejor, porque fue un solo sorteo y pudo salir bien por suerte. Al repetirlo con otras semillas, los resultados fueron de 1235.00 a 1491.50 USD, y en un caso quedó a 160.78 USD del promedio real. La muestra por conveniencia también pudo acercarse por casualidad, aunque la forma de elegirla no es buena.

P3. La muestra por conveniencia también tiene 20 filas. ¿Qué defecto tiene y cómo lo delatas en la composición por ciudad? ¿Se corrige tomando más filas?

Su defecto es que no representa a todos los clientes, porque solo toma los primeros de la lista. Se nota en las ciudades: los 20 clientes son de Quito y no hay ninguno de Guayaquil ni de Cuenca, que juntas son la mitad de la población. Tomar más filas no lo arregla, porque seguiría eligiendo de la misma forma. Lo que hay que cambiar es la manera de elegir la muestra (al azar o por grupos).

P4. El sorteo aleatorio dio un número distinto en cada semilla. ¿Qué implica esa variabilidad para una empresa que va a decidir con un solo estudio?

Significa que el resultado depende de qué clientes salgan en el sorteo. En los cinco sorteos el promedio varió unos 256 USD, entre 1235.00 y 1491.50. Por eso, si una empresa decide con un solo estudio, puede pensar que sus clientes ganan más o menos de lo que realmente ganan. Es mejor repetir el muestreo y ver cuánto cambian los resultados antes de decidir.

P5. ¿Cuándo usarías cada diseño en la práctica?

- Conveniencia: para una prueba piloto o un estudio rápido, cuando hay poco tiempo o pocos recursos, sin querer sacar conclusiones sobre todos los clientes.
- Aleatorio simple: cuando se tiene la lista completa de clientes y se quiere una conclusión sobre toda la población.
- Estratificado: cuando hay grupos que sí o sí deben aparecer en la muestra, como Quito, Guayaquil y Cuenca.

## Conclusiones

1. Hay que clasificar bien las variables. Lo que muestra el programa no siempre dice cómo analizar una variable: satisfaccion estaba guardada como número, pero en realidad es una escala con orden.
2. La muestra por conveniencia puede dejar fuera partes importantes de los clientes. Los 20 elegidos eran de Quito y no salió ninguno de Guayaquil ni de Cuenca, y tomar más filas de la misma forma no lo soluciona.
3. Los resultados cambian según los clientes que salgan elegidos. Antes de aceptar un análisis hecho con una muestra, le recomendaría a la gerencia preguntar cómo se eligió, qué ciudades incluye y cuánto cambian los resultados, en lugar de confiar en un solo número.