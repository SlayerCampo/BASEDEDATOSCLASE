-- ============================================================================
-- PROYECTO: ATMOSCOPE - SISTEMA DE MONITOREO DE CALIDAD DEL AIRE
-- ASIGNATURA: GESTIÓN DE LA INFORMACIÓN
-- DOCENTE: PROF. LAURA MELISA TIQUE ARPRILLA
-- INTEGRANTES:
--   - ALEJANDRO CAMPO SOLARTE
--   - DANIEL AMELINES PACHECO
-- ENTREGABLE: MOMENTO 2 (DDL, DML - INSERT, DML - SELECT)
-- MOTOR DE BASE DE DATOS: MySQL 8.0+ (InnoDB)
-- ============================================================================

-- ============================================================================
-- BLOQUE 1: IMPLEMENTACIÓN DDL (LENGUAJE DE DEFINICIÓN DE DATOS)
-- Creación del esquema, tablas, claves primarias (PK), claves foráneas (FK)
-- con reglas de integridad referencial y restricciones (NOT NULL, UNIQUE,
-- CHECK y DEFAULT).
-- ============================================================================

CREATE DATABASE IF NOT EXISTS atmoscope_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE atmoscope_db;

-- 1. Tabla Continente
CREATE TABLE IF NOT EXISTS Continente (
    id_continente INT NOT NULL,
    nombre_continente VARCHAR(100) NOT NULL,
    codigo_iso CHAR(2) NOT NULL DEFAULT 'UN',
    PRIMARY KEY (id_continente),
    UNIQUE KEY uq_continente_nombre (nombre_continente),
    CONSTRAINT chk_continente_id CHECK (id_continente > 0)
) ENGINE = InnoDB;

-- 2. Tabla Pais
CREATE TABLE IF NOT EXISTS Pais (
    codigo_pais CHAR(3) NOT NULL,
    nombre_pais VARCHAR(100) NOT NULL,
    id_continente INT NOT NULL,
    monitoreo_activo TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (codigo_pais),
    UNIQUE KEY uq_pais_nombre (nombre_pais),
    CONSTRAINT fk_pais_continente
        FOREIGN KEY (id_continente) REFERENCES Continente (id_continente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_pais_monitoreo CHECK (monitoreo_activo IN (0, 1))
) ENGINE = InnoDB;

-- 3. Tabla Estacion
CREATE TABLE IF NOT EXISTS Estacion (
    id_estacion VARCHAR(10) NOT NULL,
    nombre_estacion VARCHAR(100) NOT NULL,
    latitud DECIMAL(9,6) NOT NULL,
    longitud DECIMAL(9,6) NOT NULL,
    codigo_pais CHAR(3) NOT NULL,
    estado_operativo VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',
    PRIMARY KEY (id_estacion),
    UNIQUE KEY uq_estacion_nombre (nombre_estacion),
    CONSTRAINT fk_estacion_pais
        FOREIGN KEY (codigo_pais) REFERENCES Pais (codigo_pais)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_estacion_latitud CHECK (latitud BETWEEN -90.000000 AND 90.000000),
    CONSTRAINT chk_estacion_longitud CHECK (longitud BETWEEN -180.000000 AND 180.000000),
    CONSTRAINT chk_estacion_estado CHECK (estado_operativo IN ('ACTIVA', 'MANTENIMIENTO', 'INACTIVA'))
) ENGINE = InnoDB;

-- 4. Tabla Contaminante
CREATE TABLE IF NOT EXISTS Contaminante (
    id_contaminante INT NOT NULL,
    nombre_contaminante VARCHAR(50) NOT NULL,
    unidad_medida VARCHAR(20) NOT NULL DEFAULT 'ug/m3',
    limite_peligroso DECIMAL(6,2) NOT NULL,
    PRIMARY KEY (id_contaminante),
    UNIQUE KEY uq_contaminante_nombre (nombre_contaminante),
    CONSTRAINT chk_contaminante_id CHECK (id_contaminante > 0),
    CONSTRAINT chk_contaminante_limite CHECK (limite_peligroso > 0)
) ENGINE = InnoDB;

-- 5. Tabla Registro_Calidad
CREATE TABLE IF NOT EXISTS Registro_Calidad (
    id_registro INT NOT NULL AUTO_INCREMENT,
    id_estacion VARCHAR(10) NOT NULL,
    id_contaminante INT NOT NULL,
    fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor_medido DECIMAL(6,2) NOT NULL,
    PRIMARY KEY (id_registro),
    CONSTRAINT fk_registro_estacion
        FOREIGN KEY (id_estacion) REFERENCES Estacion (id_estacion)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_registro_contaminante
        FOREIGN KEY (id_contaminante) REFERENCES Contaminante (id_contaminante)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_registro_valor CHECK (valor_medido >= 0)
) ENGINE = InnoDB;

-- 6. Tabla Usuario
CREATE TABLE IF NOT EXISTS Usuario (
    id_usuario INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL,
    rol VARCHAR(30) NOT NULL DEFAULT 'CIUDADANO',
    fecha_creacion DATE NOT NULL DEFAULT (CURRENT_DATE),
    PRIMARY KEY (id_usuario),
    UNIQUE KEY uq_usuario_username (username),
    UNIQUE KEY uq_usuario_email (email),
    CONSTRAINT chk_usuario_email CHECK (email LIKE '%_@_%._%'),
    CONSTRAINT chk_usuario_rol CHECK (rol IN ('ADMIN', 'INVESTIGADOR', 'ANALISTA', 'CIUDADANO'))
) ENGINE = InnoDB;

-- 7. Tabla Usuario_Estacion (Relación Muchos a Muchos desglosada)
CREATE TABLE IF NOT EXISTS Usuario_Estacion (
    id_usuario INT NOT NULL,
    id_estacion VARCHAR(10) NOT NULL,
    fecha_agregado DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notificaciones_activas TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id_usuario, id_estacion),
    CONSTRAINT fk_usuario_estacion_usuario
        FOREIGN KEY (id_usuario) REFERENCES Usuario (id_usuario)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_usuario_estacion_estacion
        FOREIGN KEY (id_estacion) REFERENCES Estacion (id_estacion)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT chk_usuario_estacion_notif CHECK (notificaciones_activas IN (0, 1))
) ENGINE = InnoDB;


