# 📅 Día 1: Introducción a Bash y la CLI

¡Bienvenido al primer día de tu viaje para dominar Bash! Hoy aprenderemos los conceptos fundamentales de la línea de comandos, cómo movernos por el sistema de archivos y cómo crear elementos básicos.

---

## 📘 Conceptos Clave

### ¿Qué es la CLI, la Terminal y la Shell?
A menudo estos términos se usan indistintamente, pero representan cosas distintas:
*   **CLI (Command Line Interface)**: Interfaz de Línea de Comandos. Es un método para interactuar con un ordenador escribiendo instrucciones de texto en lugar de hacer clic en una interfaz gráfica (GUI).
*   **Terminal**: Es el programa que aloja la interfaz gráfica donde se escribe. Ejemplos: GNOME Terminal, PowerShell, iTerm2, Alacritty.
*   **Shell (Consola)**: Es el intérprete de comandos. Es el software que lee lo que introduces en la terminal, lo procesa y le pide al sistema operativo que ejecute la acción. **Bash** (*Bourne Again SHell*) es la shell más popular de la historia.

### Anatomía de un Comando
Casi todos los comandos en Unix siguen una estructura básica:
```bash
comando [opciones] [argumentos]
```
*   **Comando**: La acción que queremos realizar (ej. `ls`).
*   **Opciones (flags/banderas)**: Modifican el comportamiento del comando. Suelen empezar con `-` (corto) o `--` (largo). (ej. `-l` o `--all`).
*   **Argumentos**: El objeto sobre el cual actúa el comando (ej. un archivo o ruta).

---

## 🛠️ Comandos Esenciales de Hoy

| Comando | Descripción | Ejemplo |
|:---|:---|:---|
| `pwd` | Muestra el directorio de trabajo actual (*Print Working Directory*). | `pwd` |
| `ls` | Lista los archivos y carpetas del directorio actual. | `ls -la` |
| `cd` | Cambia el directorio de trabajo actual (*Change Directory*). | `cd /var/log` |
| `mkdir` | Crea un nuevo directorio (*Make Directory*). | `mkdir mi_carpeta` |
| `touch` | Crea un archivo vacío o actualiza su marca de tiempo. | `touch notas.txt` |
| `man` | Muestra el manual de ayuda de un comando. | `man ls` |

---

## 🔍 Explicación Detallada y Ejemplos

### 1. Obtención de Ayuda
Antes de aprender a usar un comando, es fundamental saber cómo pedir ayuda sobre él:
*   **El comando `man`**: Abre el manual de usuario interactivo del comando. Presiona `q` para salir y usa las flechas para desplazarte.
    ```bash
    man ls
    ```
*   **La opción `--help`**: La mayoría de comandos modernos admiten una ayuda rápida integrada:
    ```bash
    mkdir --help
    ```

---

### 2. Navegación por el Sistema de Archivos

Para moverte por los archivos, necesitas entender la diferencia entre:
*   **Ruta Absoluta**: Comienza desde la raíz `/` (ej. `/home/usuario/documentos`).
*   **Ruta Relativa**: Comienza desde tu posición actual (ej. `documentos/notas`).

#### Comandos Especiales de Ruta:
*   `.` representa el **directorio actual**.
*   `..` representa el **directorio padre** (un nivel superior).
*   `~` representa tu **directorio personal (Home)**.
*   `-` te devuelve al **último directorio** donde estuviste antes del cambio actual.

#### Ejemplos de Navegación:
```bash
# Ir a la carpeta personal
cd ~

# Ver dónde estamos
pwd

# Subir un nivel en el árbol de directorios
cd ..

# Ir a una ruta absoluta específica
cd /var/log
```

#### Listado con `ls` y sus modificadores más útiles:
*   `ls -l`: Formato de lista larga (muestra permisos, tamaño, propietario, fecha).
*   `ls -a`: Muestra archivos ocultos (los que empiezan con `.`).
*   `ls -h`: Muestra tamaños en formato legible para humanos (ej. 1K, 234M, 2G).
*   `ls -t`: Ordena por fecha de última modificación (el más nuevo primero).

```bash
# Combinando opciones de forma común:
ls -lah
```

---

### 3. Creación de Archivos y Carpetas

*   **Crear carpetas**:
    ```bash
    mkdir proyectos
    ```
    Si quieres crear una estructura de carpetas anidadas en un solo paso, usa la opción `-p` (*parents*):
    ```bash
    mkdir -p proyectos/2026/agosto
    ```

*   **Crear archivos vacíos**:
    ```bash
    touch proyectos/2026/agosto/ideas.txt
    ```

---

## 💻 Ejercicios Prácticos

### Nivel Fácil
1. Abre tu terminal y averigua el nombre de tu directorio actual utilizando el comando adecuado.
2. Lista todos los archivos (incluyendo los ocultos) del directorio actual en formato largo y con el tamaño de archivo legible para humanos.
3. Regresa a tu directorio principal (`Home`) en un solo comando rápido.

### Nivel Medio
1. Crea un directorio llamado `curso-bash-practica` en tu carpeta personal.
2. Dentro de este directorio, crea tres subcarpetas anidadas en un solo comando: `modulo1/ejercicios/dia1`.
3. Crea un archivo vacío llamado `apuntes.txt` dentro de la carpeta `dia1`.

### Nivel Difícil
1. Navega a la carpeta `/var/log` (si estás en Windows Git Bash o WSL) o al directorio `/etc`. Usa `ls` ordenado por fecha de modificación para ver cuál fue el último archivo o directorio modificado.
2. Regresa a la carpeta `dia1` creada anteriormente utilizando únicamente el carácter especial que te devuelve al directorio anterior (`-`).
3. Lee el manual del comando `mkdir` y encuentra qué bandera (`flag`) sirve para definir permisos específicos al crear la carpeta (lo profundizaremos en el Día 3).

---

<details>
<summary>💡 Ver Soluciones Sugeridas</summary>

### Nivel Fácil
1. Usa `pwd` para ver el directorio actual.
2. Usa `ls -lah` o `ls -l -a -h`.
3. Usa `cd ~` o simplemente `cd` (sin argumentos te lleva a tu Home por defecto).

### Nivel Medio
1. `cd ~ && mkdir curso-bash-practica`
2. `cd curso-bash-practica && mkdir -p modulo1/ejercicios/dia1`
3. `touch modulo1/ejercicios/dia1/apuntes.txt`

### Nivel Difícil
1. `cd /var/log` y luego `ls -lt` (el primero de la lista es el más recientemente modificado).
2. Si antes de `/var/log` estabas en `dia1` (ruta completa), simplemente escribe `cd -`.
3. Leyendo `man mkdir` o `mkdir --help`, encontrarás la opción `-m` o `--mode`. Ejemplo: `mkdir -m 777 nueva_carpeta`.

</details>
