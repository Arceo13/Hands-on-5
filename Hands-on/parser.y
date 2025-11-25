%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;

void yyerror(const char *s);
%}

%union {
    int num;
    float fnum;
    char *str;
}

%token INT RETURN VOID INCLUDE DEFINE CHAR FLOAT_TYPE DOUBLE
%token IDENTIFIER INTEGER FLOAT_NUM
%token PLUS MINUS TIMES DIVIDE ASSIGN INCREMENT
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON COMMA HASH
%token COMMENT UNKNOWN

%%

program: 
    global_declarations
    ;

global_declarations:
    global_declarations global_declaration
    | global_declaration
    ;

global_declaration:
    function_definition
    | variable_declaration
    | preprocessor_directive
    ;

preprocessor_directive:
    HASH INCLUDE STRING
    | HASH DEFINE IDENTIFIER INTEGER
    ;

variable_declaration:
    type IDENTIFIER SEMICOLON
    | type IDENTIFIER ASSIGN expression SEMICOLON
    ;

type:
    INT
    | FLOAT_TYPE
    | CHAR
    | VOID
    ;

function_definition:
    type IDENTIFIER LPAREN parameters RPAREN compound_statement
    ;

parameters:
    parameter_list
    | VOID
    | /* vacío */
    ;

parameter_list:
    parameter_list COMMA parameter
    | parameter
    ;

parameter:
    type IDENTIFIER
    ;

compound_statement:
    LBRACE statements RBRACE
    ;

statements:
    statements statement
    | /* vacío */
    ;

statement:
    variable_declaration
    | assignment SEMICOLON
    | expression SEMICOLON
    | RETURN expression SEMICOLON
    | compound_statement
    ;

assignment:
    IDENTIFIER ASSIGN expression
    ;

expression:
    expression PLUS term
    | expression MINUS term
    | term
    ;

term:
    term TIMES factor
    | term DIVIDE factor
    | factor
    ;

factor:
    INTEGER
    | FLOAT_NUM
    | IDENTIFIER
    | IDENTIFIER LPAREN arguments RPAREN
    | LPAREN expression RPAREN
    ;

arguments:
    argument_list
    | /* vacío */
    ;

argument_list:
    argument_list COMMA expression
    | expression
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error sintáctico: %s\n", s);
}

int main(int argc, char *argv[]) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("Error al abrir el archivo");
            return 1;
        }
    }
    
    printf("Analizando sintácticamente...\n");
    if (yyparse() == 0) {
        printf("Análisis sintáctico COMPLETADO - No se encontraron errores\n");
    } else {
        printf("Análisis sintáctico FALLIDO - Se encontraron errores\n");
    }
    
    return 0;
}