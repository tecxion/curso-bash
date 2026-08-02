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
# Crear el destino si no existe antes de obtener su ruta
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
find "$DESTINO" -maxdepth 1 -type f -name "respaldo_*.tar.gz" -mtime +7 | while read -r archivo_viejo; do
    if rm -f "$archivo_viejo"; then
        log_message "INFO" "Rotado (eliminado) respaldo antiguo: $(basename "$archivo_viejo")"
    else
        log_message "WARNING" "No se pudo eliminar el respaldo antiguo: $archivo_viejo"
    fi
done

log_message "SUCCESS" "Proceso de respaldo finalizado correctamente."
exit 0
