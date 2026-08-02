![Titulo](assets/cursobash.png)
[Día 11](./dia-11/README.md) -- [Inicio](./README.md) -- [Día 13](./dia-13/README.md)

# 📅 Día 12: Gestión de Procesos y Señales

En Unix, cada comando ejecutado crea un **proceso** al cual el sistema le asigna un número identificador único llamado **PID** (_Process ID_). Hoy aprenderemos cómo monitorear estos procesos, cómo ejecutarlos en segundo plano para no bloquear nuestra terminal, cómo enviarles "señales" para controlarlos y cómo escribir scripts capaces de autolimpiarse si se interrumpen inesperadamente.

---

## 📘 Conceptos Clave

### Primer Plano (Foreground) vs Segundo Plano (Background)

- **Foreground**: Por defecto, un comando corre en primer plano. No puedes escribir otros comandos en la terminal hasta que este finalice.
- **Background**: Permite ejecutar un comando en segundo plano, liberando la terminal de inmediato para seguir trabajando. Se logra añadiendo un `&` al final del comando.

---

## 🛠️ Comandos de Gestión de Procesos

| Comando   | Descripción                                                     | Ejemplo de Uso         |
| :-------- | :-------------------------------------------------------------- | :--------------------- |
| `&`       | Ejecuta un comando en segundo plano (_background_).             | `sleep 100 &`          |
| `jobs`    | Muestra la lista de tareas en background de la sesión actual.   | `jobs`                 |
| `fg`      | Trae una tarea en segundo plano al primer plano.                | `fg %1`                |
| `bg`      | Reanuda en segundo plano una tarea pausada.                     | `bg %1`                |
| `ps`      | Muestra el estado de los procesos actuales del sistema.         | `ps aux \| grep nginx` |
| `kill`    | Envía una señal (por defecto SIGTERM) a un proceso por su PID.  | `kill 1234`            |
| `killall` | Envía señales a todos los procesos que coincidan con un nombre. | `killall sleep`        |
| `trap`    | Captura señales en un script para ejecutar código de limpieza.  | Ver sección específica |

---

## 🔍 Explicación Detallada y Ejemplos

### 1. Controlando Tareas en la Terminal

Prueba estos pasos en tu consola:

```bash
# 1. Ejecutar un comando lento en primer plano
sleep 10
# Tienes que esperar 10 segundos para recuperar tu terminal...

# 2. Ejecutarlo en segundo plano
sleep 100 &
# Salida en terminal: [1] 54321  (El número 1 es el ID de tarea, 54321 es el PID)

# 3. Listar tareas activas
jobs
# Salida: [1]+  Ejecutando              sleep 100 &

# 4. Traer el comando sleep al primer plano
fg %1

# 5. Pausar un comando en ejecución
# Si pulsas Ctrl+Z en tu teclado, el comando se pausará y volverá a la terminal
# Para reanudarlo en segundo plano:
bg %1
```

---

### 2. Señales Comunes de Unix (`kill`)

`kill` no siempre significa "asesinar". Significa enviar una señal. Las señales más utilizadas son:

- **SIGINT (2)**: Interrupción de teclado. Se envía al pulsar `Ctrl+C`.
- **SIGTERM (15)**: Terminación suave. Es la señal por defecto. Pide al programa que guarde su estado y se cierre ordenadamente.
- **SIGKILL (9)**: Terminación forzada y destructiva. El sistema operativo detiene el proceso de inmediato sin dejar que limpie nada. Debe usarse como último recurso.
- **SIGHUP (1)**: Recarga de configuración (usado frecuentemente en servidores web como Apache o Nginx).

```bash
# Detener de forma segura el proceso con PID 54321
kill 54321

# Forzar el apagado del proceso con PID 54321
kill -9 54321
```

---

### 3. El Comando `trap` (Capturar señales en scripts)

Cuando un script de larga duración está corriendo y el usuario presiona `Ctrl+C` (SIGINT) o el script finaliza con un error, a veces quedan archivos temporales creados en disco. `trap` nos permite interceptar esas señales y ejecutar código de limpieza antes de morir.