-- ============================================================================
-- BLOQUE 2: POBLADO DE DATOS (DML - INSERT)
-- Requisito: Mínimo 5 registros coherentes por cada tabla manteniendo
-- la integridad referencial y lógica del negocio.
-- ============================================================================

-- 1. Poblado de Continente (5 registros)
INSERT INTO Continente (id_continente, nombre_continente, codigo_iso) VALUES
    (1, 'America', 'AM'),
    (2, 'Asia', 'AS'),
    (3, 'Europa', 'EU'),
    (4, 'Africa', 'AF'),
    (5, 'Oceania', 'OC');

-- 2. Poblado de Pais (7 registros)
INSERT INTO Pais (codigo_pais, nombre_pais, id_continente, monitoreo_activo) VALUES
    ('COL', 'Colombia', 1, 1),
    ('MEX', 'Mexico', 1, 1),
    ('JPN', 'Japon', 2, 1),
    ('CHN', 'China', 2, 1),
    ('DEU', 'Alemania', 3, 1),
    ('EGY', 'Egipto', 4, 1),
    ('AUS', 'Australia', 5, 1);

-- 3. Poblado de Estacion (6 registros)
INSERT INTO Estacion (
    id_estacion, nombre_estacion, latitud, longitud, codigo_pais, estado_operativo
) VALUES
    ('COLBOG001', 'Bogota Centro', 4.711000, -74.072100, 'COL', 'ACTIVA'),
    ('COLMED001', 'Medellin Poblado', 6.208800, -75.569700, 'COL', 'ACTIVA'),
    ('MEXCDMX01', 'CDMX Reforma', 19.432600, -99.133200, 'MEX', 'MANTENIMIENTO'),
    ('JPTYO001', 'Tokyo Shinjuku', 35.693800, 139.703400, 'JPN', 'ACTIVA'),
    ('CHNBEI001', 'Beijing Chaoyang', 39.921900, 116.443600, 'CHN', 'ACTIVA'),
    ('DEUBER001', 'Berlin Mitte', 52.520000, 13.405000, 'DEU', 'ACTIVA');

-- 4. Poblado de Contaminante (5 registros)
INSERT INTO Contaminante (
    id_contaminante, nombre_contaminante, unidad_medida, limite_peligroso
) VALUES
    (1, 'PM2.5', 'ug/m3', 35.00),
    (2, 'PM10', 'ug/m3', 50.00),
    (3, 'O3', 'ug/m3', 100.00),
    (4, 'NO2', 'ug/m3', 40.00),
    (5, 'SO2', 'ug/m3', 20.00);

