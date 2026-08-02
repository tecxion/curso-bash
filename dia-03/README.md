![Titulo](./assets/cursobash.png)
[Día 2](./dia-02/README.md) -- [Inicio](./README.md) -- [Día 4](./dia-04/README.md)

# 📅 Día 3: Permisos y Usuarios en Linux/Bash

Ayer manipulamos archivos. Hoy entraremos en un concepto fundamental para la seguridad y el funcionamiento del sistema: el sistema de permisos de Unix/Linux. Aprenderemos quién es dueño de qué y cómo controlar quién puede leer, escribir o ejecutar nuestros archivos.

---

## 📘 Conceptos Clave

### El Modelo de Usuarios y Grupos

En Unix, cada archivo pertenece a un **Usuario** (propietario) y a un **Grupo** de usuarios.
Hay tres categorías de personas respecto a un archivo:

1.  **u (User/Owner)**: El propietario del archivo.
2.  **g (Group)**: Los miembros del grupo asignado al archivo.
3.  **o (Others)**: Todos los demás usuarios del sistema.
4.  **a (All)**: Todos los anteriores juntos.

### Los Tres Permisos Básicos (`rwx`)

- **r (Read / Lectura)**:
  - _Archivos_: Permite leer el contenido del archivo.
  - _Directorios_: Permite listar los archivos dentro de él (`ls`).
- **w (Write / Escritura)**:
  - _Archivos_: Permite modificar o borrar el archivo.
  - _Directorios_: Permite crear, renombrar o eliminar archivos dentro de él.
- **x (Execute / Ejecución)**:
  - _Archivos_: Permite correr el archivo como un programa/script.
  - _Directorios_: Permite acceder a él (hacer `cd` para entrar).

---

## 🔍 Entendiendo la Salida de `ls -l`

Cuando haces `ls -l`, verás una cadena de 10 caracteres al inicio como esta:

```text
- rwx r-x r--  1 usuario grupo  123 ago 2 12:00 script.sh
```

Desglosemos los 10 caracteres:

- **1er carácter**: Tipo de archivo. `-` es archivo normal, `d` es directorio, `l` es enlace simbólico.
- **Caracteres 2, 3, 4**: Permisos del **propietario (User)** -> `rwx` (Lectura, Escritura y Ejecución).
- **Caracteres 5, 6, 7**: Permisos del **Grupo (Group)** -> `r-x` (Lectura y Ejecución, sin escritura).
- **Caracteres 8, 9, 10**: Permisos de **Otros (Others)** -> `r--` (Solo lectura).

---

## 🛠️ Comandos Esenciales de Hoy

| Comando  | Descripción                                                      | Ejemplo                      |
| :------- | :--------------------------------------------------------------- | :--------------------------- |
| `chmod`  | Cambia los permisos (_Change Mode_) de un archivo o directorio.  | `chmod +x script.sh`         |
| `chown`  | Cambia el usuario propietario y/o grupo propietario del archivo. | `chown root:admin script.sh` |
| `chgrp`  | Cambia el grupo propietario de un archivo.                       | `chgrp desarrollo notas.txt` |
| `sudo`   | Ejecuta un comando con privilegios de superusuario (`root`).     | `sudo apt update`            |
| `whoami` | Muestra el nombre de usuario actual de la terminal.              | `whoami`                     |

---

## 🔍 Métodos para Cambiar Permisos con `chmod`

Existen dos formas principales de usar `chmod`:

### 1. Notación Simbólica (Letras)

Indicas la categoría (`u`, `g`, `o`, `a`), el operador (`+` añade, `-` quita, `=` asigna exactamente) y el permiso (`r`, `w`, `x`).

```bash
# Dar permisos de ejecución al propietario
chmod u+x script.sh

# Quitar permisos de escritura al grupo y a otros
chmod g-w,o-w archivo.txt

# Hacer que un archivo sea ejecutable para todos
chmod a+x script.sh
```

### 2. Notación Numérica (Octal)

Representas cada grupo de 3 permisos como un número de tres dígitos. Cada permiso tiene un valor numérico:

