# Hands-on 5: Analizador Sintáctico

## Integrante(s)
- Ángel Manuel Ramírez Arceo

## Descripción
Analizador sintáctico que valida la estructura de programas en C usando Flex + Bison.

## Elementos que valida:
- Declaraciones globales y locales
- Declaración de funciones
- Bloques anidados { }
- Asignaciones
- Expresiones aritméticas
- Llamadas a funciones
- Directivas de preprocesador

## Producciones principales:
- program → global_declarations
- function_definition → type IDENTIFIER (parameters) compound_statement
- compound_statement → { statements }
- expression → expression + term | term
- variable_declaration → type IDENTIFIER ;

## Instrucciones de compilación y ejecución:
```bash
# Generar analizadores
bison -d parser.y
flex lexer.l

# Compilar
gcc parser.tab.c lex.yy.c -o parser -lfl

# Ejecutar
./parser input.c