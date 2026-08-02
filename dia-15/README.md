![Titulo](assets/cursobash.png)
[Día 14](./dia-14/README.md) -- [Inicio](./README.md)

# 📅 Día 15: Automatización y Proyecto Final

¡Has llegado al último día! Hoy completaremos el bloque avanzado aprendiendo a programar la ejecución periódica de nuestros scripts sin intervención humana utilizando **cron** y **crontab**. Además, diseñaremos e implementaremos un **Proyecto Final Integrador**: un script de copia de seguridad automatizado y robusto que reúne prácticamente todos los conceptos que has aprendido a lo largo de estos 15 días.

---

## 📘 Planificación de Tareas con `cron`

En Unix, `cron` es un demonio (proceso en segundo plano que corre continuamente) que ejecuta scripts o comandos a intervalos de tiempo específicos.

### La Tabla de Cron: `crontab`

Cada usuario del sistema tiene su propio archivo de configuración llamado **crontab** (cron table) donde define sus tareas programadas.

#### Comandos de administración:

- `crontab -e`: Abre tu editor para editar tu crontab.
- `crontab -l`: Lista tus tareas programadas activas.
- `crontab -r`: Elimina todas tus tareas programadas.

---

### La Sintaxis de una Regla de Cron

Una línea de crontab consta de 5 campos de tiempo seguidos del comando a ejecutar:

```text
.---------------- minuto (0 - 59)
|  .------------- hora (0 - 23)
|  |  .---------- día del mes (1 - 31)
|  |  |  .------- mes (1 - 12)
|  |  |  |  .---- día de la semana (0 - 6) (Domingo = 0)
|  |  |  |  |
*  *  *  *  *  /ruta/al/script.sh
```

#### Ejemplos comunes de programación:

- `* * * * * /script.sh` -> Ejecuta el script **cada minuto**.
- `0 * * * * /script.sh` -> Ejecuta **cada hora** (en el minuto 0).
- `30 8 * * * /script.sh` -> Ejecuta **todos los días a las 08:30 AM**.
- `0 0 * * 0 /script.sh` -> Ejecuta **todos los domingos a medianoche (00:00)**.
- `0 4 1,15 * * /script.sh` -> Ejecuta **los días 1 y 15 de cada mes a las 04:00 AM**.

> [!IMPORTANT]
> Los scripts ejecutados por `cron` corren en un entorno minimalista sin sesión de usuario. Esto significa que variables como `$PATH` pueden no estar completas. **Usa siempre rutas absolutas en crontab** (tanto para el script como para los comandos y archivos dentro de tus scripts).
>
> **Redirección en Cron**: Como cron se ejecuta en segundo plano, cualquier salida de pantalla (`stdout`/`stderr`) se perderá o generará correos internos del sistema. Redirecciona siempre la salida a un archivo log:
> `30 2 * * * /home/usuario/scripts/backup.sh >> /home/usuario/logs/backup.log 2>&1`

---

## 🏆 Proyecto Final Integrador: Script de Copia de Seguridad Avanzado (`respaldador.sh`)

### Objetivo:

Desarrollar un script robusto para automatizar copias de seguridad de una carpeta (por ejemplo, documentos o código) comprimiéndolas en formato `.tar.gz`, gestionando la rotación de archivos antiguos para no saturar el disco, y registrando cada evento detalladamente en un log.

### Especificaciones del Script:

1.  **Parámetros**: Debe aceptar dos argumentos: `<directorio_origen>` y `<directorio_destino>`.
2.  **Validación**:
    - Verificar que se hayan pasado exactamente 2 argumentos.
    - Verificar que el directorio de origen exista.
    - Si el directorio de destino no existe, crearlo automáticamente.
3.  **Compresión**: Crear un archivo de respaldo con el formato `respaldo_YYYY-MM-DD_HHMMSS.tar.gz`.
4.  **Limpieza (Rotación)**: Buscar y eliminar de forma automática todos los respaldos que tengan **más de 7 días** de antigüedad en la carpeta de destino.
5.  **Registro de Logs**: Escribir en un archivo llamado `reporte_respaldos.log` en el directorio de destino con cada evento. El log debe contener marcas de tiempo y registrar el éxito o el error de las operaciones.
6.  **Robustez**: Utilizar el modo estricto de Bash y una función de limpieza asociada a `trap` en caso de salida.

---

### Código Completo de Referencia del Proyecto Final

