# 📚 Recursos Útiles para Terminal y Bash

Este documento recopila herramientas, atajos, trucos de diseño visual y una guía rápida de Git que complementarán tu aprendizaje durante y después de completar el curso de 15 días.

---

## 🎨 1. Estilos y Colores en la Terminal (Códigos ANSI)

Darle formato visual a las salidas de tus scripts facilita enormemente la lectura de registros y la interacción del usuario. En Bash, esto se logra mediante códigos de escape ANSI.

### Variables de Formato Básicas:
Puedes declarar estas variables al principio de tus scripts para reutilizarlas de forma sencilla:

```bash
# Estilos
BOLD='\033[1m'
UNDERLINE='\033[4m'
RESET='\033[0m' # Restablece todos los estilos y colores

# Colores de Texto (Primer Plano)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'

# Colores de Fondo
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
```

### Ejemplo de Uso en un Script:
> [!NOTE]
> Para que Bash procese correctamente los códigos de escape (como `\033` o `\e`), debes pasar la bandera `-e` al comando `echo`.

```bash
#!/usr/bin/env bash

# Cargar estilos
BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

echo -e "${GREEN}${BOLD}[ÉXITO]${RESET} El respaldo se ha completado correctamente."
echo -e "${RED}${BOLD}[ERROR]${RESET} No se pudo acceder al directorio destino."
```

---

## ⌨️ 2. Atajos de Teclado Imprescindibles en Bash

Memorizar estos atajos acelerará tu velocidad de trabajo en la consola un 200%:

| Atajo | Acción |
| :---: | :--- |
| `Ctrl + A` | Mueve el cursor al **inicio** de la línea actual. |
| `Ctrl + E` | Mueve el cursor al **final** de la línea actual. |
| `Ctrl + U` | **Borra todo** desde el cursor hacia el inicio de la línea. |
| `Ctrl + K` | **Borra todo** desde el cursor hacia el final de la línea. |
| `Ctrl + W` | Borra la **palabra anterior** al cursor. |
| `Ctrl + L` | **Limpia la pantalla** (equivalente al comando `clear`). |
| `Ctrl + R` | Abre la **búsqueda inversa en el historial** (escribe para buscar comandos pasados). |
| `Ctrl + C` | Cancela/mata el comando en ejecución actual. |
| `Ctrl + Z` | Pausa el comando actual y lo envía a segundo plano (*background*). |

---

## 🛠️ 3. Comandos Útiles del Día a Día

### Creación de Alias (Atajos para comandos largos)
Si usas un comando muy largo con frecuencia, puedes crear un alias temporal o guardarlo en tu configuración permanente (`~/.bashrc` o `~/.bash_profile`):

```bash
# Crear un alias temporal
alias ll='ls -lah'
alias gs='git status'
alias dusage='du -sh * | sort -h'

# Para hacerlo permanente, añade esas líneas al final de tu archivo ~/.bashrc
# y luego recárgalo con: source ~/.bashrc
```

### Filtrado Histórico con `history`
El comando `history` muestra la lista de comandos que has ejecutado en el pasado. Combínalo con `grep` para encontrar comandos específicos:
```bash
history | grep "docker run"
```

### Ejecutar con `xargs` (Procesamiento por tuberías)
`xargs` toma la salida de un comando y la pasa como argumentos individuales a otro comando. Es útil cuando el comando receptor no admite tuberías directas.
```bash
# Buscar todos los archivos temporales y eliminarlos usando rm
find . -name "*.tmp" | xargs rm
```

---

## 🐙 4. Referencia Rápida de Git y GitHub

Git es el sistema de control de versiones líder de la industria y se maneja principalmente a través de comandos de Bash. Aquí tienes el flujo esencial para publicar tu trabajo en GitHub.

### Configuración Inicial:
```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tuemail@ejemplo.com"
```

### Flujo de Trabajo Básico de Confirmación:
```bash
# 1. Inicializar un repositorio local en la carpeta actual
git init

# 2. Comprobar qué archivos han cambiado
git status

# 3. Preparar todos los cambios para la confirmación (Staging Area)
git add .

# 4. Crear una confirmación con un mensaje descriptivo
git commit -m "feat: añade guías del bloque de fundamentos"
```

### Trabajar con Repositorios Remotos (GitHub):
```bash
# 1. Vincular tu carpeta local con un repositorio vacío en GitHub
git remote add origin https://github.com/tu-usuario/nombre-repo.git

# 2. Renombrar la rama principal por defecto a 'main'
git branch -M main

# 3. Subir tus cambios locales a GitHub (la primera vez)
git push -u origin main

# 4. Descargar y combinar cambios nuevos hechos por otros colaboradores en GitHub
git pull origin main
```

### Ramas y Experimentación Segura:
```bash
# Crear una nueva rama para desarrollar una característica sin romper main
git checkout -b feature/nueva-guia

# Listar todas las ramas locales (la activa se resalta con un asterisco)
git branch

# Volver a la rama main
git checkout main

# Fusionar los cambios desarrollados en la rama feature a la rama main
git merge feature/nueva-guia
```

---

## 🔗 5. Sitios Web Recomendados

*   **[ShellCheck](https://www.shellcheck.net/)**: Validador estático de scripts. Pega tu código y te dirá qué errores de robustez o seguridad tiene.
*   **[Explainshell](https://explainshell.com/)**: Escribe cualquier comando largo y complejo y la web desglosará visualmente qué hace cada bandera u opción.
*   **[Devhints Bash Cheatsheet](https://devhints.io/bash)**: Una chuleta rápida de referencia de sintaxis de variables, arrays, condicionales y comparaciones.
