# Carpeta de Capturas de Pantalla (Evidencias de Ejecución)

Esta carpeta contiene las **13 capturas de pantalla reales** tomadas desde **phpMyAdmin (MySQL 8.0.46)** como evidencia de la ejecución completa del Momento 2:

1. [`00_conexion_phpmyadmin.png`](00_conexion_phpmyadmin.png) — Conexión activa al servidor MySQL 8.0.46 en Docker (`utf8mb4_unicode_ci`) y visualización del esquema `atmoscope_db`.
2. [`01_ddl_disenador_tablas.png`](01_ddl_disenador_tablas.png) — Vista del **Diseñador** en phpMyAdmin mostrando las 7 tablas y sus relaciones de clave foránea (DDL).
3. [`02_dml_filas_pobladas.png`](02_dml_filas_pobladas.png) — Pestaña **Estructura** de `atmoscope_db` evidenciando las 7 tablas creadas y el conteo de filas pobladas ($\ge 5$ registros por tabla, 55 filas en total).
4. [`03a_select_filtro_1_sentencia.png`](03a_select_filtro_1_sentencia.png) — Sentencia SQL de la **Consulta 1** (Filtro condicional con `WHERE`, `LIKE`, `BETWEEN`, `AND` y `ORDER BY DESC`).
5. [`03b_select_filtro_1_resultado.png`](03b_select_filtro_1_resultado.png) — Tabla de resultados devuelta por el gestor para la **Consulta 1** (6 filas).
6. [`04a_select_filtro_2_sentencia.png`](04a_select_filtro_2_sentencia.png) — Sentencia SQL de la **Consulta 2** (Filtro condicional con `WHERE`, `IN`, `NOT`, `AND` y `ORDER BY ASC`).
7. [`04b_select_filtro_2_resultado.png`](04b_select_filtro_2_resultado.png) — Tabla de resultados devuelta por el gestor para la **Consulta 2** (5 filas).
8. [`05a_select_inner_join_sentencia.png`](05a_select_inner_join_sentencia.png) — Sentencia SQL de la **Consulta 3** (`INNER JOIN` entre 5 tablas para reporte de excedencias sobre límite peligroso).
9. [`05b_select_inner_join_resultado.png`](05b_select_inner_join_resultado.png) — Tabla de resultados devuelta por el gestor para la **Consulta 3** (12 filas).
10. [`06a_select_left_join_sentencia.png`](06a_select_left_join_sentencia.png) — Sentencia SQL de la **Consulta 4** (`LEFT JOIN` para auditoría de adopción de usuarios con y sin estaciones).
11. [`06b_select_left_join_resultado.png`](06b_select_left_join_resultado.png) — Tabla de resultados devuelta por el gestor para la **Consulta 4** (8 filas, mostrando `NULL` en usuarios sin estación).
12. [`07a_select_group_having_sentencia.png`](07a_select_group_having_sentencia.png) — Sentencia SQL de la **Consulta 5** (`GROUP BY`, `HAVING` y funciones de agregación `COUNT`, `AVG`, `MIN`, `MAX`).
13. [`07b_select_group_having_resultado.png`](07b_select_group_having_resultado.png) — Tabla de resultados devuelta por el gestor para la **Consulta 5** (8 filas agrupadas).
