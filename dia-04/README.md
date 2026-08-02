![Titulo](assets/cursobash.png)
[Día 3](./dia-03/README.md) -- [Inicio](./README.md) -- [Día 5](./dia-05/README.md)

# 📅 Día 4: Entrada/Salida, Redirecciones y Pipes

En Unix, existe una filosofía fundamental: **"Escribe programas que hagan una sola cosa y la hagan bien. Escribe programas para que trabajen juntos"**. Hoy aprenderemos a interconectar comandos dirigiendo los datos de uno hacia otro usando las redirecciones y las tuberías (pipes).

---

## 📘 Conceptos Clave

### Los Tres Canales Estándar (I/O Streams)

Cuando ejecutas un comando en Bash, el sistema le asigna tres "canales" o descriptores de archivos predeterminados:

1.  **stdin (Standard Input - Descriptor 0)**: Por donde el programa recibe información (por defecto, el teclado).
2.  **stdout (Standard Output - Descriptor 1)**: Por donde el programa emite sus resultados normales (por defecto, la pantalla).
3.  **stderr (Standard Error - Descriptor 2)**: Por donde el programa emite mensajes de error o depuración (por defecto, la pantalla).

---

## 🛠️ Comandos y Operadores de Hoy

| Operador / Comando | Descripción                                                  | Ejemplo                           |
| :----------------: | :----------------------------------------------------------- | :-------------------------------- |
|        `>`         | Redirecciona stdout a un archivo (sobrescribe si existe).    | `echo "hola" > saludo.txt`        |
|        `>>`        | Redirecciona stdout a un archivo (añade al final).           | `echo "mundo" >> saludo.txt`      |
|        `<`         | Redirecciona stdin desde un archivo.                         | `wc -l < saludo.txt`              |
|        `2>`        | Redirecciona los errores (stderr) a un archivo.              | `ls inexistente.txt 2> error.log` |
|        `&>`        | Redirecciona tanto stdout como stderr al mismo archivo.      | `comando &> todo.log`             |
|    `\|` (Pipe)     | Envía la salida estándar de un comando como entrada de otro. | `ls -la \| less`                  |
|       `tee`        | Lee de stdin y escribe tanto en stdout como en archivos.     | `ls \| tee lista.txt`             |

---

## 🔍 Explicación Detallada y Ejemplos

### 1. Redirecciones Simples (`>` y `>>`)

- **Sobrescribir (`>`)**:
  ```bash
  echo "Línea A" > archivo.txt
  echo "Línea B" > archivo.txt
  cat archivo.txt
  # Salida: Línea B (la Línea A fue sobrescrita)
  ```
- **Añadir (`>>`)**:
  ```bash
  echo "Línea A" > archivo.txt
  echo "Línea B" >> archivo.txt
  cat archivo.txt
  # Salida:
  # Línea A
  # Línea B
  ```

---

### 2. Controlando los Errores (`2>`)

A veces ejecutas un comando que puede fallar y no quieres que sus mensajes de error inunden tu pantalla o se mezclen con el resultado correcto.

```bash
# Intentamos buscar archivos en una carpeta protegida
find /etc -name "shadow" 2> errores.log
# Esto buscará shadow, pero todos los mensajes de "Permiso denegado" se guardarán en errores.log
```

#### Enviar al "limbo" (`/dev/null`)

Si directamente quieres ignorar los errores y no guardarlos, puedes enviarlos al archivo especial `/dev/null`, que actúa como un agujero negro de datos:

```bash
ls /carpeta/inexistente 2> /dev/null
```

---

### 3. Tuberías (Pipes `|`)

Las tuberías te permiten conectar la salida de un programa con la entrada del siguiente sin necesidad de crear archivos temporales.

```bash
# Listar los archivos en /etc, pasar la lista al comando 'grep' para filtrar solo
# los que contienen "resolv", y ver el resultado final
ls /etc | grep "resolv"
```

---

### 4. El Comando `tee` (T en tubería)

