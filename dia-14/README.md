![Titulo](./assets/cursobash.png)
[Día 13](./dia-13/README.md) -- [Inicio](./README.md) -- [Día 15](./dia-15/README.md)

# 📅 Día 14: Depuración, Seguridad y Robustez

Frecuentemente se critica a Bash porque es fácil cometer errores silenciosos que causan estragos en el sistema (por ejemplo, intentar borrar una carpeta dinámica y que la variable esté vacía, resultando en borrar la raíz `/`). Hoy aprenderemos a blindar nuestros scripts utilizando el **modo estricto**, cómo depurarlos paso a paso y cómo analizarlos estáticamente con **ShellCheck** para escribir código profesional y libre de errores graves.

---

## 📘 El Shebang Portable

En el Día 6 aprendimos a usar `#!/bin/bash`. Aunque funciona en la mayoría de Linux, la ubicación del binario de Bash puede variar en sistemas como FreeBSD, macOS u otras plataformas Unix. La mejor práctica para hacer tus scripts portables es usar:

```bash
#!/usr/bin/env bash
```

Esto le pide al comando `env` del sistema que busque dónde está instalado Bash en el `$PATH` actual y lo use, haciendo el script compatible con prácticamente cualquier sistema Unix.

---

## 📘 El Modo Estricto de Bash

Para evitar que tu script continúe ejecutándose si algo ha fallado o si has escrito mal una variable, debes colocar las siguientes directivas al principio de tu script (justo debajo del Shebang):

```bash
set -euo pipefail
```

Desglosemos cada opción:

### 1. `set -e` (_Exit on error_)

Por defecto, si un comando en mitad de tu script falla, Bash lo ignora y pasa a la siguiente línea. Con `set -e`, **el script se detiene de inmediato si cualquier comando devuelve un código de error (distinto de 0)**.

- _Excepción_: No se detendrá si el comando está dentro de una estructura de control (como un `if` o `while`).

### 2. `set -u` (_Nounset_)

Por defecto, si haces referencia a una variable que no existe (ej. `echo $VARIABLE_INEXISTENTE`), Bash simplemente la expande como una cadena vacía y continúa. Esto es extremadamente peligroso.
Con `set -u`, **cualquier intento de usar una variable no definida detendrá el script inmediatamente con un mensaje de error**.

### 3. `set -o pipefail`

Por defecto, en un pipeline (`comando1 | comando2 | comando3`), el código de salida final (`$?`) es el del último comando (`comando3`). Si `comando1` falló gravemente pero `comando3` terminó con éxito, Bash asume que toda la tubería tuvo éxito.
Con `set -o pipefail`, **el pipeline devolverá un código de error si cualquiera de sus comandos individuales falla**.

---

## 📘 Depuración Activa (`set -x`)

Si tu script se comporta de forma extraña y no sabes por qué, puedes activar el "modo traza" añadiendo `set -x` en el script, o ejecutándolo directamente desde tu terminal de la siguiente forma:

```bash
bash -x mi_script.sh
```

Esto imprimirá por pantalla cada comando ejecutado precedido por un carácter `+` y con las variables ya expandidas, permitiéndote auditar el flujo exacto de ejecución paso a paso.

---

## 📘 Análisis Estático con ShellCheck

**ShellCheck** es una herramienta de código abierto que analiza tus scripts de Bash en busca de fallos de sintaxis, vulnerabilidades de seguridad y malas prácticas. Es el equivalente a los "linters" de otros lenguajes.

Puedes instalarlo en tu sistema (ej. `sudo apt install shellcheck`) o utilizar su versión web en [https://www.shellcheck.net/](https://www.shellcheck.net/).

### Errores comunes detectados por ShellCheck:

- No poner comillas dobles alrededor de variables que contienen rutas (lo que causa fallos si la ruta tiene espacios).
- Usar `[` en lugar de `[[` para comprobaciones complejas.
- Errores tipográficos en variables.

---

## 💻 Ejercicios Prácticos

### Nivel Fácil

1. Escribe un script llamado `seguro_test.sh` con el shebang portable y el modo seguro activado (`set -e`).
2. Agrega dos líneas: un comando que falle deliberadamente (como `ls /carpeta-inexistente`) y a continuación un `echo "Esta línea nunca se ejecutará"`.
3. Ejecútalo y comprueba que el script se detiene a la mitad.

### Nivel Medio

1. Crea un script llamado `variables_seguras.sh` con `set -u` activado.
2. Define la variable `NOMBRE="Ana"`.
3. Intenta imprimir la variable `$NOMBRES` (con una **S** al final por error tipográfico).
4. Ejecuta el script. Observa el mensaje de error y comprueba cómo el intérprete te protege de cometer errores tipográficos de variables en tiempo de ejecución.

### Nivel Difícil

1. Crea un script llamado `pipe_seguro.sh` sin el modo estricto. Escribe la tubería: `cat archivo-inexistente.txt | wc -l`.
2. Ejecuta el script e imprime `$?` al final. Verás que devuelve `0` (éxito) a pesar de que el archivo no existía, porque `wc -l` sí funcionó.
3. Activa `set -o pipefail` en tu script. Vuelve a ejecutarlo y comprueba cómo ahora el código de salida final captura el error del primer comando del pipeline.
4. Escribe un caso donde quieras usar `set -e` pero necesites ejecutar un comando que _sabes_ que puede fallar (por ejemplo, comprobar si un puerto está abierto) sin que detenga todo el script. Investiga cómo evitar la detención usando el operador lógico OR `|| true` o un bloque condicional.

---

<details>
<summary>💡 Ver Soluciones Sugeridas</summary>

### Nivel Fácil

1. El script `seguro_test.sh`:

   ```bash
   #!/usr/bin/env bash
   set -e

   # Comando que falla
   ls /carpeta-inexistente-123

   # Esto nunca se ejecutará
   echo "Esta línea nunca se ejecutará"
   ```

### Nivel Medio

1. El script `variables_seguras.sh`:

   ```bash
   #!/usr/bin/env bash
   set -u

   NOMBRE="Ana"

   # Error intencionado
   echo "El nombre guardado es: $NOMBRES"
   ```

2. Salida esperada al ejecutar: `variables_seguras.sh: línea 7: NOMBRES: variable sin declarar`.

### Nivel Difícil

1. El script `pipe_seguro.sh` corregido:

   ```bash
   #!/usr/bin/env bash
   set -o pipefail

   # Esto fallará pero wc -l dará 0
   cat archivo-inexistente.txt | wc -l

   echo "Código de salida: $?"
   ```

2. Ejecución: El código de salida será `1` porque `cat` falló.
3. **Evitar detener el script con `set -e` en comandos que pueden fallar**:
   Si necesitas correr un comando secundario que puede dar error sin que rompa el script, puedes usar el operador `|| true` para forzar un código de salida exitoso:

   ```bash
   #!/usr/bin/env bash
   set -e

   # Este comando fallará pero el script NO se detendrá
   ping -c 1 ip.inexistente.com || true

   echo "El script sigue vivo."
   ```

</details>
