<h3 align="center">
<a href="../dia-08/README.md">Día 8</a> | <a href="../README.md"> Inicio del Curso </a> | <a href="../dia-10/README.md">Día 10</a>
</h3>

![Titulo](../assets/cursobash.png)

# 📅 Día 9: Bucles e Iteraciones (for, while, until)

Los ordenadores destacan por hacer tareas repetitivas a velocidades increíbles. Hoy aprenderemos a estructurar bucles en Bash. Veremos cómo repetir operaciones un número determinado de veces, cómo procesar colecciones de archivos y cómo leer un archivo de texto línea por línea de manera eficiente.

---

## 📘 El Bucle `for`

El bucle `for` se utiliza para iterar sobre una lista de elementos (números, cadenas, nombres de archivos, etc.).

### Sintaxis y Formatos:

#### 1. Iterar sobre una lista explícita

```bash
for fruta in manzana platano naranja; do
    echo "Me gusta comer $fruta"
done
```

#### 2. Iterar sobre un rango numérico

```bash
# De 1 a 5
for i in {1..5}; do
    echo "Número: $i"
done

# De 0 a 10, de 2 en 2 (paso)
for i in {0..10..2}; do
    echo "Número par: $i"
done
```

#### 3. Estilo C tradicional

Útil si necesitas llevar un control numérico con un índice clásico:

```bash
for ((i=0; i<5; i++)); do
    echo "Índice: $i"
done
```

#### 4. Iterar sobre archivos usando Comodines (Globs)

Es una de las tareas más comunes de automatización:

```bash
# Copiar todos los archivos .txt a una carpeta de respaldo
for archivo in *.txt; do
    cp "$archivo" backups/
done
```

---

## 📘 El Bucle `while`

El bucle `while` se ejecuta continuamente **mientras** la condición especificada sea verdadera (`true`).

```bash
contador=1
while [[ $contador -le 3 ]]; do
    echo "Contador: $contador"
    contador=$((contador + 1)) # Incrementar
done
```

### Leer un archivo línea por línea (Muy importante)

La combinación de `while` con el comando `read` es la forma estándar y más robusta de leer un archivo línea por línea en Bash:

```bash
# Leer un archivo de texto
while read -r linea; do
    echo "Línea leída: $linea"
done < archivo.txt
```

- `read -r`: La opción `-r` evita que los caracteres de barra diagonal invertida (`\`) sean interpretados como secuencias de escape.
- `< archivo.txt`: Redirecciona el archivo al bucle completo.

---

## 📘 El Bucle `until`

El bucle `until` es lo contrario de `while`. Se ejecuta **hasta que** la condición se vuelva verdadera (es decir, corre mientras la condición sea falsa).

```bash
contador=1
until [[ $contador -gt 3 ]]; do
    echo "Intento número: $contador"
    contador=$((contador + 1))
done
```

---

## 🔍 Control de Bucles: `break` y `continue`

- **`break`**: Termina inmediatamente el bucle por completo.
- **`continue`**: Salta el resto de la iteración actual y pasa inmediatamente a evaluar la siguiente condición del bucle.

```bash
for i in {1..5}; do
    if [[ $i -eq 3 ]]; then
        continue # Salta el número 3
    fi
    echo "Número: $i"
done
```

---

## 💻 Ejercicios Prácticos

### Nivel Fácil

1. Crea un script llamado `multiplica.sh`.
2. El script debe pedirle al usuario un número (ej. el 7) y usar un bucle `for` para imprimir la tabla de multiplicar de dicho número del 1 al 10.
3. El formato de la salida debe ser: `7 x 1 = 7`, `7 x 2 = 14`, etc.

### Nivel Medio

1. Crea un script llamado `respalden_fotos.sh`.
2. El script debe buscar todos los archivos con extensión `.png` en tu directorio actual (puedes crear un par de archivos vacíos con `touch foto1.png foto2.png` para probar).
3. Utilizando un bucle `for` y comprobaciones `if`, haz que el script verifique si existe una carpeta llamada `respaldos_img`. Si no existe, debe crearla.
4. Mueve o copia cada archivo `.png` a esa carpeta e imprime un mensaje por cada archivo procesado.

### Nivel Difícil

1. Crea un script llamado `procesador_usuarios.sh`.
2. El script debe leer el archivo `/etc/passwd` del sistema (el cual contiene los usuarios del sistema operativo separados por dos puntos `:`).
3. Utilizando un bucle `while read -r` combinado con el comando `cut` (o directamente usando variables de Bash), lee el archivo línea por línea.
4. Por cada línea, extrae el nombre de usuario (el primer campo) y su shell asignada (el último campo).
5. Imprime un listado limpio en el siguiente formato: `"El usuario [usuario] utiliza la shell [shell]"`.
6. Si la shell del usuario es `/bin/false` o `/usr/sbin/nologin`, no imprimas nada (utiliza `continue` para saltar esa línea).

---

<details>
<summary>💡 Ver Soluciones Sugeridas</summary>

### Nivel Fácil

1. El script `multiplica.sh`:

   ```bash
   #!/bin/bash
   read -p "Introduce un número para ver su tabla de multiplicar: " numero

   for i in {1..10}; do
       resultado=$((numero * i))
       echo "$numero x $i = $resultado"
   done
   ```

### Nivel Medio

1. El script `respalden_fotos.sh`:

   ```bash
   #!/bin/bash

   # Crear archivos de prueba si no existen
   touch foto1.png foto2.png

   # Comprobar si existe el directorio
   if [[ ! -d "respaldos_img" ]]; then
       echo "Creando carpeta respaldos_img..."
       mkdir respaldos_img
   fi

   # Iterar sobre las imágenes png
   for archivo in *.png; do
       # Asegurarse de que coincide con archivos reales (evitar errores si no hay archivos)
       if [[ -f "$archivo" ]]; then
           cp "$archivo" respaldos_img/
           echo "Archivo '$archivo' respaldado con éxito."
       fi
   done
   ```

### Nivel Difícil

1. El script `procesador_usuarios.sh`:

   ```bash
   #!/bin/bash

   ruta_archivo="/etc/passwd"

   if [[ ! -r "$ruta_archivo" ]]; then
       echo "Error: No se puede leer el archivo $ruta_archivo"
       exit 1
   fi

   # Leer línea a línea
   while read -r linea; do
       # Extraer primer campo (nombre de usuario) y séptimo (shell de login)
       usuario=$(echo "$linea" | cut -d':' -f1)
       shell=$(echo "$linea" | cut -d':' -f7)

       # Saltar usuarios de sistema sin shell interactiva
       if [[ "$shell" == "/bin/false" || "$shell" == "/usr/sbin/nologin" || "$shell" == "/sbin/nologin" ]]; then
           continue
       fi

       echo "El usuario '$usuario' utiliza la shell '$shell'"
   done < "$ruta_archivo"
   ```

</details>
