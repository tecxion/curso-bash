![Titulo](./assets/cursobash.png)
[Día 7](./dia-07/README.md) -- [Inicio](./README.md) -- [Día 9](./dia-09/README.md)

# 📅 Día 8: Estructuras Condicionales (if, case)

Ayer aprendimos a evaluar condiciones de forma aislada. Hoy le daremos el control de flujo a nuestros scripts utilizando las estructuras condicionales `if-else` y `case`. Esto permitirá que tus programas ejecuten diferentes bloques de código según las entradas del usuario, los archivos presentes o el estado del sistema.

---

## 📘 Estructura `if-elif-else`

La sintaxis del `if` en Bash requiere prestar atención a la colocación del `; then` y el cierre con `fi` (que es "if" al revés).

### Sintaxis Básica:

```bash
if [[ condicion ]]; then
    # Código a ejecutar si es verdadero
elif [[ otra_condicion ]]; then
    # Código si la primera es falsa pero esta es verdadera
else
    # Código si ninguna de las anteriores se cumple
fi
```

### Ejemplo: Comprobando espacio en disco

```bash
#!/bin/bash
espacio_libre=15 # Supongamos un 15% libre

if [[ $espacio_libre -lt 10 ]]; then
    echo "¡Alerta! El espacio en disco es crítico (menor al 10%)."
elif [[ $espacio_libre -lt 20 ]]; then
    echo "Advertencia: El espacio en disco está bajo."
else
    echo "Espacio en disco óptimo."
fi
```

---

## 📘 Estructura `case` (Menús e igualación de patrones)

Cuando tienes múltiples opciones que verificar basadas en una sola variable, usar demasiados `elif` puede volver el código ilegible. La estructura `case` (similar al _switch-case_ de otros lenguajes) es la solución perfecta.

### Sintaxis Básica:

```bash
case $variable in
    patron1)
        # Código para patron1
        ;; # Indica el fin de este bloque
    patron2|patron3)
        # Código para patron2 O patron3
        ;;
    *)
        # Bloque por defecto (si nada coincide)
        ;;
esac
```

### Ejemplo: Menú de opciones

```bash
#!/bin/bash
echo "Selecciona una opción:"
echo "1. Respaldar sistema"
echo "2. Limpiar caché"
echo "3. Salir"
read -p "Introduce una opción (1-3): " opcion

case $opcion in
    1)
        echo "Iniciando copia de seguridad..."
        ;;
    2)
        echo "Limpiando archivos temporales..."
        ;;
    3)
        echo "Saliendo del programa."
        ;;
    *)
        echo "Opción no válida. Introduce un número del 1 al 3."
        ;;
esac
```

---

## 🛠️ Variables Especiales para Scripts

Al ejecutar un script pasándole argumentos (ej: `./script.sh archivo.txt /var/log`), podemos validar dichos parámetros dentro del script usando estas variables:

- `$#`: Devuelve la cantidad de argumentos recibidos por el script.
- `$1`, `$2`, `$3`...: El primer, segundo, tercer argumento.
- `$0`: El nombre del script que se está ejecutando.
- `$@`: Todos los argumentos como una lista.

---

## 💻 Ejercicios Prácticos

### Nivel Fácil

1. Crea un script llamado `es_mayor.sh`.
2. El script debe pedir al usuario que introduzca su edad usando el comando `read -p "Introduce tu edad: " edad`.
3. Utilizando una estructura `if-else`, comprueba si es mayor de edad (18 años o más). Si es así, imprime `"Eres mayor de edad"`, de lo contrario imprime `"Eres menor de edad"`.

### Nivel Medio

1. Crea un script llamado `valida_argumentos.sh`.
2. El script debe verificar si se le ha pasado exactamente un argumento cuando se ejecuta (es decir, `$#` debe ser igual a 1).
3. Si el script no recibe argumentos, o recibe más de uno, debe imprimir un mensaje de error explicativo y salir del script con un código de error `exit 1`.
4. Si recibe exactamente un argumento, debe comprobar si ese argumento corresponde a un archivo que existe y es legible. Imprime un reporte adecuado en pantalla en cada caso.

### Nivel Difícil

1. Crea un script llamado `gestion_servicios.sh` que reciba un argumento.
2. El script debe evaluar el primer argumento utilizando un bloque `case`.
3. Si el argumento es `"start"`, debe imprimir `"Iniciando el servicio..."`.
4. Si es `"stop"`, debe imprimir `"Deteniendo el servicio..."`.
5. Si es `"restart"`, debe imprimir `"Reiniciando el servicio..."`.
6. Si recibe cualquier otra cosa (o nada), debe imprimir un mensaje de ayuda indicando el uso correcto: `"Uso: ./gestion_servicios.sh {start|stop|restart}"` y finalizar con un código de salida `exit 1`.

---

<details>
<summary>💡 Ver Soluciones Sugeridas</summary>

### Nivel Fácil

1. El script `es_mayor.sh`:

   ```bash
   #!/bin/bash
   read -p "Introduce tu edad: " edad

   # Validar que no esté vacío y sea un número
   if [[ -z "$edad" ]]; then
       echo "No has introducido ningún valor."
       exit 1
   fi

   if [[ $edad -ge 18 ]]; then
       echo "Eres mayor de edad."
   else
       echo "Eres menor de edad."
   fi
   ```

### Nivel Medio

1. El script `valida_argumentos.sh`:

   ```bash
   #!/bin/bash

   # Verificar si hay exactamente 1 argumento
   if [[ $# -ne 1 ]]; then
       echo "Error: Debes pasar exactamente un argumento al script."
       echo "Uso: $0 [ruta_al_archivo]"
       exit 1
   fi

   # Guardar el argumento en una variable con nombre descriptivo
   archivo="$1"

   # Comprobar si existe y es un archivo regular
   if [[ -f "$archivo" ]]; then
       echo "El archivo '$archivo' existe."
       if [[ -r "$archivo" ]]; then
           echo "Además, tienes permisos de lectura sobre él."
       else
           echo "Sin embargo, no tienes permisos de lectura."
       fi
   else
       echo "El archivo '$archivo' no existe o no es un archivo regular."
   fi
   ```

### Nivel Difícil

1. El script `gestion_servicios.sh`:

   ```bash
   #!/bin/bash

   # Validar que al menos haya un argumento
   if [[ $# -lt 1 ]]; then
       echo "Error: Falta el comando de acción."
       echo "Uso: $0 {start|stop|restart}"
       exit 1
   fi

   accion="$1"

   case $accion in
       start)
           echo "Iniciando el servicio..."
           ;;
       stop)
           echo "Deteniendo el servicio..."
           ;;
       restart)
           echo "Reiniciando el servicio..."
           ;;
       *)
           echo "Acción '$accion' no reconocida."
           echo "Uso: $0 {start|stop|restart}"
           exit 1
           ;;
   esac
   ```

</details>