El comando `tee` toma la entrada y hace dos copias: una la manda a la pantalla y la otra la guarda en un archivo. Es muy útil cuando quieres auditar un comando en tiempo real mientras guardas el registro.

```bash
# Lista archivos, muéstralos en pantalla y guárdalos en 'listado.txt'
ls -l | tee listado.txt
```

---

## 💻 Ejercicios Prácticos

### Nivel Fácil

1. Crea un archivo llamado `fecha.txt` que contenga la fecha y hora actual del sistema utilizando el comando `date` y redirección.
2. Añade tu nombre completo al final del archivo `fecha.txt` usando otra redirección.
3. Imprime por pantalla el contenido de `fecha.txt` para validar.

### Nivel Medio

1. Ejecuta un comando erróneo a propósito (por ejemplo, `ls /no-existe`) y redirecciona únicamente el error a un archivo llamado `errores.txt`. Comprueba que `errores.txt` tiene el mensaje de error dentro.
2. Escribe una sola línea de comandos que cuente cuántos archivos y directorios hay en la carpeta actual utilizando `ls`, una tubería (`|`) y el comando `wc -l`.
3. Ejecuta `ls` redireccionando los errores al agujero negro `/dev/null` y la salida correcta a un archivo llamado `salida.txt` de manera simultánea en una sola instrucción.

### Nivel Difícil

1. Explica la diferencia exacta entre las dos siguientes instrucciones:
   - `cat < archivo.txt`
   - `cat archivo.txt`
2. Investiga qué hace la redirección `2>&1`. ¿Qué diferencia hay entre usar `comando > log.txt 2>&1` y usar `comando 2>&1 > log.txt`? (Pruébalo con algún comando que genere salida y error).
3. Utilizando `echo`, una tubería, y el comando `tee`, escribe la palabra "Prueba de tee" para que se muestre en pantalla y, a la vez, se añada (sin borrar el contenido previo) al final del archivo `fecha.txt` creado en el Nivel Fácil. (Pista: consulta `man tee` para ver cómo añadir en lugar de sobrescribir).

---

<details>
<summary>💡 Ver Soluciones Sugeridas</summary>

### Nivel Fácil

1. `date > fecha.txt`
2. `echo "Tu Nombre Completo" >> fecha.txt`
3. `cat fecha.txt`

### Nivel Medio

1. `ls /no-existe 2> errores.txt` y luego comprobar con `cat errores.txt`.
2. `ls | wc -l` (el comando `ls` genera una lista línea a línea, que entra a `wc -l` para contar las líneas totales).
3. `ls /carpeta_valida /no_valida > salida.txt 2> /dev/null` (reemplaza por rutas reales/ficticias para probar).

### Nivel Difícil

1. Diferencia entre redirección de entrada y argumento:
   - `cat archivo.txt` abre el archivo pasándole la ruta como argumento. El proceso `cat` es responsable de abrir el archivo directamente.
   - `cat < archivo.txt` hace que Bash abra el archivo y conecte su contenido al canal `stdin` (descriptor 0) del proceso `cat`. El comando `cat` no sabe el nombre del archivo, solo lee lo que le llega por su entrada estándar. El resultado final suele ser el mismo, pero el mecanismo interno es muy diferente.
2. La redirección `2>&1` redirecciona el canal 2 (stderr) a donde esté apuntando actualmente el canal 1 (stdout).
   - `comando > log.txt 2>&1`: Primero, el canal 1 se apunta a `log.txt`. Luego, el canal 2 se apunta al canal 1 (que es `log.txt`). Ambos canales terminan escribiendo en `log.txt`. **Esta forma funciona**.
   - `comando 2>&1 > log.txt`: Primero, el canal 2 se apunta a donde apunta el canal 1 (que por defecto es la terminal). Luego, el canal 1 se apunta a `log.txt`. Los errores seguirán saliendo por la terminal y la salida normal irá a `log.txt`. **No logras el objetivo**.
3. Leyendo `man tee`, la opción para añadir es `-a` (`--append`). El comando sería:
   `echo "Prueba de tee" | tee -a fecha.txt`

</details>