-- 5. Poblado de Registro_Calidad (20 registros)
INSERT INTO Registro_Calidad (
    id_estacion, id_contaminante, fecha_hora, valor_medido
) VALUES
    ('COLBOG001', 1, '2026-09-29 08:00:00', 42.80),
    ('COLBOG001', 2, '2026-09-29 08:00:00', 68.40),
    ('COLBOG001', 1, '2026-09-29 16:00:00', 31.20),
    ('COLBOG001', 4, '2026-09-29 18:00:00', 45.10),
    ('COLMED001', 1, '2026-09-29 08:00:00', 28.60),
    ('COLMED001', 2, '2026-09-29 08:00:00', 45.90),
    ('COLMED001', 1, '2026-09-29 16:00:00', 39.70),
    ('MEXCDMX01', 1, '2026-09-29 09:00:00', 52.30),
    ('MEXCDMX01', 3, '2026-09-29 14:00:00', 115.40),
    ('JPTYO001', 1, '2026-09-29 09:00:00', 18.40),
    ('JPTYO001', 2, '2026-09-29 09:00:00', 32.10),
    ('JPTYO001', 1, '2026-09-29 18:00:00', 22.80),
    ('CHNBEI001', 1, '2026-09-29 09:00:00', 76.50),
    ('CHNBEI001', 2, '2026-09-29 09:00:00', 124.30),
    ('CHNBEI001', 1, '2026-09-29 18:00:00', 68.90),
    ('CHNBEI001', 5, '2026-09-29 20:00:00', 29.50),
    ('DEUBER001', 1, '2026-09-29 10:00:00', 11.60),
    ('DEUBER001', 2, '2026-09-29 10:00:00', 24.80),
    ('COLBOG001', 1, '2026-09-30 08:00:00', 47.10),
    ('CHNBEI001', 2, '2026-09-30 08:00:00', 137.60);

-- 6. Poblado de Usuario (6 registros)
INSERT INTO Usuario (username, email, rol, fecha_creacion) VALUES
    ('SlayerCampo', 'slayercampo@atmoscope.local', 'ADMIN', '2026-09-01'),
    ('ClimaAdmin', 'climaadmin@atmoscope.local', 'ADMIN', '2026-09-05'),
    ('DraElenaVargas', 'evargas@institutoambiental.org', 'INVESTIGADOR', '2026-09-10'),
    ('CarlosAnalista', 'cmendoza@datosclima.co', 'ANALISTA', '2026-09-12'),
    ('LauraCiudadana', 'laura.gomez@correo.com', 'CIUDADANO', '2026-09-15'),
    ('PedroObservador', 'pedro.ruiz@correo.com', 'CIUDADANO', '2026-09-20');

-- 7. Poblado de Usuario_Estacion (6 registros)
INSERT INTO Usuario_Estacion (
    id_usuario, id_estacion, fecha_agregado, notificaciones_activas
) VALUES
    (1, 'COLBOG001', '2026-09-01 14:30:00', 1),
    (1, 'CHNBEI001', '2026-09-02 09:15:00', 1),
    (2, 'JPTYO001', '2026-09-05 11:00:00', 1),
    (3, 'COLMED001', '2026-09-11 08:20:00', 1),
    (3, 'MEXCDMX01', '2026-09-11 08:25:00', 0),
    (4, 'DEUBER001', '2026-09-14 16:45:00', 1);


-- ============================================================================
-- BLOQUE 3: CONSULTAS DE SELECCIÓN (DML - SELECT)
-- 5 consultas orientadas a resolver necesidades puntuales del negocio.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- CONSULTA 1: Filtro Condicional 1 (WHERE, BETWEEN, AND, LIKE, ORDER BY DESC)
-- Justificación de negocio: El equipo de vigilancia epidemiológica de Colombia
-- necesita auditar las mediciones registradas en las estaciones de su país
-- (cuyo código inicia por 'COL') durante la jornada crítica del 29 de
-- septiembre de 2026 que presenten concentraciones entre 30 y 100 unidades,
-- ordenadas desde la lectura más alta hasta la más baja para priorizar alertas.
-- ----------------------------------------------------------------------------
SELECT
    id_registro,
    id_estacion,
    id_contaminante,
    fecha_hora,
    valor_medido
FROM Registro_Calidad
WHERE id_estacion LIKE 'COL%'
  AND fecha_hora BETWEEN '2026-09-29 00:00:00' AND '2026-09-29 23:59:59'
  AND valor_medido >= 30.00
ORDER BY valor_medido DESC;

