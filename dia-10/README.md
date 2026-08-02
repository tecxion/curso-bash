<h3 align="center">
<a href="../dia-08/README.md">Día 8</a> | <a href="../README.md"> Inicio del Curso </a> | <a href="../dia-11/README.md">Día 11</a>
</h3>

![Titulo](../assets/cursobash.png)

# 📅 Día 10: Funciones y Modularidad en Scripts

A medida que escribes scripts más complejos, tu código puede volverse largo y difícil de mantener. Hoy aprenderemos a agrupar bloques de código reutilizables mediante **funciones** y a modularizar nuestros proyectos importando scripts externos.

---

## 📘 Creación de Funciones en Bash

Una función es un bloque de comandos que recibe un nombre y puede ser invocado en cualquier parte del script tras haber sido declarada.

### Sintaxis Estándar:

```bash
# Sintaxis recomendada y limpia
nombre_de_la_funcion() {
    # Bloque de comandos
    echo "Hola, soy una función"
}

# Invocar la función (sin paréntesis)
nombre_de_la_funcion
```

---

## 📘 Paso de Argumentos a Funciones

A diferencia de lenguajes como JavaScript o Python, en Bash **no se definen los parámetros dentro de los paréntesis** de la función. 

*   **Sintaxis Incorrecta:** `saludar(nombre, edad) { ... }`
*   **Sintaxis Correcta:** `saludar() { ... }`

Entonces, ¿cómo recibe datos una función? A través de los **parámetros posicionales** (`$1`, `$2`, `$3`, etc.), exactamente del mismo modo que un script de terminal recibe argumentos cuando lo ejecutas.

---

### 1. Variables Especiales dentro de una Función
Al igual que en un script independiente, dentro de la función tenemos acceso a variables que cambian su contexto para referirse a la función:
*   `$1`, `$2`, `$3`...: El primer, segundo, tercer argumento pasados a la función.
*   `$#`: La cantidad de argumentos recibidos por la función.
*   `$@`: La lista completa de todos los argumentos pasados a la función (muy útil para iterar con un bucle `for`).

---

### 2. Diferencia entre Argumentos del Script vs Argumentos de la Función
> [!IMPORTANT]
> Dentro de una función, `$1` se refiere al primer argumento de **la función**, no al primer argumento del script.
> 
> Si necesitas usar el argumento original del script (`$1` del script) dentro de una función, debes pasárselo de forma explícita al llamarla o guardarlo previamente en una variable global al inicio del script.

#### Ejemplo que demuestra la diferencia de contextos:
```bash
#!/usr/bin/env bash

presentar_usuario() {
    # Aquí $1 es de la función ("Carlos")
    local nombre_funcion="$1"
    echo "Argumento 1 de la función: $nombre_funcion"
}

# Aquí $1 es del script (supongamos que ejecutas: ./script.sh "Archivo.txt")
echo "Argumento 1 del script original: $1"

# Llamamos a la función pasándole otro valor
presentar_usuario "Carlos"
```

---

### 3. Buenas Prácticas: Asignar Argumentos a Variables Locales
Trabajar con `$1`, `$2` o `$3` directamente en funciones largas hace que el código sea difícil de leer. La mejor práctica es asignar los parámetros posicionales a variables con nombres descriptivos usando `local` al inicio de la función:

```bash
#!/usr/bin/env bash

calcular_area_rectangulo() {
    # 1. Asignación a variables legibles
    local base="$1"
    local altura="$2"
    
    # 2. Operación usando las variables descriptivas
    local area=$((base * altura))
    echo "El área es: $area"
}

# Invocar la función con dos argumentos separados por un espacio
calcular_area_rectangulo 5 10
# Salida: El área es: 50
```

---

## 📘 Ámbito de Variables: Globals vs `local`

Por defecto, **todas las variables declaradas en Bash son globales**, incluso si se definen dentro de una función. Esto puede ocasionar graves colisiones e introducir bugs sutiles en tu código.
Para declarar variables exclusivas de la función, utiliza la palabra clave `local`.

```bash
#!/bin/bash

mi_funcion() {
    local variable_local="Solo existo aquí"
    variable_global="Existo en todo el script"
}

mi_funcion
echo "$variable_global" # Funciona
echo "$variable_local"  # Imprime una línea vacía (no existe fuera de la función)
```