He creado la solución completa para ti en el archivo [respaldador.sh](file:///x:/project1/curso-bash/dia-15/scripts/respaldador.sh) dentro de la carpeta de scripts. A continuación puedes analizar el código estructurado paso a paso con comentarios explicativos:

```bash
#!/usr/bin/env bash
# ==============================================================================
# SCRIPT DE RESPALDO AUTOMATIZADO CON ROTACIÓN DE LOGS Y HISTORIAL
# ==============================================================================
set -euo pipefail

# Variables Globales
ORIGEN="${1:-}"
DESTINO="${2:-}"
LOG_FILE=""
TEMP_DIR=""

# Función para imprimir mensajes en el log y consola
log_message() {
    local nivel="$1"
    local mensaje="$2"
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] [$nivel] - $mensaje"

    # Escribir en el log si la variable está inicializada
    if [[ -n "$LOG_FILE" ]]; then
        echo "[$timestamp] [$nivel] - $mensaje" >> "$LOG_FILE"
    fi
}

# Función de limpieza en caso de fallos
limpiar_temporales() {
    if [[ -d "$TEMP_DIR" ]]; then
        log_message "INFO" "Limpiando directorio temporal de trabajo..."
        rm -rf "$TEMP_DIR"
    fi
}
trap limpiar_temporales EXIT

# 1. Validar Argumentos
if [[ -z "$ORIGEN" || -z "$DESTINO" ]]; then
    echo "Error de uso: $0 <directorio_origen> <directorio_destino>"
    exit 1
fi

# Convertir a rutas absolutas reales
ORIGEN=$(realpath "$ORIGEN")
# Nota: Si el destino no existe, realpath fallará si no usamos una ruta existente primero.
# Por lo tanto, creamos el destino si no existe antes de obtener su ruta.
if [[ ! -d "$DESTINO" ]]; then
    mkdir -p "$DESTINO"
fi
DESTINO=$(realpath "$DESTINO")
LOG_FILE="$DESTINO/reporte_respaldos.log"

log_message "INFO" "Iniciando proceso de respaldo..."
log_message "INFO" "Origen: $ORIGEN"
log_message "INFO" "Destino: $DESTINO"

# 2. Validar que el origen exista y sea legible
if [[ ! -d "$ORIGEN" ]]; then
    log_message "ERROR" "El directorio de origen '$ORIGEN' no existe o no es accesible."
    exit 1
fi

# 3. Crear directorio temporal para el proceso
TEMP_DIR=$(mktemp -d)
log_message "INFO" "Creado directorio de trabajo temporal: $TEMP_DIR"

# 4. Generar nombre del archivo de respaldo
FECHA=$(date "+%Y-%m-%d_%H%M%S")
ARCHIVO_RESPALDO="respaldo_$FECHA.tar.gz"

# 5. Ejecutar la compresión
log_message "INFO" "Comprimiendo carpeta..."
if tar -czf "$TEMP_DIR/$ARCHIVO_RESPALDO" -C "$ORIGEN" . ; then
    mv "$TEMP_DIR/$ARCHIVO_RESPALDO" "$DESTINO/"
    TAMANIO=$(du -sh "$DESTINO/$ARCHIVO_RESPALDO" | cut -f1)
    log_message "SUCCESS" "Respaldo creado con éxito: $ARCHIVO_RESPALDO ($TAMANIO)"
else
    log_message "ERROR" "Fallo al comprimir el directorio de origen."
    exit 1
fi

# 6. Rotación de respaldos antiguos (Borrar los que tengan más de 7 días)
log_message "INFO" "Buscando respaldos antiguos para depuración (límite: 7 días)..."
# Buscamos en el destino archivos con nombre respaldo_*.tar.gz que lleven más de 7 días sin modificarse
# y los eliminamos registrando su nombre en el log.
find "$DESTINO" -maxdepth 1 -type f -name "respaldo_*.tar.gz" -mtime +7 | while read -r archivo_viejo; do
    if rm -f "$archivo_viejo"; then
        log_message "INFO" "Rotado (eliminado) respaldo antiguo: $(basename "$archivo_viejo")"
    else
        log_message "WARNING" "No se pudo eliminar el respaldo antiguo: $archivo_viejo"
    fi
done

log_message "SUCCESS" "Proceso de respaldo finalizado correctamente."
exit 0
```

---

## 💻 Ejercicios Finales de Automatización

### Nivel Fácil

1. Escribe la línea de crontab para programar la ejecución de un script de limpieza `/root/scripts/clean.sh` todos los domingos a las 3:00 de la madrugada.

### Nivel Medio

1. Programa una regla de cron que ejecute el script `respaldador.sh` todos los días a las 23:00 (11:00 PM). Configura los argumentos para respaldar tu carpeta de proyectos `/home/usuario/proyecto` en el disco de respaldo `/backups` y redirecciona toda la salida (incluidos errores) a `/backups/cron_cron.log`.

### Nivel Difícil

1. **Puesta en Marcha**:
   - Crea las carpetas `origen_prueba` y `destino_prueba` en tu terminal. Añade algunos archivos de texto dentro de `origen_prueba`.
   - Ejecuta el script [respaldador.sh](file:///x:/project1/curso-bash/dia-15/scripts/respaldador.sh) pasándole las carpetas de pruebas como argumentos.
   - Verifica que se ha creado el archivo `.tar.gz` y el archivo de log en `destino_prueba`.
   - Inspecciona el contenido del log usando `cat`.

---

## 🎉 ¡Felicidades!

¡Has completado el curso **Aprende Bash en 15 días**! Ahora tienes un entendimiento profundo del sistema operativo Unix, sabes moverte con soltura por la CLI, puedes manipular flujos de datos en pipelines avanzados, procesar datos textuales pesados y construir scripts de automatización robustos, seguros y profesionales.

El siguiente paso es aplicar este conocimiento en tus tareas diarias. ¡Automatiza todo lo que puedas!
