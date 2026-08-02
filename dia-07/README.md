<h3 align="center">
<a href="../dia-06/README.md">Día 6</a> | <a href="../README.md"> Inicio del Curso </a> | <a href="../dia-08/README.md">Día 8</a>
</h3>

![Titulo](../assets/cursobash.png)

# 📅 Día 7: Aritmética y Comparaciones

Hoy aprenderemos cómo hacer que nuestros scripts realicen operaciones matemáticas y cómo evaluar condiciones sobre números, cadenas de texto (strings) y archivos del sistema. Estos conceptos son los bloques de construcción para la toma de decisiones lógica que veremos mañana.

---

## 📘 Conceptos Clave

### Aritmética en Bash: `$(( expresión ))`

Bash es principalmente un lenguaje de scripting para el sistema y no está diseñado para matemáticas complejas. De forma nativa, **solo soporta aritmética con números enteros**.
La forma estándar y moderna de realizar cálculos es usando la sintaxis `$(( ... ))`:

```bash
a=10
b=3
resultado=$((a + b)) # 13
modulo=$((a % b))    # 1 (el resto de la división)
```

Para realizar operaciones con decimales (punto flotante), debemos delegar el trabajo a una herramienta externa llamada `bc` (Basic Calculator):

```bash
# Calcular división con dos decimales
division_decimal=$(echo "scale=2; 5 / 2" | bc) # 2.50
```

---

### La Sintaxis de Comparación: `[[ ... ]]`

Para evaluar condiciones, tradicionalmente se usa el comando `test` o los corchetes simples `[ ]`. Sin embargo, en scripts modernos de Bash se recomienda usar los **corchetes dobles `[[ ... ]]`** por ser más seguro, evitar errores con variables vacías y permitir operadores lógicos avanzados de forma nativa.

---

## 🛠️ Operadores de Comparación

### 1. Comparación de Números (Enteros)

| Operador | Significado                         | Ejemplo           |
| :------: | :---------------------------------- | :---------------- |
|  `-eq`   | Igual que (_Equal_)                 | `[[ $a -eq $b ]]` |
|  `-ne`   | Diferente de (_Not Equal_)          | `[[ $a -ne $b ]]` |
|  `-gt`   | Mayor que (_Greater Than_)          | `[[ $a -gt $b ]]` |
|  `-ge`   | Mayor o igual que (_Greater/Equal_) | `[[ $a -ge $b ]]` |
|  `-lt`   | Menor que (_Less Than_)             | `[[ $a -lt $b ]]` |
|  `-le`   | Menor o igual que (_Less/Equal_)    | `[[ $a -le $b ]]` |

---

### 2. Comparación de Cadenas de Texto (Strings)

| Operador | Significado                          | Ejemplo                |
| :------: | :----------------------------------- | :--------------------- |
|   `==`   | Es igual a                           | `[[ $str1 == $str2 ]]` |
|   `!=`   | Es diferente de                      | `[[ $str1 != $str2 ]]` |
|   `-z`   | La cadena está vacía (longitud cero) | `[[ -z $str1 ]]`       |
|   `-n`   | La cadena NO está vacía              | `[[ -n $str1 ]]`       |

---

### 3. Comprobación de Archivos y Directorios

| Operador | Significado                                | Ejemplo                |
| :------: | :----------------------------------------- | :--------------------- |
|   `-e`   | El archivo o carpeta existe                | `[[ -e /etc/passwd ]]` |
|   `-f`   | Existe y es un archivo regular             | `[[ -f /etc/passwd ]]` |
|   `-d`   | Existe y es un directorio                  | `[[ -d /var/log ]]`    |
|   `-r`   | El archivo es legible (permiso de lectura) | `[[ -r notas.txt ]]`   |
|   `-w`   | El archivo es escribible                   | `[[ -w notas.txt ]]`   |
|   `-x`   | El archivo es ejecutable                   | `[[ -x script.sh ]]`   |