-- ----------------------------------------------------------------------------
-- CONSULTA 2: Filtro Condicional 2 (WHERE, IN, NOT, AND, ORDER BY ASC)
-- Justificación de negocio: La dirección de operaciones requiere un listado
-- de estaciones ubicadas en mercados estratégicos (Colombia, México, Japón y
-- China) que NO se encuentren fuera de servicio ('INACTIVA') y estén en el
-- hemisferio norte (latitud > 0), ordenadas alfabéticamente por nombre.
-- ----------------------------------------------------------------------------
SELECT
    id_estacion,
    nombre_estacion,
    codigo_pais,
    latitud,
    longitud,
    estado_operativo
FROM Estacion
WHERE codigo_pais IN ('COL', 'MEX', 'JPN', 'CHN')
  AND NOT estado_operativo = 'INACTIVA'
  AND latitud > 0
ORDER BY nombre_estacion ASC;

-- ----------------------------------------------------------------------------
-- CONSULTA 3: Combinación de Tablas 1 (INNER JOIN entre 5 tablas)
-- Justificación de negocio: Generar el reporte oficial de "Excedencias de
-- Límite Peligroso" cruzando las mediciones con la información geográfica
-- completa (Estación, País, Continente) y los umbrales de cada Contaminante,
-- mostrando únicamente aquellos eventos donde el valor medido superó el
-- límite peligroso establecido por la norma.
-- ----------------------------------------------------------------------------
SELECT
    r.id_registro,
    ct.nombre_continente AS continente,
    p.nombre_pais AS pais,
    e.nombre_estacion AS estacion,
    c.nombre_contaminante AS contaminante,
    r.valor_medido,
    c.limite_peligroso,
    ROUND(r.valor_medido - c.limite_peligroso, 2) AS exceso_sobre_norma,
    r.fecha_hora
FROM Registro_Calidad r
INNER JOIN Estacion e ON r.id_estacion = e.id_estacion
INNER JOIN Pais p ON e.codigo_pais = p.codigo_pais
INNER JOIN Continente ct ON p.id_continente = ct.id_continente
INNER JOIN Contaminante c ON r.id_contaminante = c.id_contaminante
WHERE r.valor_medido > c.limite_peligroso
ORDER BY exceso_sobre_norma DESC;

-- ----------------------------------------------------------------------------
-- CONSULTA 4: Combinación de Tablas 2 (LEFT JOIN para auditoría de adopción)
-- Justificación de negocio: El equipo de experiencia de usuario necesita
-- visualizar a TODOS los usuarios registrados en la plataforma junto con las
-- estaciones que tienen suscritas, incluyendo explícitamente aquellos usuarios
-- que aún no han vinculado ninguna estación (valores NULL) para enviarles una
-- campaña de activación.
-- ----------------------------------------------------------------------------
SELECT
    u.id_usuario,
    u.username,
    u.email,
    u.rol,
    ue.id_estacion,
    e.nombre_estacion,
    ue.fecha_agregado
FROM Usuario u
LEFT JOIN Usuario_Estacion ue ON u.id_usuario = ue.id_usuario
LEFT JOIN Estacion e ON ue.id_estacion = e.id_estacion
ORDER BY u.id_usuario ASC;

-- ----------------------------------------------------------------------------
-- CONSULTA 5: Funciones de Agregación y Agrupamiento (GROUP BY, HAVING,
-- COUNT, AVG, MAX, MIN)
-- Justificación de negocio: La junta ambiental internacional solicita un
-- resumen estadístico por estación y tipo de contaminante que calcule el total
-- de muestras tomadas, el promedio, el valor mínimo y el pico máximo,
-- filtrando mediante HAVING únicamente aquellos grupos cuyo promedio de
-- contaminación supere los 35.00 ug/m3 (zonas de riesgo crónico).
-- ----------------------------------------------------------------------------
SELECT
    e.id_estacion,
    e.nombre_estacion,
    c.nombre_contaminante,
    COUNT(r.id_registro) AS total_mediciones,
    ROUND(AVG(r.valor_medido), 2) AS promedio_medido,
    MIN(r.valor_medido) AS lectura_minima,
    MAX(r.valor_medido) AS lectura_maxima
FROM Registro_Calidad r
INNER JOIN Estacion e ON r.id_estacion = e.id_estacion
INNER JOIN Contaminante c ON r.id_contaminante = c.id_contaminante
GROUP BY e.id_estacion, e.nombre_estacion, c.nombre_contaminante
HAVING AVG(r.valor_medido) > 35.00
ORDER BY promedio_medido DESC;
