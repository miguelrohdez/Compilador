%{

#include <stdio.h>
#include "analizador_lexico.h"

%}

%option noyywrap

/*Contador de lineas*/
%option yylineno

/*Condicion de arranque para comentarios*/
%x comentario

/*Condicion de arranque para cadenas*/
%x cadena

/*Declaramos un "nombre" que incluya espacios en blanco, tabuladores y saltos de linea para que sean ignorados.*/
Ignorar " "|\t|\n

/*Nombre para caracteres*/
Letra [a-zA-Z]

/*Nombre para digitos*/
Digito [0-9]

/*Nombre para booleanos*/
Booleano "true"|"false"

/*Nombres para numeros*/

dec[1-9]
exdec[89]
real[0-9]
signo[+\-]

%%

"/*" {BEGIN(comentario);}//si reconoce el inicio de un comentario de varias líneas, inicia la condición de arranque
<comentario>[^/*\n] //Lee cualquier secuencia de caracteres que no contenga un nuevo inicio de comentario o salto de linea
<comentario>\n //cuando aparece un salto de linea, se deben seguir contando las siguientes por que son parte del comentario
<comentario>"*/" {BEGIN(INITIAL);}//Salimos del estado de arranque y volvemos a leer las lineas tomando en cuenta las otras ER

"//".*			{;}//Ignoramos comentarios de una linea

{Ignorar}*		{;}//No hacemos absolutamente nada cuando encontramos los caracteres a ignorar


"{"		{return('{');}//Expresiones para simbolos explicitos
"}"		{return('}');}
":"		{return(':');}
";"		{return(';');}
","		{return(',');}
"("		{return('(');}
")"		{return(')');}


"void"		{return VOID;}//Expresiones regulares para palabras reservadas.
"main"		{return MAIN;}
"int"		{return INTEGER;}
"float"		{return FLOAT;}
"double"	{return DOUBLE;}
"char"		{return CHAR;}
"bool"		{return BOOLEAN;}
"if"		{return IF;}
"else"		{return ELSE;}
"for"		{return FOR;}
"while"		{return WHILE;}
"switch"	{return SWITCH;}
"case"		{return CASE;}
"break"		{return BREAK;}
"default"	{return DEFAULT;}


"+"			{return SUMA;}//Expresiones regulares para operadores.
"-"			{return RESTA;}
"*"			{return MULTIPLICACION;}
"/"			{return DIVISION;}
"++"		{return INCREMENTO;}
"--"		{return DECREMENTO;}
"="			{return ASIGNADOR;}
">"			{return MAYOR;}
"<"			{return MENOR;}
"=="		{return IGUAL;}
">="		{return MAYORIGUAL;}
"<="		{return MENORIGUAL;}
"!="		{return DISTINTO;}


{signo}?(0+{exdec}*|00+{dec}+|{dec}*)				{return ENTERO;}//Expresiones regulares para numeros
{signo}?({real}+\.{real}+|\.{real}+|{real}\.)'f'	{return FLOTANTE;}
{signo}?({real}+\.{real}+|\.{real}+|{real}\.)		{return DOBLEPRECISION;}

{Booleano}		{return BOOLEANO;}//Expresion regular para valores booleanos.

\"[^\0\n\"] {;BEGIN(cadena);}//Condición de arranque para cadenas con contenido
<cadena>[^"\n] {;}
<cadena>\n|\0 {BEGIN(INITIAL);}
<cadena>\" {return CADENA;BEGIN(INITIAL);}

\"\" {return CADENA;}//Expresión regular para cadenas vacias o sin contenido


(_?{Letra}+|_{Digito}*)({Digito}*{Letra}*_*)* {return ID;}//Expresión regular para un identificador

.			{printf("Error en linea: %d\n",yylineno);}//Cualquier error

%%

yyerror(char *msg){
	printf("%s, line %d\n",msg, yylineno);
}


void main(int argc, char *argv[]){
	
	FILE *table;
	FILE *error;	
	table=fopen("Tabla.txt","w");
	error=fopen("Errores.txt","w");
	if (argc>1)
	yyin=fopen(argv[1],"r");
	else {
		printf("No se pudo abrir el archivo");
		exit(0);
	}
	if(!yyparse()){
		printf("Compilado con exito\n");
	}

	fclose(table);
	fclose(error);
}
