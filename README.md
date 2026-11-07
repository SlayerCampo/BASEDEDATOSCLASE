# Gestión de la Información — Momento 2

**Docente:** Prof. Laura Melisa Tique Arprilla  
**Integrantes:**
- Alejandro Campo Solarte
- Daniel Amelines Pacheco

Este repositorio contiene la entrega del **Momento 2** para la asignatura **Gestión de la Información**, implementando el sistema relacional **Atmoscope** para monitoreo ambiental y calidad del aire sobre MySQL 8.0 y Docker Compose.

## Requisitos previos

- Tener instalado [Docker](https://www.docker.com/products/docker-desktop/) en tu sistema (Docker Desktop para Windows).

## Servicios incluidos

### 1. PostgreSQL

- **Host**: `localhost`
- **Puerto**: `5432`
- **Base de Datos**: `clase_pg`
- **Usuario**: `alumno`
- **Contraseña**: `secreta`
- **Interfaz gráfica**: **pgAdmin** en [http://localhost:5050](http://localhost:5050)
  - Usuario: `admin@clase.com`
  - Contraseña: `admin`

### 2. MySQL

- **Host**: `localhost`
- **Puerto**: `3306`
- **Base de Datos**: `atmoscope_db`
- **Usuario**: `alumno`
- **Contraseña**: `secreta`
- **Interfaz gráfica**: **phpMyAdmin** en [http://localhost:8080](http://localhost:8080)

## Cómo iniciar el entorno

Para levantar todos los contenedores en segundo plano (detached mode), abre tu terminal en esta carpeta y ejecuta:

```bash
docker-compose up -d
```

Para detener el entorno sin borrar los datos:

```bash
docker-compose stop
```

Para detener y destruir los contenedores (las bases de datos mantendrán sus datos gracias a los volúmenes de Docker, a menos que uses `-v`):

```bash
docker-compose down
```

## Scripts de inicialización

Puedes agregar archivos `.sql` en las carpetas `init/postgres` o `init/mysql`.
Estos scripts se ejecutarán automáticamente **la primera vez** que se cree y se inicie la base de datos, lo cual es ideal para crear tablas o insertar datos iniciales automáticamente.

El archivo `init/mysql/init.sql` crea y puebla automáticamente la base de datos
`atmoscope_db` con el modelo de monitoreo climático de Atmoscope. Si el volumen
`mysql_data` ya fue creado, los scripts de inicialización no se vuelven a
ejecutar; para reconstruir MySQL desde cero usa:

```bash
docker compose down -v
docker compose up -d mysql
```

## Entregable Momento 2

Toda la documentación formal requerida para la entrega del **Momento 2** (Diagrama Entidad-Relación, Modelo Lógico Normalizado, Diccionario de Datos, Justificación de Negocio y Resultados de las 5 Consultas `SELECT`) se encuentra en:

- [ENTREGABLE_MOMENTO_2.md](ENTREGABLE_MOMENTO_2.md)
- Script SQL completo estructurado por bloques (DDL, INSERTs y SELECTs): [init/mysql/init.sql](init/mysql/init.sql)
