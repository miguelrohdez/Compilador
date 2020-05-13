%{

//Nota duda sobre los numeros con signo pues no reconoce el operador en caso se hacer mas de dos numeros


#include <stdio.h>
int i=1;
int j=1;


%}

%option yylineno
%option noyywrap

id              [a-zA-Z_][a-zA-Z0-9_]*
entero          [+-]?[0-9]+           
doble           [+-]?[0-9]+("."[0-9]+)?([Ee][+-]?[0-9]+)?
caracter        \'(\\.|[^\\'])*\'
cadena          \"(\\.|[^\\"])*\"
espacio         [ \n\t]
%x comentario

%%
"/*" {BEGIN(comentario);}
<comentario>[^/*\n] 
<comentario>\n 
<comentario>"*/" {BEGIN(INITIAL);}
(\/\/.*)
auto 			{printf("Palabra reservada %s\n",yytext); }
break			{printf("Palabra reservada %s\n",yytext); }
case			{printf("Palabra reservada %s\n",yytext); }
char			{printf("Palabra reservada %s\n",yytext); }
const 			{printf("Palabra reservada %s\n",yytext); }
continue		{printf("Palabra reservada %s\n",yytext); }
default			{printf("Palabra reservada %s\n",yytext); }
double			{printf("Palabra reservada %s\n",yytext); }
else			{printf("Palabra reservada %s\n",yytext); }
enum			{printf("Palabra reservada %s\n",yytext); }
extern			{printf("Palabra reservada %s\n",yytext); }
float 			{printf("Palabra reservada %s\n",yytext); }
for 			{printf("Palabra reservada %s\n",yytext); }
goto			{printf("Palabra reservada %s\n",yytext); }
if 				{printf("Palabra reservada %s\n",yytext); }
int 			{printf("Palabra reservada %s\n",yytext); }
long			{printf("Palabra reservada %s\n",yytext); }
register		{printf("Palabra reservada %s\n",yytext); }
return			{printf("Palabra reservada %s\n",yytext); }
short			{printf("Palabra reservada %s\n",yytext); }
signed			{printf("Palabra reservada %s\n",yytext); }
sizeof			{printf("Palabra reservada %s\n",yytext); }
static			{printf("Palabra reservada %s\n",yytext); }
struct			{printf("Palabra reservada %s\n",yytext); }
typedef			{printf("Palabra reservada %s\n",yytext); }
union			{printf("Palabra reservada %s\n",yytext); }
unsigned		{printf("Palabra reservada %s\n",yytext); }
void			{printf("Palabra reservada %s\n",yytext); }
volatile		{printf("Palabra reservada %s\n",yytext); }
while			{printf("Palabra reservada %s\n",yytext); }
{id}			{printf("Indetificador %s\n",yytext); }
{entero}		{printf("Entero %s\n",yytext); }
{doble}		{printf("Double %s\n",yytext); }
{caracter}		{printf("Caracter %s\n",yytext); }
{cadena}		{printf("Cadena %s\n",yytext); }
";"             {  printf("CPYC\n"); }	//Caracter Punto y coma....
"{"             {  printf("CLKEY\n"); }
"}"             {  printf("CRKEY\n"); }
","             {  printf("CCOMA\n"); }
"."             {  printf("CPUNTO\n"); }
"["             {  printf("CLCOR\n"); }
"]"             {  printf("CRCOR\n"); }
"("             {  printf("CLPAR\n"); }
")"             {  printf("CRPAR\n"); }
"="             {  printf("CASIG\n"); }
":"             {  printf("CDP\n"); }
"-"             {  printf("CMEN\n"); }
"+"             {  printf("CMAS\n"); }
"*"             {  printf("CMUL\n"); }
"/"             {  printf("CDIV\n"); }
"%"             {  printf("CMOD\n"); }
"&&"            {  printf("COP_AND\n"); }
"||"            {  printf("COP_OR\n"); }
"!"             {  printf("COP_NOT\n"); }
"<"             {  printf("CLT_OP\n"); }
">"             {  printf("CGT_OP\n"); }
"<="            {  printf("CLE_OP\n"); }
">="            {  printf("CGE_OP\n"); }
"=="            {  printf("CEQ_OP\n"); }
"!="            {  printf("CNE_OP\n"); }	//Caracter no equal operador
{espacio}		{}


.               {printf("Error Lexico en la linea %d con %s\n", yylineno,yytext); }

%%



int main(int argc, char **argv)
{
	if(argc>1)
		yyin=fopen(argv[1],"r");
	else

    	printf("No se puedo abrir el archivo");

    yylex();


	return 0;
}