---

## 📘 Códigos de Salida y `return` (¿Cómo responde una función?)

Uno de los mayores choques conceptuales para quienes vienen de otros lenguajes de programación (como Python, JavaScript o Java) es cómo las funciones devuelven información en Bash. 

En Bash, existen **dos formas completamente diferentes** de obtener resultados de una función:

---

### Método 1: Retornar un Código de Estado (Éxito o Error) con `return`
El comando `return` en Bash **NO sirve para devolver datos** (como texto o números para cálculos). Su única función es reportar el estado de ejecución (si la función terminó bien o mal).

*   **Rango permitido:** Solo números enteros del `0` al `255`.
*   **Significado:**
    *   `return 0` significa **Éxito / Todo salió bien** (a diferencia de otros lenguajes donde 0 suele ser falso).
    *   `return X` (cualquier número de 1 a 255) significa **Error / Código de fallo**.
*   **Cómo leerlo:** El valor devuelto por `return` se almacena inmediatamente en la variable especial `$?`.

#### Ejemplo Práctico:
```bash
# Definimos una función que comprueba si un usuario es root
es_administrador() {
    if [[ "$USER" == "root" ]]; then
        return 0 # Éxito: el usuario es root
    else
        return 1 # Fallo: no es root
    fi
}

# Ejecutamos la función
es_administrador

# Comprobamos el resultado evaluando la variable especial $?
if [[ $? -eq 0 ]]; then
    echo "Hola, administrador. Tienes control total."
else
    echo "Acceso denegado. Se requieren privilegios root."
fi
```

> [!TIP]
> Puedes usar la ejecución de la función directamente dentro de la condición del `if` de forma más limpia, sin usar `$?`:
> ```bash
> if es_administrador; then
>     echo "Es admin"
> else
>     echo "No es admin"
> fi
> ```

---

### Método 2: Devolver datos o texto (Sustitución de Comandos)
Si necesitas que una función devuelva un texto (ej. formatear una fecha, procesar una cadena) o el resultado de un cálculo matemático, **no puedes usar `return`**.

En su lugar, debes hacer que la función imprima el resultado a la salida estándar (`echo` o `printf`) y capturarlo utilizando la **sustitución de comandos `$(...)`** al invocarla.

#### Ejemplo Práctico:
```bash
# Función que procesa y devuelve un saludo
obtener_saludo() {
    local nombre="$1"
    # "Devolvemos" el texto simplemente escribiéndolo en pantalla
    echo "¡Bienvenido de vuelta, $nombre!"
}

# Capturamos la salida de la función en una variable
mensaje_bienvenida=$(obtener_saludo "Marcos")

# Ahora podemos usar esa variable
echo "El script dice: $mensaje_bienvenida"
```

---

### Resumen de Diferencias:

| Objetivo | ¿Qué usar? | ¿Cómo se captura? |
| :--- | :--- | :--- |
| Saber si una tarea se realizó con éxito o falló | `return 0` o `return 1` | Leyendo la variable `$?` o directamente en un `if` |
| Obtener un texto, número calculado o lista | `echo "resultado"` | Usando sustitución: `variable=$(mi_funcion)` |

---

## 📘 Modularidad usando `source`

El comando `source` (o su equivalente abreviado `.`) ejecuta un script en el entorno de la shell actual. Es ideal para separar configuraciones o librerías de funciones en un archivo aparte.

```bash
# Cargar funciones de una biblioteca externa
source libs/utilidades.sh

# Ahora puedes llamar a las funciones definidas en utilidades.sh
mi_funcion_externa
```

---

## 💻 Ejercicios Prácticos

### Nivel Fácil

1. Crea un script llamado `funciones_basicas.sh`.
2. Define una función llamada `mostrar_bienvenida` que imprima un mensaje decorado (por ejemplo, con líneas divisorias `======`).
3. Invoca la función dos veces en tu script.

### Nivel Medio

