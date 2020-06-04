%{

#include <stdio.h>
#include <stdlib.h>
#include "analizador_sintactico.h"

FILE *table=NULL;
FILE *error=NULL;
FILE *code=NULL;


%}

%option noyywrap

/*Contador de lineas*/
%option yylineno

/*Condicion de arranque para comentarios*/
%x comentario

/*Declaramos un "nombre" que incluya espacios en blanco, tabuladores y saltos de linea para que sean ignorados.*/
Ignorar " "|\t|\n

/*Nombre para caracteres*/
Letra [a-zA-Z]

/*Nombre para digitos*/
Digito [0-9]

/*Nombre para simbolos*/
Simbolo [\!\#-\@\[-\~\128-\255]

/*Nombre para booleanos*/
Booleano "true"|"false"

/*Nombres para numeros*/

dig[0-9]

%%

"/*" {BEGIN(comentario);}//si reconoce el inicio de un comentario de varias líneas, inicia la condición de arranque
<comentario>[^/*\n] //Lee cualquier secuencia de caracteres que no contenga un nuevo inicio de comentario o salto de linea
<comentario>\n //cuando aparece un salto de linea, se deben seguir contando las siguientes por que son parte del comentario
<comentario>"*/" {BEGIN(INITIAL);}//Salimos del estado de arranque y volvemos a leer las lineas tomando en cuenta las otras ER

"//".*			{;}//Ignoramos comentarios de una linea

{Ignorar}*		{;}//No hacemos absolutamente nada cuando encontramos los caracteres a ignorar


"{"		{fprintf(table,"{\t\t|\t\t%i\n",'{');return('{');}//Expresiones para simbolos explicitos
"}"		{fprintf(table,"}\t\t|\t\t%i\n",'}');return('}');}
":"		{fprintf(table,":\t\t|\t\t%i\n",':');return(':');}
";"		{fprintf(table,";\t\t|\t\t%i\n",';');return(';');}
","		{fprintf(table,",\t\t|\t\t%i\n",',');return(',');}
"("		{fprintf(table,"(\t\t|\t\t%i\n",'(');return('(');}
")"		{fprintf(table,")\t\t|\t\t%i\n",')');return(')');}


"void"		{fprintf(table,"VOID\t\t|\t\t%i\n",VOID);return VOID;}//Expresiones regulares para palabras reservadas.
"int"		{fprintf(table,"INTEGER\t\t|\t\t%i\n",INTEGER);return INTEGER;}
"float"		{fprintf(table,"FLOAT\t\t|\t\t%i\n",FLOAT);return FLOAT;}
"double"	{fprintf(table,"DOUBLE\t\t|\t\t%i\n",DOUBLE);return DOUBLE;}
"char"		{fprintf(table,"CHAR\t\t|\t\t%i\n",CHAR);return CHAR;}
"bool"		{fprintf(table,"BOOLEAN\t\t|\t\t%i\n",BOOLEAN);return BOOLEAN;}
"if"		{fprintf(table,"IF\t\t|\t\t%i\n",IF);return IF;}
"else"		{fprintf(table,"ELSE\t\t|\t\t%i\n",ELSE);return ELSE;}
"for"		{fprintf(table,"FOR\t\t|\t\t%i\n",FOR);return FOR;}
"while"		{fprintf(table,"WHILE\t\t|\t\t%i\n",WHILE);return WHILE;}
"switch"	{fprintf(table,"SWITCH\t\t|\t\t%i\n",SWITCH);return SWITCH;}
"case"		{fprintf(table,"CASE\t\t|\t\t%i\n",CASE);return CASE;}
"break"		{fprintf(table,"BREAK\t\t|\t\t%i\n",BREAK);return BREAK;}
"default"	{fprintf(table,"DEFAULT\t\t|\t\t%i\n",DEFAULT);return DEFAULT;}


"+"			{fprintf(table,"SUMA\t\t|\t\t%i\n",SUMA);return SUMA;}//Expresiones regulares para operadores.
"-"			{fprintf(table,"RESTA\t\t|\t\t%i\n",RESTA);return RESTA;}
"*"			{fprintf(table,"MULTIPLICACION\t|\t\t%i\n",MULTIPLICACION);return MULTIPLICACION;}
"/"			{fprintf(table,"DIVISION\t\t|\t\t%i\n",DIVISION);return DIVISION;}
"++"		{fprintf(table,"INCREMENTO\t|\t\t%i\n",INCREMENTO);return INCREMENTO;}
"--"		{fprintf(table,"DECREMENTO\t|\t\t%i\n",DECREMENTO);return DECREMENTO;}
"="			{fprintf(table,"ASIGNADOR\t|\t\t%i\n",ASIGNADOR);return ASIGNADOR;}
">"			{fprintf(table,"MAYOR\t\t|\t\t%i\n",MAYOR);return MAYOR;}
"<"			{fprintf(table,"MENOR\t\t|\t\t%i\n",MENOR);return MENOR;}
"=="		{fprintf(table,"IGUAL\t\t|\t\t%i\n",IGUAL);return IGUAL;}
">="		{fprintf(table,"MAYORIGUAL\t|\t\t%i\n",MAYORIGUAL);return MAYORIGUAL;}
"<="		{fprintf(table,"MENORIGUAL\t|\t\t%i\n",MENORIGUAL);return MENORIGUAL;}
"!="		{fprintf(table,"DISTINTO\t|\t\t%i\n",DISTINTO);return DISTINTO;}
"||"		{fprintf(table,"OR\t\t|\t\t%i\n", OR);return OR;}
"&&"		{fprintf(table,"AND\t\t|\t\t%i\n", AND);return AND;}

({dig}+)			{fprintf(table,"ENTERO\t\t|\t\t%i\n",ENTERO);return ENTERO;}//Expresiones regulares para numeros
{dig}*\.{dig}+"f"			{fprintf(table,"FLOTANTE\t|\t\t%i\n",FLOTANTE);return FLOTANTE;}
{dig}*\.{dig}+			{fprintf(table,"DOBLEPRECISION\t|\t\t%i\n",DOBLEPRECISION);return DOBLEPRECISION;}

{Booleano}		{fprintf(table,"BOOLEANO\t\t|\t\t%i\n",BOOLEANO);return BOOLEANO;}//Expresion regular para valores booleanos.

"\""({Digito}|{Letra}|{Simbolo}|" ")*"\"" {fprintf(table,"CADENA\t\t|\t\t%i\n",CADENA);return CADENA;}

(\_?{Letra}|\_{Digito})({Digito}*{Letra}*\_*)* {fprintf(table,"ID\t\t|\t\t%i\n",ID);return ID;}//Expresión regular para un identificador

.			{fprintf(error,"%i\t|\t\tNo se reconoce simbolo '%s'\n",yylineno,yytext);}//Cualquier error

%%

//Funcion para emitir mensajes de error
//Se declararon reglas de control con producciones "hacia" el token error e indicando que se debe ejecutar yyerrok para emitir mensajes de errores continuos

yyerror(char *msg){
	fprintf(error,"%i\t|\t\t%s\n",yylineno,msg);
}

void clean_screen(){
	if(__linux__)
	    {
    		system("clear");
    	}else
    	{
	    	system("cls");
	    }
}

void main(int argc, char *argv[]){
	
  int opcion,subop;
  //Nombre del archivo de codigo
  char nombre[30];

  int aux=0;

  	menu:

  	clean_screen();

    printf("\nSelecciona la opci\162n deseada:\n\n");
    printf("1. Ejecutar.\n");
    printf("2. Ver,\n");
    printf("3. Salir.\n\n");
    printf("Opci\162n: ");
    scanf("%d",&opcion);

    //clean_screen();

    switch (opcion)
    {
      case 1:

      	table=fopen("Tabla.txt","w");
      	error=fopen("Errores.txt","w");

      	fprintf(table,"Token ID\t|\t\tToken\n\n");
      	fprintf(error,"Linea\t|\t\tDetalle\n\n");

        printf("\n¡Importante!.\nSe recomienda que el archivo est\130 dentro de la misma carpeta.\n\n");
        printf("Nombre del archivo: ");
        scanf("%s",nombre);

        if(!(yyin=fopen(nombre,"r")))
        {
          printf("\nNo se pudo abrir el archivo\n");
          exit(0);
        }
        //Validamos que no hubo ningun error al compilar
        if(!yyparse())
        {
          printf("\nCompilado con exito\n");
          printf("\nPresione cualquier tecla...\n");
          getchar();
          getchar();
          fclose(table);
          fclose(error);
          remove("Errores.txt");
        }else{
        	printf("\nError al compilar\n");
        	printf("\nPresione cualquier tecla...\n");
      		getchar();
      		getchar();
        	fclose(table);
        	fclose(error);
        	remove("Tabla.txt");
        }

        aux=0;
        break;
      
      case 2:

       	clean_screen();

      	printf("\nSelecciona el archivo que deseas ver:\n");
      	printf("\n1. Tabla de errores.\n");
      	printf("2. Tabla de simbolos.\n");
      	printf("3. Codigo fuente.\n");
      	printf("\nOpci\162n: ");
      	scanf("%d",&subop);

      	clean_screen();

      	switch(subop)
      	{
      		case 1:
      			if(!(error=fopen("Errores.txt","r"))){

      				printf("No existe el archivo\n");
      				printf("Presione cualquier tecla...\n");
      				getchar();
      				getchar();

      			} else{
      				while(aux!=EOF)
        			{
          				aux=fgetc(error);
          				printf("%c",aux);
        			}
        			fclose(error);
        			printf("\n\nPresione cualquier tecla...\n");
      				getchar();
      				getchar();
      			}
        		break;

      		case 2:

      			if(!(table=fopen("Tabla.txt","r"))){
      				printf("No existe el archivo\n");
      				printf("\nPresione cualquier tecla...\n");
      				getchar();
      				getchar();
      			} else{
      				while(aux!=EOF)
        			{
	          			aux=fgetc(table);
          				printf("%c",aux);
        			}
        			fclose(table);
        			printf("\n\nPresione cualquier tecla...\n");
      				getchar();
      				getchar();
      			}
        		break;	
        	case 3:

      			printf("Ingresa el nombre del archivo.\n");
      			printf("\nNombre: ");
      			scanf("%s",nombre);
      			printf("\n");
      			if(!(code=fopen(nombre, "r"))){
      				printf("No existe el archivo\n");
      				printf("Presione cualquier tecla...\n");
      				getchar();
      				getchar();
      			}else{
      				while(aux!=EOF)
      				{
      					aux=fgetc(code);
	      				printf("%c",aux);
      				}
      				fclose(code);
      				printf("\n\nPresione cualquier tecla...\n");
      				getchar();
      				getchar();
      			}
      			break;
      		default:
      			break;
      		}
      		aux=0;
        break;
      
      case 3:
      	clean_screen();
      	exit(0);

      default:
        printf("\nNo es una opci\162n v\160lida\n");
        break;
    }
    yylineno=0;
    goto menu;
}