- `r` = 4
- `w` = 2
- `x` = 1
- Sin permiso `-` = 0

Sumas los valores para obtener el número de cada categoría:

- `rwx` = 4 + 2 + 1 = **7**
- `rw-` = 4 + 2 + 0 = **6**
- `r-x` = 4 + 0 + 1 = **5**
- `r--` = 4 + 0 + 0 = **4**
- `---` = 0 + 0 + 0 = **0**

```bash
# Permisos muy comunes:
# Propietario lee/escribe/ejecuta (7), grupo lee/ejecuta (5), otros lee/ejecuta (5)
chmod 755 script.sh

# Propietario lee/escribe (6), grupo lee (4), otros lee (4)
chmod 644 documento.txt

# Totalmente privado: Propietario lee/escribe (6), nadie más hace nada (00)
chmod 600 clave_privada.pem
```

---

## 💻 Ejercicios Prácticos

### Nivel Fácil

1. Escribe el comando para comprobar con qué nombre de usuario estás logueado en la terminal.
2. Crea un archivo llamado `privado.txt`. Configura sus permisos usando notación numérica para que tú (el propietario) puedas leerlo y escribirlo, pero absolutamente nadie más pueda acceder a él.
3. Verifica la cadena de permisos en tu terminal usando `ls -l`.

### Nivel Medio

1. Crea un directorio llamado `compartido`.
2. Modifica los permisos de `compartido` para que cualquier usuario pueda entrar en él (`x`) y ver su contenido (`r`), pero que nadie excepto tú pueda crear o borrar archivos en su interior (`w`). Usa la notación numérica.
3. Crea un archivo llamado `ejecutable.sh` dentro de `compartido` y dale permisos de ejecución a todo el mundo usando la notación simbólica.

### Nivel Difícil

1. Si creas una carpeta llamada `protegida` y le quitas el permiso de ejecución (`x`) para tu usuario (`chmod u-x protegida`), pero le dejas el permiso de lectura (`r`), ¿qué ocurre si intentas hacer `ls protegida`? ¿Y qué ocurre si haces `cd protegida`? Pruébalo y explica la diferencia.
2. Traduce los siguientes permisos numéricos a representación simbólica de 10 caracteres (ej. `-rwxr-xr-x`):
   - `600` (Archivo normal)
   - `754` (Archivo normal)
   - `700` (Directorio)
3. Escribe el comando para cambiar el propietario de un archivo llamado `sistema.conf` para que pertenezca al usuario `root` y al grupo `sysadmin` en un solo comando (requiere privilegios de administrador).

---

<details>
<summary>💡 Ver Soluciones Sugeridas</summary>

### Nivel Fácil

1. Usa `whoami`.
2. `touch privado.txt` y luego `chmod 600 privado.txt`.
3. `ls -l privado.txt` (debería mostrar `-rw-------`).

### Nivel Medio

1. `mkdir compartido`
2. El propietario necesita todo: `rwx` = 7. El grupo y otros necesitan entrar y listar: `rx` = 5. Comando: `chmod 755 compartido`.
3. `touch compartido/ejecutable.sh` y luego `chmod a+x compartido/ejecutable.sh` o `chmod +x compartido/ejecutable.sh` (si omites el usuario, por defecto suele aplicar a todos según la máscara del sistema).

### Nivel Difícil

1. Resultados de quitar `x` en un directorio:
   - `cd protegida` -> Dará error "Permiso denegado". Sin el permiso `x` no puedes cambiar de directorio hacia él.
   - `ls protegida` -> Dependiendo del sistema, puede fallar completamente o listar los nombres de los archivos pero lanzar errores al intentar leer detalles (tamaños, dueños, etc.), ya que para leer los metadatos de los archivos del directorio se necesita poder cruzar su inodo (`x`).
2. Traducción de permisos:
   - `600` (Archivo normal): `-rw-------`
   - `754` (Archivo normal): `-rwxr-xr--`
   - `700` (Directorio): `drwx------`
3. Usando `sudo chown`:
   `sudo chown root:sysadmin sistema.conf`

</details>
