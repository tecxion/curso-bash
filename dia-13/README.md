<h3 align="center">
<a href="../dia-12/README.md">Día 12</a> | <a href="../README.md"> Inicio del Curso </a> | <a href="../dia-14/README.md">Día 14</a>
</h3>

![Titulo](../assets/cursobash.png)

# 📅 Día 13: Búsquedas, Compresión y Red

Hoy aprenderemos tres habilidades críticas para cualquier administrador de sistemas o desarrollador: buscar archivos bajo criterios complejos, empaquetar y comprimir información para respaldos, e interactuar con la red para transferir archivos y consumir servicios web desde la consola.

---

## 📘 Búsquedas Avanzadas con `find`

El comando `find` busca archivos y directorios de manera recursiva en el árbol de directorios basándose en filtros avanzados.

### Opciones de Filtro más Comunes:

- `-name "patrón"`: Filtra por nombre (sensible a mayúsculas. Usa `-iname` para ignorar).
- `-type f` / `-type d`: Busca solo archivos (`f`) o directorios (`d`).
- `-size +10M`: Busca archivos de tamaño mayor a 10 Megabytes (puedes usar `-10M` para menores, o `k`, `G`).
- `-mtime -7`: Modificados en los últimos 7 días (puedes usar `+7` para más de 7 días).

```bash
# Buscar todos los archivos .conf en /etc
find /etc -type f -name "*.conf"

# Buscar archivos de más de 100MB en tu directorio personal
find ~ -type f -size +100M
```

### Ejecutar comandos sobre lo encontrado (`-exec`)

`find` te permite ejecutar un comando sobre cada archivo encontrado usando la opción `-exec`:

```bash
# Buscar todos los archivos .log y cambiar sus permisos a 644
# El símbolo {} es reemplazado por la ruta de cada archivo encontrado, y \; termina la acción.
find . -type f -name "*.log" -exec chmod 644 {} \;
```

---

## 📘 Archivado y Compresión (`tar` y `zip`)

En Linux se distingue entre **empaquetar** (unir muchos archivos en uno solo sin reducir tamaño) y **comprimir** (reducir el tamaño de los archivos). El comando `tar` hace ambas cosas.

### 1. Trabajar con `tar.gz` (Estándar de Linux)

- **Crear (`-czvf`)**: `c` (crear), `z` (comprimir con gzip), `v` (modo detallado/verbose), `f` (especificar nombre de archivo destino).
- **Extraer (`-xzvf`)**: `x` (extraer).

```bash
# Empaquetar y comprimir la carpeta 'proyecto' en 'proyecto.tar.gz'
tar -czvf proyecto.tar.gz proyecto/

# Extraer el archivo proyecto.tar.gz
tar -xzvf proyecto.tar.gz
```

### 2. Trabajar con `zip` (Estándar multiplataforma)

- **Crear**: `zip -r archivo.zip carpeta/` (la `-r` es para que sea recursivo).
- **Extraer**: `unzip archivo.zip`.

---

## 📘 Comandos de Red y Transferencia

### 1. `curl` y `wget` (Descargas e interacción HTTP)

- **`wget`**: Diseñado principalmente para descargas directas de archivos.
  ```bash
  wget https://wordpress.org/latest.tar.gz
  ```
- **`curl`**: Herramienta muy versátil para transferir datos desde/hacia servidores. Es el estándar para testear APIs HTTP.

  ```bash
  # Descargar un archivo y guardarlo con su nombre original (-O) o personalizado (-o)
  curl -O https://example.com/index.html

  # Consumir una API JSON y ver el resultado por consola
  curl https://api.github.com/users/asabeneh
  ```

### 2. `scp` y `rsync` (Transferencia remota)

- **`scp`** (Secure Copy): Copia archivos de forma segura entre servidores usando SSH.
  ```bash
  scp archivo.txt usuario@servidor.com:/var/www/
  ```
- **`rsync`**: Es mucho más eficiente que `scp`. Compara los archivos de origen y destino y solo transmite las diferencias (sincronización incremental). Permite reanudar descargas interrumpidas.
  ```bash
  # Sincronizar dos carpetas locales o remotas
  # -a (preserva permisos y fechas), -v (verbose), -z (comprime durante la transmisión)
  rsync -avz carpeta_origen/ carpeta_destino/
  ```

