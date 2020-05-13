%{
#include<stdio.h>
//declaraciones de funciones
FILE *table,*error;
int i=1;
int j=1;

%}
char[^"]
%x comentario
%x cadena
%option yylineno
%option noyywrap
%%

"/*" {BEGIN(comentario);}//si reconoce el inicio de un comentario de varias líneas, inicia la condición de arranque
<comentario>[^/*\n] //Lee cualquier secuencia de caracteres que no contenga un nuevo inicio de comentario o salto de linea
<comentario>\n //cuando aparece un salto de linea, se deben seguir contando las siguientes por que son parte del comentario
<comentario>"*/" {BEGIN(INITIAL);}//Salimos del estado de arranque y volvemos a leer las lineas tomando en cuenta las otras ER
(\/\/.*) 
\"[^\0\n\"] {fprintf(table,"%s",yytext);BEGIN(cadena);}
<cadena>[^"\n] {fprintf(table,"%s",yytext);}
<cadena>\n|\0 {BEGIN(INITIAL);}
<cadena>\" {fprintf(table,"%s*Cadena encontrada\n",yytext);BEGIN(INITIAL);}
\"\" {fprintf(table,"%s*Cadena encontrada\n",yytext);}


%%

void main(int argc, char *argv[]){
	table=fopen("Tabla.txt","w");
	error=fopen("Errores.txt","w");
	if (argc>1)
	yyin=fopen(argv[1],"r");
	else {
		printf("No se pudo abrir el archivo");
		exit(0);
	}
	yylex();
	fclose(table);
	fclose(error);
}
