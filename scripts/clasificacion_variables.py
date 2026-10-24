# clasificacion_variables.py — Parte A: clasificación de las variables de clientes.csv.
#
# El archivo data/clientes.csv tiene 12 clientes y 7 variables (más el id).
# El objetivo: clasificar cada variable (numérica continua/discreta, categórica
# binaria/ordinal/nominal) y verificar la clasificación en código.
#
# Regla del capítulo 3: el dtype es una pista, no la clasificación — el criterio
# (¿tiene sentido la mitad del valor? ¿hay orden entre las categorías?) decide.
#
# Uso (desde la raíz del repositorio):  python scripts/clasificacion_variables.py

import pandas as pd

# Carga de datos
url_clientes = "https://raw.githubusercontent.com/EmiTitu/IDSD422-lab-muestreo-poblacion/main/data/clientes.csv"
clientes = pd.read_csv(url_clientes)

# ---------------------------------------------------------------------------
# 1. Estructura del archivo
# ---------------------------------------------------------------------------
print(f"Dimensiones: {clientes.shape[0]} filas × {clientes.shape[1]} columnas")
print()
print("Primeras filas:")
print(clientes.to_string(index=False))
print()

# ---------------------------------------------------------------------------
# 2. Tipos inferidos (dtype) — la pista que da el lenguaje
# ---------------------------------------------------------------------------
print("Tipos inferidos (dtype):")
print(clientes.dtypes)
print()
# TODO 1: ¿qué columnas llegan como número y cuáles como texto? Anótalo para el
#         informe. Ojo con satisfaccion: llega como número y es ordinal
#         ("4 no es el doble de 2") — la justificación va en el informe.

# ---------------------------------------------------------------------------
# 3. Valores únicos — ¿cuántas categorías hay y cuáles son?
# ---------------------------------------------------------------------------
# TODO 2: completa el bucle para imprimir, por columna, cuántos valores únicos
#         hay y cuáles son. Pista: for columna in clientes.columns: ...  con
#         clientes[columna].unique() y len(). ¿Cuántas categorías tiene genero?
for columna in clientes.columns:
    unicos = clientes[columna].unique()
    print(f"Columna '{columna}' ({len(unicos)} únicos): {list(unicos)}")
print()

# ---------------------------------------------------------------------------
# 4. Declarar el orden de las variables ordinales
# ---------------------------------------------------------------------------
# Una ordinal se guarda como texto (o como número) y su orden natural se pierde:
# alfabéticamente "Posgrado" iría antes que "Primaria", que no tiene sentido.
#
# TODO 3: convierte nivel_educacion a categoría ordenada.
#         Pista: astype(pd.CategoricalDtype(categories=[...], ordered=True)).
#         Comprueba con .min(): debe devolver "Primaria".
clientes["nivel_educacion"] = clientes["nivel_educacion"].astype(
    pd.CategoricalDtype(categories=["Primaria", "Secundaria", "Superior", "Posgrado"], ordered=True)
)
print("Nivel educación ordenado (min):", clientes["nivel_educacion"].min())

# TODO 4: haz lo mismo con satisfaccion (escala 1–5 como etiquetas ordenadas).
#         Prueba extra: ¿qué pasa si en la lista de categorías escribes
#         "Postgrado" (con t) para nivel_educacion? Cuenta los faltantes con
#         .isna().sum() — la trampa del typo es silenciosa.
clientes["satisfaccion"] = clientes["satisfaccion"].astype(
    pd.CategoricalDtype(categories=[1, 2, 3, 4, 5], ordered=True)
)
print("Satisfacción ordenada (min):", clientes["satisfaccion"].min())

# Prueba extra opcional del typo (descomenta si deseas probarla en la consola):
# nivel_con_typo = clientes["nivel_educacion"].astype(pd.CategoricalDtype(categories=["Primaria", "Secundaria", "Superior", "Postgrado"], ordered=True))
# print("Valores faltantes por typo en 'Postgrado':", nivel_con_typo.isna().sum())
print()

# ---------------------------------------------------------------------------
# 5. Resumen de la clasificación (para el informe)
# ---------------------------------------------------------------------------
# TODO 5: completa el resumen con el tipo de cada variable (el criterio que
#         justifica cada clasificación va en el informe).
clasificacion = {
    "cliente_id": "Cualitativa nominal (Identificador)",
    "edad": "Cuantitativa discreta",
    "numero_hijos": "Cuantitativa discreta",
    "genero": "Cualitativa nominal",
    "nivel_educacion": "Cualitativa ordinal",
    "ciudad": "Cualitativa nominal",
    "ingresos_mensuales": "Cuantitativa continua",
    "satisfaccion": "Cualitativa ordinal",
}
print("Resumen de la clasificación (para el informe):")
for variable, tipo in clasificacion.items():
    print(f"  {variable:20s} {tipo}")