---

## 💻 Ejercicios Prácticos

### Nivel Fácil

1. Escribe el comando `find` para buscar todos los directorios que se llamen `respaldos` dentro de tu carpeta actual.
2. Descarga el archivo de imagen de ejemplo de este enlace utilizando `curl` o `wget` guardándolo con el nombre `google_logo.png`: `https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png`
3. Empaqueta el archivo descargado en un archivo comprimido llamado `imagenes.tar.gz`.

### Nivel Medio

1. Crea una estructura de pruebas con archivos con nombres falsos: `touch log1.log log2.log config.cfg`.
2. Escribe una sola instrucción de `find` que busque todos los archivos que terminen en `.log` en tu directorio actual y los mueva automáticamente a una subcarpeta llamada `logs_viejos` (asegúrate de crear la subcarpeta antes).
3. Investiga cómo extraer el archivo `imagenes.tar.gz` creado en el Nivel Fácil dentro de un directorio específico diferente llamado `extraccion_test` (Pista: consulta `man tar` o busca la bandera `-C`).

### Nivel Difícil

1. Escribe un script llamado `descarga_y_comprime.sh`.
2. El script debe tomar una URL como su primer argumento (`$1`).
3. Debe validar si se ingresó el argumento, si no es así, imprime `"Error: Proporciona una URL"` y sale con `exit 1`.
4. Utilizando `curl`, descarga el contenido de la URL en un archivo temporal llamado `descarga_temp.html`.
5. Si la descarga fue exitosa, empaqueta y comprime el archivo descargado en un archivo llamado `web_backup_$(date +%F).tar.gz`.
6. Al finalizar la operación (sea exitosa o falle), el script debe eliminar el archivo temporal `descarga_temp.html` (utiliza el comando `trap` que aprendimos ayer).

<h3 align="center">
<a href="../dia-12/README.md">Día 12</a> | <a href="../README.md"> Inicio del Curso </a> | <a href="../dia-14/README.md">Día 14</a>
</h3>

---

<details>
<summary>💡 Ver Soluciones Sugeridas</summary>

### Nivel Fácil

1. `find . -type d -name "respaldos"`
2. Con `curl`:
   `curl -o google_logo.png https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png`
   Con `wget`:
   `wget -O google_logo.png https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png`
3. `tar -czvf imagenes.tar.gz google_logo.png`

### Nivel Medio

1. Crear carpeta y mover usando find:
   ```bash
   mkdir -p logs_viejos
   find . -maxdepth 1 -type f -name "*.log" -exec mv {} logs_viejos/ \;
   ```
   _(Nota: `-maxdepth 1` evita que busque dentro de subcarpetas creadas, como logs_viejos/)_.
2. Para extraer en un directorio destino diferente usando tar:
   ```bash
   mkdir -p extraccion_test
   tar -xzvf imagenes.tar.gz -C extraccion_test/
   ```

### Nivel Difícil

1. El script `descarga_y_comprime.sh`:

   ```bash
   #!/bin/bash

   # Validar argumento
   if [[ $# -ne 1 ]]; then
       echo "Error de uso: $0 [URL]"
       exit 1
   fi

   URL="$1"
   TEMP_FILE="descarga_temp.html"
   BACKUP_NAME="web_backup_$(date +%F).tar.gz"

   # Trap para asegurar la limpieza del archivo temporal al salir
   limpiar() {
       if [[ -f "$TEMP_FILE" ]]; then
           rm -f "$TEMP_FILE"
       fi
   }
   trap limpiar EXIT

   echo "Iniciando descarga de $URL..."
   # Descargar con curl (-f silencia errores HTTP, -s modo silencioso, -L sigue redirecciones)
   curl -f -s -L -o "$TEMP_FILE" "$URL"

   if [[ $? -ne 0 ]]; then
       echo "Error: La descarga falló. Verifica la URL o la conexión."
       exit 1
   fi

   echo "Descarga finalizada. Comprimiendo..."
   tar -czvf "$BACKUP_NAME" "$TEMP_FILE"

   if [[ $? -eq 0 ]]; then
       echo "Respaldo creado con éxito: $BACKUP_NAME"
       exit 0
   else
       echo "Error al crear el archivo comprimido."
       exit 1
   fi
   ```

</details>
