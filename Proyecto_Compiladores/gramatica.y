%{
int yystopparser=0;
%}

%token VOID MAIN ID ENTERO FLOTANTE DOBLEPRECISION CADENA BOOLEANO INTEGER FLOAT DOUBLE CHAR BOOLEAN ASIGNADOR SUMA RESTA MULTIPLICACION DIVISION INCREMENTO DECREMENTO MAYOR MENOR IGUAL MAYORIGUAL MENORIGUAL DISTINTO IF ELSE FOR WHILE SWITCH CASE BREAK DEFAULT

%start programa //Con esta linea especificamos el simbolo inicial de la gramática, con el cual el programa comienza.

%%
//Por convención, se utilizan dos tabs despues del caracter ':', además el caracter ';' va solo en una linea.
//Mayusculas para simbolos terminales, minusculas para simbolos no terminales
//Fuente: http://www.lcc.uma.es/~galvez/ftp/tci/TutorialLex.pdf

programa:		principal funciones | principal
			;
principal:		VOID MAIN '(' VOID ')' '{' lineas_de_codigo '}'
			;
//Instrucciones
lineas_de_codigo:		linea_de_codigo |
			;
linea_de_codigo:		linea_de_codigo linea | linea
			;
linea:		invocar_metodo ';' | crear_variable ';' | cambiar_valor ';' | ciclo_condicion
			;
//Metodos
invocar_metodo:		ID '(' parametros ')'
			;
parametros:		parametro |
			;
parametro:		parametro ',' valores | valores
			;
//Variables
valores:		constante | ID
			;
constante:		ENTERO | FLOTANTE | DOBLEPRECISION | CADENA | BOOLEANO
			;
crear_variable:		tipo_de_dato ID | tipo_de_dato ID asignar_valor
			;
tipo_de_dato:		INTEGER | FLOAT | DOUBLE | CHAR | BOOLEAN
			;
//Operaciones
asignar_valor:		ASIGNADOR asignacion | ASIGNADOR constante | ASIGNADOR ID
			;
asignacion:		aritmetico | invocar_metodo | inc_dec_variable
			;
aritmetico:		operacion_comun | operacion_comun operacion_adicional
			;
operacion_comun:		constante operador constante | constante operador ID | ID operador constante | ID operador ID
			;
operador:		SUMA | RESTA | MULTIPLICACION | DIVISION
			;
operacion_adicional:		operacion_adicional operacion_agregada | operacion_agregada
			;
operacion_agregada:		operador constante | operador ID
			;
inc_dec_variable:		ID INCREMENTO | ID DECREMENTO
			;
cambiar_valor:		ID ASIGNADOR valor
			;
valor:		constante | asignacion | ID
			;
logica:		MAYOR | MENOR | IGUAL | MAYORIGUAL | MENORIGUAL | DISTINTO
			;
//Ciclos y condicionales
ciclo_condicion:		condicional_if | ciclo_for | ciclo_while | condicional_switch
			;
condicion:		constante logica constante | constante logica ID | ID logica constante | ID logica ID
			;
//IF
condicional_if:		condicion_si | condicion_si condicion_no | condicion_si if_anidados condicion_si
			;
condicion_si:		IF '(' condicion ')' '{' lineas_de_codigo '}'
			;
condicion_no:		ELSE '{' lineas_de_codigo '}'
			;
if_anidados:		if_anidados si_no | si_no
			;
si_no:		ELSE IF '(' condicion ')' '{' lineas_de_codigo '}'
			;
//FOR
ciclo_for:		FOR '(' inicio_for ';' condicion ';' inc_dec_variable ')' '{' lineas_de_codigo '}'
			;
inicio_for:		tipo_de_dato ID asignar_valor | ID asignar_valor
			;
//WHILE
ciclo_while:		WHILE '(' condicion ')' '{' lineas_de_codigo '}'
			;
//SWITCH
condicional_switch:		SWITCH '(' ID ')' '{' lineas_case caso_default '}'
			;
lineas_case:		lineas_case case | case
			;
case:		CASE constante ':' lineas_de_codigo BREAK ';'
			;
caso_default:		DEFAULT ':' lineas_de_codigo BREAK ';'
			;
//Declaracion/definicion de funciones
funciones:		funciones funcion | funcion
			;
funcion:		tipo_de_retorno ID '(' parametros_entrada ')' '{' lineas_de_codigo '}'
			;
tipo_de_retorno:		tipo_de_dato | VOID
			;
parametros_entrada:		parametros_def |
			;
parametros_def:		parametros_def ',' tipo_de_dato ID | tipo_de_dato ID
			;








