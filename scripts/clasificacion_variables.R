%load_ext rpy2.ipython

%%R
# clasificacion_variables.R — Parte A: clasificación de las variables de clientes.csv.

url_clientes <- "https://raw.githubusercontent.com/EmiTitu/IDSD422-lab-muestreo-poblacion/main/data/clientes.csv"
clientes <- read.csv(url_clientes, stringsAsFactors = FALSE)

# ---------------------------------------------------------------------------
# 1. Estructura del archivo
cat(sprintf("Dimensiones: %d filas × %d columnas\n", nrow(clientes), ncol(clientes)))
print(clientes)
cat("\n")

# ---------------------------------------------------------------------------
# 2. Tipos inferidos (str)
str(clientes)
cat("\n")

# ---------------------------------------------------------------------------
# 3. Valores únicos — ¿cuántas categorías hay y cuáles son?
for (columna in names(clientes)) {
  unicos <- unique(clientes[[columna]])
  cat(sprintf("Columna '%s' (%d únicos): %s\n", columna, length(unicos), paste(unicos, collapse = ", ")))
}
cat("\n")

# ---------------------------------------------------------------------------
# 4. Declarar el orden de las variables ordinales
clientes$nivel_educacion <- factor(
  clientes$nivel_educacion,
  levels = c("Primaria", "Secundaria", "Superior", "Posgrado"),
  ordered = TRUE
)
cat("Nivel educación ordenado (min):", as.character(min(clientes$nivel_educacion)), "\n")

clientes$satisfaccion <- factor(
  clientes$satisfaccion,
  levels = c(1, 2, 3, 4, 5),
  ordered = TRUE
)
cat("Satisfacción ordenada (min):", as.character(min(clientes$satisfaccion)), "\n")
cat("\n")

# ---------------------------------------------------------------------------
# 5. Resumen de la clasificación (para el informe)
clasificacion <- c(
  cliente_id         = "Cualitativa nominal (Identificador)",
  edad               = "Cuantitativa discreta",
  numero_hijos       = "Cuantitativa discreta",
  genero             = "Cualitativa nominal",
  nivel_educacion    = "Cualitativa ordinal",
  ciudad             = "Cualitativa nominal",
  ingresos_mensuales = "Cuantitativa continua",
  satisfaccion       = "Cualitativa ordinal"
)
cat("Resumen de la clasificación (para el informe):\n")
for (variable in names(clasificacion)) {
  cat(sprintf("  %-18s %s\n", variable, clasificacion[[variable]]))
}