![Titulo](assets/cursobash.png)
[Día 9](./dia-09/README.md) -- [Inicio](./README.md) -- [Día 11](./dia-11/README.md)

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

A diferencia de otros lenguajes, las funciones en Bash no declaran parámetros entre paréntesis. Reciben los argumentos a través de los **parámetros posicionales** (`$1`, `$2`, `$@`), exactamente igual que los scripts de terminal.

> [!IMPORTANT]
> Dentro de una función, `$1` representa el primer argumento que se le pasó a **la función**, no el primer argumento que se le pasó al script principal.

```bash
#!/bin/bash

saludar() {
    echo "Hola $1, buenos días."
}

# Pasar argumento a la función
saludar "Carlos"
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

## 📘 Códigos de Salida y `return`

Las funciones en Bash no devuelven objetos ni textos complejos al llamador mediante un comando "return". El comando `return` en Bash sirve exclusivamente para reportar un **código de estado de salida numérico** (entre 0 y 255).

- `return 0`: Éxito.
- `return 1` (o mayor): Error.

Para capturar la salida de texto de una función, debes usar la sustitución de comandos `$(función)`.

```bash
comprobar_web() {
    ping -c 1 google.com > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        return 0
    else
        return 1
    fi
}

comprobar_web
if [[ $? -eq 0 ]]; then
    echo "Tenemos conexión a Internet."
else
    echo "Sin conexión."
fi
```

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
