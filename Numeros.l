%{
#include<stdio.h>
//declaraciones de funciones
FILE *table,*error;
int i=1;
int j=1;
%}

dec[1-9]
exdec[89]
real[0-9]
oct[1-7]
hex[0-9A-Fa-f]
signo[+\-]

%option yylineno
%option noyywrap
%%

{signo}?(0+{exdec}*|00+{dec}+|{dec}*) {fprintf(table,"%d. %s*Entero\n", i++,yytext);}
{signo}?({real}+\.{real}+|\.{real}+|{real}\.) {fprintf(table,"%d. %s*Real\n", i++,yytext);}
{signo}?0{oct}+ {fprintf(table,"%d. %s*Octal\n", i++,yytext);}
{signo}?0(x|X){hex}+ {fprintf(table,"%d. %s*Hexadecimal\n", i++,yytext);}


.* {fprintf(error,"%d. %s\n", j++,yytext);}

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