```bash
#!/bin/bash

# Definir una función de limpieza
limpiar_archivos() {
    echo "¡Interrupción detectada! Eliminando archivos temporales..."
    rm -f /tmp/archivo_temporal_$$
    exit 1
}

# Asociar la función a las señales SIGINT (Ctrl+C) y SIGTERM
# El carácter especial $$ es una variable de sistema que contiene el PID de este script
trap limpiar_archivos SIGINT SIGTERM

# Crear archivo temporal
touch /tmp/archivo_temporal_$$

echo "Procesando datos pesados..."
sleep 20
```

---

## 💻 Ejercicios Prácticos

### Nivel Fácil

1. Abre tu terminal y ejecuta tres comandos `sleep 200 &` diferentes en segundo plano.
2. Utiliza el comando `jobs` para listar las tres tareas activas.
3. Termina de golpe las tres tareas utilizando el comando `killall`.

### Nivel Medio

1. Ejecuta una tarea en segundo plano: `sleep 500 &`.
2. Utiliza `ps aux` combinado con `grep` para encontrar el ID de Proceso (PID) específico de ese comando `sleep 500`.
3. Envía una señal SIGTERM (código 15) al PID identificado para terminarlo. Comprueba con `jobs` que ya no está activo.

### Nivel Difícil

1. Crea un script llamado `script_robusto.sh`.
2. Dentro de él, declara un bloque `trap` que capture la señal `EXIT` (una señal especial de Bash que ocurre cuando el script finaliza por cualquier motivo, sea éxito o fallo).
3. Haz que al activarse el `trap`, elimine un archivo temporal llamado `temporal.dat` que se creará en el directorio actual al iniciar el script.
4. Para simular un procesamiento real, haz que el script cree `temporal.dat`, imprima `"Generando datos..."`, haga un `sleep 10` y termine.
5. Ejecuta el script e interrúmpelo manualmente a los pocos segundos pulsando `Ctrl+C`. Verifica que el archivo `temporal.dat` ha sido eliminado automáticamente a pesar de la interrupción repentina.

---

<details>
<summary>💡 Ver Soluciones Sugeridas</summary>

### Nivel Fácil

1. Ejecuta en tu consola:
   ```bash
   sleep 200 &
   sleep 200 &
   sleep 200 &
   ```
2. Ejecuta `jobs`.
3. Ejecuta `killall sleep`.

### Nivel Medio

1. `sleep 500 &`
2. `ps aux | grep "sleep 500"`
   _(Verás una línea que muestra tu usuario, el PID en la segunda columna, y al final `sleep 500`)_.
3. Si el PID es `12345`, ejecuta:
   `kill 12345` (o de forma explícita `kill -15 12345`).

### Nivel Difícil

1. El script `script_robusto.sh`:

   ```bash
   #!/bin/bash

   # Crear nombre de archivo temporal
   TEMP_FILE="temporal.dat"

   # Función de limpieza
   limpieza() {
       if [[ -f "$TEMP_FILE" ]]; then
           echo -e "\n[Limpieza] Eliminando archivo temporal '$TEMP_FILE'..."
           rm -f "$TEMP_FILE"
       fi
   }

   # Capturar salida EXIT (cubre Ctrl+C, fallos y terminación normal)
   trap limpieza EXIT

   # Crear el archivo
   touch "$TEMP_FILE"
   echo "Archivo temporal creado."

   echo "Simulando proceso pesado de 10 segundos..."
   sleep 10

   echo "Proceso finalizado correctamente."
   ```

2. Dale permisos `chmod +x script_robusto.sh`.
3. Ejecútalo (`./script_robusto.sh`) y pulsa rápidamente `Ctrl+C` en tu teclado. Verás cómo imprime el mensaje del bloque `limpieza` y el archivo `temporal.dat` no queda huérfano en tu carpeta.

</details>