1. Crea un script llamado `operaciones.sh`.
2. Escribe una función llamada `sumar` que reciba dos números como argumentos, calcule la suma y la imprima por pantalla.
3. Escribe otra función llamada `es_par` que reciba un número como argumento. Si el número es par, debe retornar un código de estado `0` (éxito), de lo contrario un `1` (error).
4. Invoca las funciones y muestra mensajes adecuados evaluando el resultado de las funciones usando la variable `$?`.

### Nivel Difícil

1. Diseña un sistema modular de dos archivos:
   - Un archivo de configuración llamado `config.env` que contenga variables como `NOMBRE_APP="Respaldos"`, `LIMITE_DIAS=7`, `DIRECTORIO_DESTINO="/var/backups"`.
   - Un script ejecutable llamado `ejecutor.sh`.
2. El script `ejecutor.sh` debe importar el archivo de configuración en su inicio.
3. Define una función dentro de `ejecutor.sh` llamada `validar_directorio`. Esta debe comprobar si el `DIRECTORIO_DESTINO` definido en `config.env` existe. Si no existe, debe intentar crearlo y retornar `0`. Si falla la creación, debe imprimir un mensaje de error crítico y retornar `1`.
4. El script principal debe terminar con un `exit 0` si todo fue bien, o un `exit 1` si ocurrió algún fallo en las funciones.

<h3 align="center">
<a href="../dia-08/README.md">Día 8</a> | <a href="../README.md"> Inicio del Curso </a> | <a href="../dia-11/README.md">Día 11</a>
</h3>

---

<details>
<summary>💡 Ver Soluciones Sugeridas</summary>

### Nivel Fácil

1. El script `funciones_basicas.sh`:

   ```bash
   #!/bin/bash

   mostrar_bienvenida() {
       echo "==================================="
       echo "   BIENVENIDO AL SISTEMA BASH     "
       echo "==================================="
   }

   # Invocar
   mostrar_bienvenida
   echo "Haciendo algunas tareas..."
   mostrar_bienvenida
   ```

### Nivel Medio

1. El script `operaciones.sh`:

   ```bash
   #!/bin/bash

   sumar() {
       local num1="$1"
       local num2="$2"
       local resultado=$((num1 + num2))
       echo "La suma de $num1 y $num2 es: $resultado"
   }

   es_par() {
       local num="$1"
       # Si el resto de la división por 2 es 0, es par
       if [[ $((num % 2)) -eq 0 ]]; then
           return 0
       else
           return 1
       fi
   }

   # Pruebas
   sumar 10 25

   numero_prueba=17
   es_par "$numero_prueba"
   if [[ $? -eq 0 ]]; then
       echo "El número $numero_prueba es Par."
   else
       echo "El número $numero_prueba es Impar."
   fi
   ```

### Nivel Difícil

1. Archivo `config.env`:
   ```bash
   # Configuración de variables
   NOMBRE_APP="Respaldos"
   LIMITE_DIAS=7
   DIRECTORIO_DESTINO="./backups_dummy" # Cambiado a ruta local para evitar problemas de permisos
   ```
2. Archivo `ejecutor.sh`:

   ```bash
   #!/bin/bash

   # Importar el archivo de configuración
   if [[ -f "config.env" ]]; then
       source config.env
   else
       echo "Error Crítico: No se pudo cargar config.env"
       exit 1
   fi

   validar_directorio() {
       # Validar si existe el directorio
       if [[ -d "$DIRECTORIO_DESTINO" ]]; then
           echo "El directorio de respaldo '$DIRECTORIO_DESTINO' ya existe."
           return 0
       else
           echo "El directorio '$DIRECTORIO_DESTINO' no existe. Creando..."
           mkdir -p "$DIRECTORIO_DESTINO" 2> /dev/null
           if [[ $? -eq 0 ]]; then
               echo "Directorio creado con éxito."
               return 0
           else
               echo "Error: No se pudo crear el directorio '$DIRECTORIO_DESTINO'."
               return 1
           fi
       fi
   }

   # Ejecución principal
   echo "Iniciando aplicación: $NOMBRE_APP"
   validar_directorio

   # Evaluar código de retorno de la función
   if [[ $? -ne 0 ]]; then
       echo "Fallo en la validación inicial del script. Saliendo con error."
       exit 1
   fi

   echo "Aplicación completada con éxito."
   exit 0
   ```

</details>
