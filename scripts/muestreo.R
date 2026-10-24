%load_ext rpy2.ipython
%%R
# muestreo.R — Parte B: población vs. muestra (RetailAndina).
#
# La población es la base completa de fidelización: data/clientes_400.csv (N = 400).
# La pregunta de negocio: ¿cuál es el ingreso mensual promedio de los clientes?

url_400 <- "https://raw.githubusercontent.com/EmiTitu/IDSD422-lab-muestreo-poblacion/main/data/clientes_400.csv"
poblacion <- read.csv(url_400)

reporte <- function(nombre, muestra, parametro) {
  if (is.null(muestra)) {
    cat(sprintf("[%s] pendiente de completar (TODO)\n", nombre))
    return(invisible(NULL))
  }
  media <- mean(muestra$ingresos_mensuales)
  cat(sprintf("[%s] n=%d  media=%.2f USD  (parámetro %.2f, diferencia %+.2f)\n",
              nombre, nrow(muestra), media, parametro, media - parametro))
  cat("    composición por ciudad: ")
  print(table(muestra$ciudad))
}

# ---------------------------------------------------------------------------
# 1. La población y su parámetro (N = 400)
# ---------------------------------------------------------------------------
cat(sprintf("Población: %d clientes × %d columnas\n", nrow(poblacion), ncol(poblacion)))
parametro <- mean(poblacion$ingresos_mensuales)
cat(sprintf("Parámetro poblacional — ingreso medio: %.2f USD\n", parametro))
cat("Ciudades en la población: "); print(table(poblacion$ciudad))
cat("\n")

# ---------------------------------------------------------------------------
# 2. Muestra por conveniencia: "los primeros que llegaron"
# ---------------------------------------------------------------------------
muestra_conv <- head(poblacion, 20)

# ---------------------------------------------------------------------------
# 3. Muestra aleatoria simple: el sorteo de 20
# ---------------------------------------------------------------------------
set.seed(1)
muestra_aas <- poblacion[sample(nrow(poblacion), 20), ]

# ---------------------------------------------------------------------------
# 4. Muestra estratificada: 5 % dentro de cada ciudad
# ---------------------------------------------------------------------------
suppressPackageStartupMessages(library(dplyr))
set.seed(1)
muestra_est <- poblacion |> group_by(ciudad) |> slice_sample(prop = 0.05)

# ---------------------------------------------------------------------------
# 5. Comparación final
# ---------------------------------------------------------------------------
reporte("Conveniencia", muestra_conv, parametro)
reporte("Aleatorio simple", muestra_aas, parametro)
reporte("Estratificado", muestra_est, parametro)
cat("\n")

if (!is.null(muestra_conv) && !is.null(muestra_aas) && !is.null(muestra_est)) {
  resumen <- data.frame(
    diseno = c("Conveniencia (head)", "Aleatorio simple (sample)", "Estratificado (slice_sample)"),
    n = c(nrow(muestra_conv), nrow(muestra_aas), nrow(muestra_est)),
    media_estimada = round(c(mean(muestra_conv$ingresos_mensuales),
                             mean(muestra_aas$ingresos_mensuales),
                             mean(muestra_est$ingresos_mensuales)), 2)
  )
  cat(sprintf("Parámetro poblacional: %.2f USD\n", parametro))
  print(resumen, row.names = FALSE)
  cat("Con estas salidas responde en informe.md las preguntas P2 a P5:\n")
  cat("  P2: ¿cuál diseño quedó más cerca del parámetro y por qué un solo\n")
  cat("      número no basta para declarar un ganador?\n")
  cat("  P3: ¿qué defecto tiene la muestra por conveniencia y cómo lo delata\n")
  cat("      su composición por ciudad? ¿Se corrige con más filas?\n")
  cat("  P4: ¿qué implica la variabilidad entre semillas para una decisión\n")
  cat("      tomada con un solo estudio?\n")
  cat("  P5: ¿cuándo usarías cada diseño? (piloto · subgrupos · conclusión)\n")
} else {
  cat("Completa los TODO 1 a 4 para ver la tabla comparativa.\n")
}