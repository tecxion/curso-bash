![Titulo](assets/cursobash.png)
[Día 1](./dia-01/README.md) -- [Inicio](./README.md) -- [Día 2](./dia-02/README.md)

# 📅 Día 2: Manipulación y Visualización de Archivos

Ayer aprendimos a navegar y crear archivos vacíos. Hoy aprenderemos a ver el contenido de los archivos y a realizar las cuatro operaciones esenciales sobre el sistema de archivos: copiar, mover (y renombrar), eliminar y enlazar.

---

## 📘 Conceptos Clave

### Enlaces Físicos (Hard Links) vs Enlaces Simbólicos (Symlinks)

En Unix, los nombres de archivos son punteros a un bloque físico del disco llamado _inode_ (inodo).

- **Enlace Físico (`ln archivo enlace`)**: Crea una copia del puntero al mismo espacio de disco. Si borras el archivo original, el enlace físico sigue conteniendo los datos. No pueden apuntar a directorios ni cruzar distintos discos/particiones.
- **Enlace Simbólico (`ln -s archivo enlace`)**: Es un "acceso directo". Apunta a la ruta del archivo original. Si el original se borra, el enlace simbólico queda "roto" (apunta a la nada). Puede apuntar a directorios y a diferentes particiones.

---

## 🛠️ Comandos Esenciales de Hoy

| Comando | Descripción                                                          | Ejemplo                         |
| :------ | :------------------------------------------------------------------- | :------------------------------ |
| `cat`   | Concatena y muestra el contenido completo de un archivo.             | `cat config.txt`                |
| `less`  | Visualizador interactivo de archivos grandes (permite desplazarse).  | `less log.txt`                  |
| `head`  | Muestra las primeras líneas de un archivo (10 por defecto).          | `head -n 5 notas.txt`           |
| `tail`  | Muestra las últimas líneas de un archivo. Útil para monitorear logs. | `tail -f logs.log`              |
| `cp`    | Copia archivos y directorios.                                        | `cp -r carpeta/ copia_carpeta/` |
| `mv`    | Mueve o renombra archivos y carpetas.                                | `mv notas.txt backup/`          |
| `rm`    | Elimina archivos y carpetas de forma permanente.                     | `rm -rf temporal/`              |
| `ln`    | Crea enlaces (físicos o simbólicos) entre archivos.                  | `ln -s origen.txt link.txt`     |

---

## 🔍 Explicación Detallada y Ejemplos

### 1. Visualización de Contenidos

- **`cat`**: Ideal para archivos pequeños. Si el archivo es muy grande, inundará tu terminal.
- **`less`**: El mejor amigo del administrador de sistemas. Te permite buscar dentro del archivo usando `/palabra`, avanzar con `Espacio` y retroceder con `b`. Sales presionando `q`.
- **`head` y `tail`**: Muy eficientes para previsualizar estructuras de datos.

  ```bash
  # Ver las primeras 15 líneas de un log
  head -n 15 /var/log/syslog

  # Ver las últimas 5 líneas y mantener el archivo abierto monitoreando cambios en vivo
  tail -n 5 -f /var/log/nginx/access.log
  ```

---

### 2. Copiar, Mover y Eliminar

- **Copiar (`cp`)**:
  Para copiar carpetas enteras con todo su contenido, debes usar la opción recursiva `-r`:

  ```bash
  cp -r modulo1/ modulo1_copia/
  ```

- **Mover y Renombrar (`mv`)**:
  En Linux, "renombrar" es simplemente mover un archivo a la misma ruta pero con diferente nombre.

  ```bash
  # Renombrar un archivo
  mv apuntes.txt notas_importantes.txt

  # Mover a otra carpeta
  mv notas_importantes.txt modulo1/
  ```

- **Eliminar (`rm`)**:
  > [!WARNING]
  > En la terminal no existe la Papelera de Reciclaje. Lo que borras con `rm` desaparece de inmediato.
  - `rm archivo.txt`: Borra un archivo.
  - `rm -r carpeta/`: Borra una carpeta y su contenido recursivamente.
  - `rm -f archivo.txt`: Fuerza el borrado sin pedir confirmación.
  - `rm -rf carpeta/`: Fuerza el borrado de una carpeta de forma recursiva y silenciosa. ¡Úsalo con extremo cuidado!

---

### 3. Crear Enlaces

```bash
# Crear un archivo de prueba
touch original.txt

# Crear un Enlace Simbólico (Symlink)
ln -s original.txt acceso_directo.txt

# Verificar en el listado largo (verás que apunta al original)
ls -l acceso_directo.txt
# Salida: acceso_directo.txt -> original.txt
```

---

## 💻 Ejercicios Prácticos

### Nivel Fácil

1. Crea un directorio llamado `dia2_practica`.
2. Dentro de él, crea un archivo llamado `lista.txt` que contenga algún texto sencillo (puedes crearlo con `echo "Hola Mundo" > lista.txt`).
3. Copia el archivo `lista.txt` con el nombre `lista_copia.txt` en el mismo directorio.
4. Crea una subcarpeta llamada `descarte` y mueve `lista_copia.txt` allí dentro.

### Nivel Medio

1. Crea un archivo grande de mentira ejecutando este comando:
   `for i in {1..100}; do echo "Línea número $i"; done > lineas.txt`.
2. Muestra las primeras 8 líneas de `lineas.txt`.
3. Muestra las últimas 12 líneas de `lineas.txt`.
4. Visualiza el archivo usando `less` y practica buscar el patrón "Línea número 45" usando la tecla `/`. Sal del visualizador.

### Nivel Difícil

1. Crea un enlace simbólico de `lineas.txt` llamado `enlace_simb.txt`.
2. Crea un enlace físico de `lineas.txt` llamado `enlace_fis.txt`.
3. Elimina el archivo original `lineas.txt` (`rm lineas.txt`).
4. Intenta leer el contenido de ambos enlaces utilizando `cat`. ¿Cuál de los dos fallará y por qué? Explica el resultado.

---

<details>
<summary>💡 Ver Soluciones Sugeridas</summary>

### Nivel Fácil

1. `mkdir dia2_practica`
2. `cd dia2_practica && echo "Hola Mundo" > lista.txt`
3. `cp lista.txt lista_copia.txt`
4. `mkdir descarte && mv lista_copia.txt descarte/`

### Nivel Medio

1. Ejecuta el bucle directamente en la terminal:
   `for i in {1..100}; do echo "Línea número $i"; done > lineas.txt`
2. `head -n 8 lineas.txt`
3. `tail -n 12 lineas.txt`
4. Ejecuta `less lineas.txt`. Luego pulsa `/`, escribe `45` y presiona `Enter`. Para salir pulsa `q`.

### Nivel Difícil

1. `ln -s lineas.txt enlace_simb.txt`
2. `ln lineas.txt enlace_fis.txt`
3. `rm lineas.txt`
4. Intenta leerlos:
   - `cat enlace_simb.txt` -> Dará un error del tipo "No existe el archivo o el directorio". Esto ocurre porque el enlace simbólico apuntaba a la ruta literal `lineas.txt`, la cual fue eliminada.
   - `cat enlace_fis.txt` -> Mostrará las 100 líneas intactas. Esto se debe a que el enlace físico apunta al inodo real en disco que contiene los datos, y ese inodo no se libera hasta que el número de enlaces que apuntan a él sea cero.

</details>