---

## 🔍 Operadores Lógicos

Puedes combinar múltiples comparaciones dentro de `[[ ... ]]` usando:

- `&&`: Operador AND (ambas condiciones deben ser verdaderas).
- `||`: Operador OR (al menos una condición debe ser verdadera).
- `!`: Operador NOT (invierte el resultado de la condición).

```bash
# Comprobar si un archivo existe Y además es escribible
[[ -f notas.txt && -w notas.txt ]]
```

---

## 💻 Ejercicios Prácticos

### Nivel Fácil

1. Crea un script llamado `calculadora_basica.sh`. Declara dos variables con los números 15 y 4.
2. Haz que el script calcule e imprima la suma, resta, multiplicación y división entera de estos números.
3. Agrega una línea que calcule la división exacta con decimales usando `bc` con una precisión de 3 decimales.

### Nivel Medio

1. Crea un script llamado `test_archivo.sh`.
2. El script debe comprobar si existe un archivo llamado `config.cfg` en el directorio actual.
3. Para simular la comprobación, escribe en el script comandos `[[ ... ]]` combinados con `&&` e `||` de la siguiente forma:
   `[[ condicion ]] && echo "Verdadero" || echo "Falso"`.
4. Añade otra comprobación para evaluar si el directorio `/var/log` existe y es accesible (es decir, si es un directorio).

### Nivel Difícil

1. Escribe un script llamado `compara_usuario.sh` que compruebe si el usuario actual ejecutando el script (`$USER`) es el usuario administrador `root` y si el archivo `/etc/shadow` es legible para él.
2. Si se cumplen ambas condiciones, debe imprimir "Acceso de administrador verificado", de lo contrario debe imprimir "Permisos insuficientes".
3. Escribe un comando de una sola línea que evalúe si una variable llamada `TEXTO` está vacía. Si está vacía debe asignar el valor por defecto `"Sin datos"`, y luego imprimir el valor de la variable.

<h3 align="center">
<a href="../dia-06/README.md">Día 6</a> | <a href="../README.md"> Inicio del Curso </a> | <a href="../dia-08/README.md">Día 8</a>
</h3>

---

<details>
<summary>💡 Ver Soluciones Sugeridas</summary>

### Nivel Fácil

1. El script `calculadora_basica.sh`:

   ```bash
   #!/bin/bash
   num1=15
   num2=4

   echo "Suma: $((num1 + num2))"
   echo "Resta: $((num1 - num2))"
   echo "Multiplicación: $((num1 * num2))"
   echo "División Entera: $((num1 / num2))"

   # Con decimales usando bc
   div_decimal=$(echo "scale=3; $num1 / $num2" | bc)
   echo "División Decimal: $div_decimal"
   ```

### Nivel Medio

1. El script `test_archivo.sh`:

   ```bash
   #!/bin/bash
   # Comprobar si config.cfg existe como archivo normal
   [[ -f config.cfg ]] && echo "El archivo config.cfg existe" || echo "El archivo config.cfg NO existe"

   # Comprobar si /var/log es un directorio
   [[ -d /var/log ]] && echo "/var/log es un directorio válido" || echo "/var/log no existe o no es un directorio"
   ```

### Nivel Difícil

1. El script `compara_usuario.sh`:
   ```bash
   #!/bin/bash
   # Comprobar si es root Y si /etc/shadow es legible
   [[ "$USER" == "root" && -r /etc/shadow ]] && echo "Acceso de administrador verificado" || echo "Permisos insuficientes"
   ```
2. Comando en una sola línea para inicializar variable si está vacía:
   `[[ -z "$TEXTO" ]] && TEXTO="Sin datos"; echo "$TEXTO"`
   _(Nota: en Bash existe una forma nativa más corta para esto llamada expansión de parámetros: `echo "${TEXTO:-Sin datos}"`)_.

</details>
