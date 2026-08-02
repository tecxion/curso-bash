# 📅 Día 11: Editores de Flujo (sed y awk)

Hoy entramos en la sección avanzada del curso. `sed` y `awk` son dos de las herramientas más temidas por los principiantes debido a su sintaxis críptica, pero son increíblemente potentes. Una vez las domines, podrás hacer modificaciones masivas en segundos y generar informes complejos directamente desde la terminal.

---

## 📘 El Editor de Flujos: `sed` (Stream Editor)

`sed` se utiliza principalmente para buscar, reemplazar, insertar y eliminar texto en un flujo de datos (archivos o tuberías) de forma no interactiva.

### 1. Reemplazo básico de patrones: `s`
La sintaxis de reemplazo básica es `sed 's/buscar/reemplazar/modificadores' archivo`.

```bash
# Cambiar la primera coincidencia de "error" por "alerta" en cada línea
sed 's/error/alerta/' archivo.txt

# Cambiar TODAS las coincidencias (global) en cada línea usando la bandera 'g'
sed 's/error/alerta/g' archivo.txt

# Ignorar mayúsculas/minúsculas usando 'gi'
sed 's/error/alerta/gi' archivo.txt
```

### 2. Modificar el archivo in-place: la bandera `-i`
Por defecto, `sed` escribe el resultado en la salida estándar (`stdout`) sin tocar el archivo original. Para guardar los cambios directamente en el archivo, usa `-i`:
```bash
sed -i 's/servidor_viejo/servidor_nuevo/g' configuracion.conf
```

### 3. Eliminar líneas: `d`
```bash
# Eliminar la línea número 3 del archivo
sed '3d' archivo.txt

# Eliminar todas las líneas que contengan la palabra "temporal"
sed '/temporal/d' archivo.txt
```

---

## 📘 El Procesador de Texto Estructurado: `awk`

A diferencia de `sed`, que actúa línea por línea como un editor clásico, `awk` es un **lenguaje de programación completo** diseñado para procesar datos tabulares (filas y columnas).

### Sintaxis Básica:
```bash
awk -F'separador' 'condicion { accion }' archivo
```

### Columnas y Variables Integradas:
*   `$0`: Representa la línea completa.
*   `$1`, `$2`, `$3`...: Representan las columnas 1, 2, 3... respectivamente.
*   `NF` (*Number of Fields*): Número total de columnas en la línea actual.
*   `NR` (*Number of Records*): Número de la línea actual (empieza en 1).
*   `-F`: Define el delimitador de campos (por defecto son los espacios en blanco o tabuladores).

---

### Ejemplos Prácticos con `awk`

Para los siguientes ejemplos, supongamos que procesamos un archivo `/etc/passwd` delimitado por dos puntos `:`:

#### 1. Imprimir columnas específicas
```bash
# Imprimir el usuario (columna 1) y su directorio home (columna 6)
awk -F: '{print $1 " -> " $6}' /etc/passwd
```

#### 2. Usar filtros y condiciones
```bash
# Imprimir usuarios cuyo ID de usuario (UID, columna 3) sea mayor o igual a 1000
awk -F: '$3 >= 1000 {print $1}' /etc/passwd
```

#### 3. Sumar columnas y bloques BEGIN/END
*   `BEGIN`: Bloque que se ejecuta antes de leer el archivo.
*   `END`: Bloque que se ejecuta después de terminar de leer el archivo.

```bash
# Sumar los salarios de nuestro archivo del Día 5 (empleados.txt: Nombre:Depto:Salario)
awk -F: 'BEGIN { suma=0 } { suma += $3 } END { print "Total Salarios: $" suma }' empleados.txt
```

---

## 💻 Ejercicios Prácticos

Antes de comenzar, crearemos un archivo de configuración de prueba llamado `servicios.conf` y un archivo de datos llamado `inventario.csv`:

```bash
# Crear servicios.conf
cat << 'EOF' > servicios.conf
puerto=8080
estado=inactivo
debug=false
EOF

# Crear inventario.csv
cat << 'EOF' > inventario.csv
Producto,Categoria,Stock,Precio
Teclado,Accesorios,150,25.50
Raton,Accesorios,300,15.00
Monitor,Pantallas,45,180.00
Auriculares,Audio,0,35.00
Microfono,Audio,12,75.00
EOF
```

### Nivel Fácil
1. Usa `sed` para cambiar el estado de `inactivo` a `activo` en el archivo `servicios.conf` (sin modificar el archivo original, solo imprímelo en pantalla).
2. Usa `awk` para imprimir únicamente la primera columna (el nombre del producto) del archivo `inventario.csv` delimitado por comas `,`.

### Nivel Medio
1. Modifica permanentemente (`-i`) el archivo `servicios.conf` para cambiar el puerto de `8080` a `443` y la directiva `debug=false` a `debug=true`.
2. Utiliza `awk` para filtrar el archivo `inventario.csv`. Debe imprimir por pantalla los productos que tienen `Stock` igual a `0`.

### Nivel Difícil
1. Escribe un comando de `awk` que calcule el valor total en inventario de todos los productos de la categoría "Accesorios". El valor de un producto se calcula multiplicando `Stock` por `Precio` (`$3 * $4`).
2. Usa `sed` para eliminar todas las líneas de un archivo que comiencen con el carácter `#` (comentarios de scripts) y las líneas vacías. Pruébalo simulando un archivo con comentarios.

---

<details>
<summary>💡 Ver Soluciones Sugeridas</summary>

### Nivel Fácil
1. `sed 's/inactivo/activo/' servicios.conf`
2. `awk -F',' '{print $1}' inventario.csv` (o `awk -F, ...`)

### Nivel Medio
1. Puedes ejecutar dos comandos seguidos de `sed` o combinarlos usando la opción `-e`:
   `sed -i -e 's/puerto=8080/puerto=443/' -e 's/debug=false/debug=true/' servicios.conf`
2. El stock es la columna 3 del archivo `inventario.csv`:
   `awk -F',' '$3 == 0 {print $1}' inventario.csv`

### Nivel Difícil
1. Para calcular el total del inventario de "Accesorios":
   ```bash
   awk -F',' '
   $2 == "Accesorios" { total += ($3 * $4) } 
   END { print "Total Accesorios: $" total }
   ' inventario.csv
   ```
2. Para eliminar comentarios que empiezan por `#` (y posibles espacios anteriores) y líneas vacías:
   `sed -e '/^[[:space:]]*#/d' -e '/^$/d' archivo.sh`
   *   `/^[[:space:]]*#/d`: Busca y borra líneas que comienzan con opcionalmente espacios y luego `#`.
   *   `/^$/d`: Busca y borra líneas vacías (desde el inicio `^` hasta el final `$` no hay caracteres).

</details>
