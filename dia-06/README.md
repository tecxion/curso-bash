![Titulo](assets/cursobash.png)
[Día 5](./dia-05/README.md) -- [Inicio](./README.md) -- [Día 7](./dia-07/README.md)

# 📅 Día 6: Variables y Entorno en Bash

¡Felicidades! Has completado el bloque de fundamentos. A partir de hoy, nos enfocaremos en escribir **scripts de Bash** (programas) que ejecuten lógica secuencial, tomen decisiones y procesen datos automáticamente. Empezaremos entendiendo cómo estructurar un archivo de script y cómo manejar variables.

---

## 📘 Conceptos Clave

### Estructura de un Script y el Shebang (`#!`)

Un script de Bash es simplemente un archivo de texto con una lista de comandos. Para que el sistema sepa qué intérprete debe usar para ejecutar este archivo, la primera línea debe contener la cabecera especial llamada **Shebang**:

```bash
#!/bin/bash
```

- `#` representa un comentario en Bash (el intérprete ignora estas líneas).
- `!` combinado con `#` al inicio (`#!`) le dice al sistema operativo: "Usa el binario de la ruta siguiente para ejecutar este script".

### Regla de Oro de las Variables en Bash

Al declarar una variable en Bash, **NO debes dejar espacios alrededor del signo igual (`=`)**.

- **Correcto**: `nombre="Carlos"`
- **Incorrecto**: `nombre = "Carlos"` (Bash intentará ejecutar `nombre` como si fuera un comando y dará error).

---

## 🛠️ Comandos y Conceptos de Hoy

| Concepto / Comando | Descripción                                                     | Ejemplo de Uso         |
| :----------------- | :-------------------------------------------------------------- | :--------------------- |
| `export`           | Convierte una variable local en una variable de entorno.        | `export API_KEY="123"` |
| `env` / `printenv` | Muestra todas las variables de entorno activas.                 | `printenv PATH`        |
| `readonly`         | Declara una variable de solo lectura (constante).               | `readonly PI=3.1416`   |
| `$(comando)`       | Sustitución de comando: ejecuta el comando e inserta su salida. | `fecha=$(date)`        |

---

## 🔍 Explicación Detallada y Ejemplos

### 1. Creación y Ejecución de tu Primer Script

Sigue estos pasos en tu terminal:

1. Crea el archivo:
   ```bash
   touch mi_primer_script.sh
   ```
2. Abre el archivo en un editor (como `nano mi_primer_script.sh`) y escribe el siguiente contenido:
   ```bash
   #!/bin/bash
   echo "¡Hola desde mi primer script!"
   ```
3. Intenta ejecutarlo directamente:
   ```bash
   ./mi_primer_script.sh
   # Dará error: "Permiso denegado" (porque no tiene permisos de ejecución).
   ```
4. Dale permisos y ejecútalo:
   ```bash
   chmod +x mi_primer_script.sh
   ./mi_primer_script.sh
   # Salida: ¡Hola desde mi primer script!
   ```

---

### 2. Comillas Simples (`'`) vs Comillas Dobles (`"`)

Es uno de los errores más comunes en principiantes.

- **Comillas Dobles (`"`)**: Permiten la expansión de variables y caracteres de escape.
- **Comillas Simples (`'`)**: Tratan todo su contenido de forma estrictamente literal (no expanden nada).

```bash
nombre="Juan"

echo "Hola, $nombre"  # Salida: Hola, Juan
echo 'Hola, $nombre'  # Salida: Hola, $nombre
```

---

### 3. Variables de Entorno y del Sistema

Las variables del sistema se heredan en todos los subprocesos y programas que inicies desde la terminal.

- `$USER`: Nombre del usuario actual.
- `$HOME`: Ruta al directorio personal.
- `$PATH`: Lista de directorios donde el sistema busca comandos ejecutables.
- `$?`: Código de salida del último comando ejecutado (0 significa éxito, cualquier otro número significa error).

```bash
# Crear una variable local
CIUDAD="Madrid"

# Hacerla disponible para otros programas lanzados desde aquí
export CIUDAD
```

---

### 4. Sustitución de Comandos (`$(...)`)

Te permite ejecutar un comando y guardar su resultado dentro de una variable.

```bash
# Guardar la fecha en un formato específico
fecha_hoy=$(date +%Y-%m-%d)
usuario_actual=$(whoami)

echo "Hoy es $fecha_hoy y el usuario activo es $usuario_actual."
```

---

## 💻 Ejercicios Prácticos

### Nivel Fácil

1. Crea un script llamado `info_sistema.sh` con el shebang correcto.
2. Dentro del script, declara una variable llamada `nombre` con tu nombre y otra llamada `edad`.
3. Haz que el script imprima en pantalla: `"Hola [nombre], tu directorio personal es [HOME] y tienes [edad] años."` (Usa variables locales y variables del sistema).
4. Dale permisos de ejecución y pruébalo.

### Nivel Medio

1. Crea un script llamado `salida_comando.sh`.
2. Dentro de él, usa la sustitución de comandos para guardar la cantidad de archivos presentes en la carpeta `/etc` en una variable llamada `cantidad_archivos`.
3. Haz que imprima: `"En el directorio /etc hay [cantidad_archivos] archivos."`
4. Al final del script, haz un `ls` de una carpeta que no exista. Luego, imprime por pantalla el valor de la variable especial `$?` para comprobar el código de error.

### Nivel Difícil

1. Escribe un script llamado `entorno_test.sh` que verifique si existe una variable de entorno llamada `MI_APLICACION`. Si ejecutas el script directamente, probablemente no estará definida.
2. Investiga cómo puedes "cargar" o importar variables y funciones de un script dentro de la terminal actual sin lanzar un subproceso (Pista: comando `source` o `.`).
3. Modifica tu script para que exporte una variable llamada `VERSION_APP="2.1.0"` y verifica, desde tu terminal habitual (después de ejecutar el script con `source`), si la variable se importó con éxito usando `echo $VERSION_APP`.

---

<details>
<summary>💡 Ver Soluciones Sugeridas</summary>

### Nivel Fácil

1. `touch info_sistema.sh && chmod +x info_sistema.sh`
2. El script `info_sistema.sh` debe contener:
   ```bash
   #!/bin/bash
   nombre="TuNombre"
   edad=30
   echo "Hola $nombre, tu directorio personal es $HOME y tienes $edad años."
   ```
3. Ejecutar con `./info_sistema.sh`.

### Nivel Medio

1. El script `salida_comando.sh` debe contener:

   ```bash
   #!/bin/bash
   # Contar archivos en /etc
   cantidad_archivos=$(ls /etc | wc -l)
   echo "En el directorio /etc hay $cantidad_archivos archivos."

   # Forzar un error
   ls /directorio-inexistente-123 2> /dev/null
   echo "El código de salida del error es: $?"
   ```

2. Dar permisos `chmod +x salida_comando.sh` y ejecutar.

### Nivel Difícil

1. El script `entorno_test.sh`:
   ```bash
   #!/bin/bash
   echo "Valor de MI_APLICACION: $MI_APLICACION"
   export VERSION_APP="2.1.0"
   ```
2. Si ejecutas `./entorno_test.sh` y luego escribes `echo $VERSION_APP` en tu terminal, saldrá vacío. Esto es porque el script se ejecuta en una sub-shell (subproceso) y al terminar, sus variables se destruyen.
3. Para ejecutar el script en el entorno de la shell actual, usa:
   `source ./entorno_test.sh` (o `. ./entorno_test.sh`).
   Ahora, si ejecutas `echo $VERSION_APP` en tu terminal principal, verás: `2.1.0`.

</details>
