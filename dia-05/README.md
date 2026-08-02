![Titulo](assets/cursobash.png)
[Día 5](./dia-04/README.md) -- [Inicio](./README.md) -- [Día 6](./dia-06/README.md)

# 📅 Día 5: Procesamiento de Texto Básico

En Unix, casi toda la información del sistema, registros y configuraciones se almacena en archivos de texto plano. Por ello, dominar las herramientas de filtrado y procesamiento de texto es lo que distingue a un usuario de terminal común de un profesional eficiente. Hoy aprenderemos las herramientas básicas de análisis de texto.

---

## 📘 Conceptos Clave

### La Importancia del Pipeline

El verdadero poder del procesamiento de texto se desata cuando encadenamos comandos simples usando tuberías (`|`). Podemos leer un archivo, filtrar líneas, cortar una columna de datos, ordenarlos, contar sus duplicados y obtener un reporte final en una sola línea de consola.

---

## 🛠️ Herramientas de Procesamiento de Texto

| Comando | Descripción                                                      | Ejemplo de Uso               |
| :------ | :--------------------------------------------------------------- | :--------------------------- |
| `grep`  | Busca líneas que coinciden con un patrón o texto.                | `grep -i "error" log.txt`    |
| `wc`    | Cuenta líneas (`-l`), palabras (`-w`) o bytes (`-c`).            | `wc -l archivo.txt`          |
| `sort`  | Ordena líneas alfabética o numéricamente (`-n`).                 | `sort -n edades.txt`         |
| `uniq`  | Filtra líneas repetidas **adyacentes** (requiere ordenar antes). | `sort datos.txt \| uniq -c`  |
| `cut`   | Extrae campos/columnas delimitados (`-d`) por un carácter.       | `cut -d: -f1 /etc/passwd`    |
| `tr`    | Traduce, reemplaza o borra (`-d`) caracteres específicos.        | `tr 'a-z' 'A-Z' < texto.txt` |

---

## 🔍 Explicación Detallada y Ejemplos

### 1. Búsquedas con `grep`

- `-i`: Ignora mayúsculas/minúsculas.
- `-v`: Invierte la búsqueda (muestra las líneas que **no** coinciden).
- `-n`: Muestra el número de línea donde ocurrió la coincidencia.
- `-r`: Busca de forma recursiva en un directorio completo.

```bash
# Buscar la palabra "failed" ignorando mayúsculas en auth.log
grep -i "failed" /var/log/auth.log

# Buscar recursivamente "db_password" en todos los archivos del proyecto actual
grep -rn "db_password" .
```

---

### 2. Contar con `wc`

- `wc -l`: Cuenta saltos de línea (el número de líneas).
- `wc -w`: Cuenta palabras.
- `wc -c`: Cuenta caracteres o bytes.

```bash
# ¿Cuántos usuarios hay registrados en el sistema?
wc -l < /etc/passwd
```

---

### 3. Ordenar y Unificar (`sort` y `uniq`)

> [!IMPORTANT]
> El comando `uniq` solo elimina duplicados si están **juntos** (líneas adyacentes). Por esta razón, casi siempre debes ejecutar `sort` antes de `uniq`.

```bash
# Supongamos un archivo paises.txt con líneas duplicadas
# Ordenar, eliminar duplicados y contar cuántas veces se repite cada país:
sort paises.txt | uniq -c
```

---

### 4. Recortar Columnas (`cut`)

Ideal para extraer datos estructurados por columnas (archivos CSV, logs estructurados).

- `-d`: Delimitador (por defecto es tabulador).
- `-f`: Número de columna/campo a extraer (empieza en 1).

```bash
# En /etc/passwd, los datos se separan por dos puntos (:).
# Para obtener solo la primera columna (nombres de usuario):
cut -d':' -f1 /etc/passwd
```

---

### 5. Traducción y Reemplazo (`tr`)

Sustituye un conjunto de caracteres por otro. No lee archivos como argumentos directamente, requiere redirección de entrada `<` o tuberías.

- `tr 'a' 'b'`: Cambia todas las 'a' por 'b'.
- `tr -d 'carácter'`: Elimina ese carácter.

```bash
# Convertir texto a mayúsculas
echo "hola mundo" | tr 'a-z' 'A-Z'

# Eliminar todos los espacios de una cadena
echo "H o l a" | tr -d ' '
```

---

## 💻 Ejercicios Prácticos

Para estos ejercicios, primero crearemos un archivo de datos simulado llamado `empleados.txt`. Cópialo y ejecútalo en tu terminal:

```bash
cat << 'EOF' > empleados.txt
Juan:Ventas:1500
Maria:Soporte:1800
Pedro:Soporte:1800
Ana:Desarrollo:2500
Lucas:Desarrollo:2500
Maria:Soporte:1800
EOF
```

### Nivel Fácil

1. Cuenta el número total de líneas del archivo `empleados.txt`.
2. Filtra el archivo para ver únicamente a los empleados que trabajan en el departamento de "Desarrollo".
3. Escribe un comando para convertir todo el archivo `empleados.txt` a mayúsculas y guárdalo en un nuevo archivo llamado `empleados_mayus.txt`.

### Nivel Medio

1. El archivo contiene una línea duplicada de "Maria:Soporte:1800". Escribe un pipeline utilizando `sort` y `uniq` que imprima los empleados de forma única y ordenada alfabéticamente.
2. Utiliza `cut` para obtener una lista limpia únicamente con los nombres de los empleados (la primera columna, delimitada por `:`).
3. ¿Cuántos empleados pertenecen al departamento de "Soporte"? Utiliza `grep` y `wc` en una sola línea de comandos para averiguarlo.

### Nivel Difícil

1. Escribe un comando compuesto que identifique cuántos salarios únicos existen en la empresa y muestre una lista de dichos salarios ordenados de menor a mayor. (Pistas: debes extraer la columna de salarios con `cut`, ordenarla numéricamente y usar `uniq`).
2. Utiliza `tr` para cambiar el delimitador `:` por un espacio de tabulador en el archivo `empleados.txt` para mejorar su formato visual en la salida de consola.
3. Investiga la bandera `-v` de `grep`. Escribe un comando que muestre todas las líneas de `empleados.txt` excluyendo a las personas de "Soporte".

---

<details>
<summary>💡 Ver Soluciones Sugeridas</summary>

### Nivel Fácil

1. `wc -l empleados.txt` (o `wc -l < empleados.txt` para obtener solo el número sin el nombre del archivo).
2. `grep "Desarrollo" empleados.txt`
3. `tr 'a-z' 'A-Z' < empleados.txt > empleados_mayus.txt`

### Nivel Medio

1. `sort empleados.txt | uniq`
2. `cut -d':' -f1 empleados.txt`
3. `grep -c "Soporte" empleados.txt` (o `grep "Soporte" empleados.txt | wc -l`). La bandera `-c` de grep cuenta coincidencias directamente de forma más eficiente.

### Nivel Difícil

1. Extraer salario (columna 3), ordenar numéricamente (`sort -n`) y sacar únicos:
   `cut -d':' -f3 empleados.txt | sort -n | uniq`
2. El carácter especial del tabulador suele representarse como `\t`. En algunos sistemas debes usar comillas simples o escapar:
   `tr ':' '\t' < empleados.txt` (o bien `tr ':' ' '` para espacios normales si el tabulador da problemas).
3. Usando `grep -v`:
   `grep -v "Soporte" empleados.txt`

</details>
