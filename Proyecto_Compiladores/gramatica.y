%{
int yystopparser=0;
%}
/*Se definen los tokens o simbolos terminales*/
%token VOID MAIN ID ENTERO FLOTANTE DOBLEPRECISION CADENA BOOLEANO INTEGER FLOAT DOUBLE CHAR BOOLEAN ASIGNADOR SUMA RESTA MULTIPLICACION DIVISION INCREMENTO DECREMENTO MAYOR MENOR IGUAL MAYORIGUAL MENORIGUAL DISTINTO IF ELSE FOR WHILE SWITCH CASE BREAK DEFAULT OR AND '(' ')'
/*Se define el simbolo inicial de la gramática*/
%start programa
%%
/*Por convención, se dejaron 2 tabuladores despues de definir el lado derecho de la producción*/
/*Por convención los simbolos terminales estaran definidos en mayusculas, a excepción del token error*/
/*En cada una de las producciones en las que se encontraban simbolos delimitadores, se agregó el token error para continuar el analisis sintactico*/
/*Se determino agregar el token error en dichas producciones para evitar conflictos desplazamiento-reducción */
/*Además se garantiza contar con un token de sincronización*/
/*Por especificación, no se emiten mensajes de error hasta leer 3 tokens con exito, para evitar esto se utilizó la macro yyerrok*/

programa:		principal funciones | principal
			;
principal:		VOID ID '(' VOID ')' '{' lineas_de_codigo '}' | VOID ID '(' error ')' '{' lineas_de_codigo '}' {yyerror("Se esperaba par\160metro 'void' en funci\162n main");}
			;
lineas_de_codigo:		linea_de_codigo |;
linea_de_codigo:		linea_de_codigo linea | linea
			;
linea:		invocar_metodo ';' | crear_variable ';' | cambiar_valor ';' | ciclo_condicion
			;
invocar_metodo:		ID '(' parametros ')' | ID '(' error ')' {yyerror("Par\160metro no v\160lido al invocar m\130todo");}
			;
parametros:		parametro |;
parametro:		parametro ',' constante | parametro ',' ID | ID | constante
			;
constante:		ENTERO | FLOTANTE | DOBLEPRECISION | CADENA | BOOLEANO
			;
identificador_multiple:		identificador_multiple ',' ID | ID
			;
crear_variable:		tipo_de_dato identificador_multiple | tipo_de_dato ID asignar_valor
			;
tipo_de_dato:		INTEGER | FLOAT | DOUBLE | CHAR | BOOLEAN
			;
asignar_valor:		ASIGNADOR asignacion | ASIGNADOR constante | ASIGNADOR ID
			;
asignacion:		aritmetico | invocar_metodo | inc_dec_variable
			;
aritmetico:		operacion_comun operacion_adicional | operacion_comun | constante_con_signo
			;
operacion_comun:		constante operador constante | constante operador ID | ID operador constante | ID operador ID
			;
constante_con_signo:		SUMA constante | RESTA constante
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
ciclo_condicion:		condicional_if | ciclo_for | ciclo_while | condicional_switch
			;
condiciones:		condiciones OR condicion | condiciones AND condicion | condicion
			;
condicion:		constante logica constante | constante logica ID | ID logica constante | ID logica ID
			;
condicional_if:		condicion_si | condicion_si condicion_no | condicion_si if_anidados condicion_no
			;
condicion_si:		IF '(' condiciones ')' | IF '(' condiciones ')' '{' lineas_de_codigo '}' | IF '(' error ')' '{' lineas_de_codigo '}' {yyerror("Condici\162n no v\160lida en sentencia if");}
			;
condicion_no:		ELSE '{' lineas_de_codigo '}'
			;
if_anidados:		if_anidados si_no | si_no
			;
si_no:		ELSE IF '(' condiciones ')' '{' lineas_de_codigo '}' | ELSE IF '(' error ')' '{' lineas_de_codigo '}' {yyerror("Condici\162n no v\160lida en sentencia if");}
			;
ciclo_for:		FOR '(' inicio_for ';' condicion ';' inc_dec_variable ')' '{' lineas_de_codigo '}' | FOR '(' error ';' condicion ';' inc_dec_variable ')' '{' lineas_de_codigo '}' {yyerror("Error con variable de inicio, verificar declaraci\162n");} | FOR '(' inicio_for ';' error ';' inc_dec_variable ')' '{' lineas_de_codigo '}' {yyerror("Condici\162n no v\160lida");} | FOR '(' inicio_for ';' condicion ';' error ')' '{' lineas_de_codigo '}' {yyerror("Error al definir el incremento, favor de verificar");}
			;
inicio_for:		tipo_de_dato ID asignar_valor | ID asignar_valor
			;
ciclo_while:		WHILE '(' condiciones ')' '{' lineas_de_codigo '}' | WHILE '(' error ')' '{' lineas_de_codigo '}' {yyerror("Condici\162n no v\160lida en sentencia while");}
			;
condicional_switch:		SWITCH '(' ID ')' '{' lineas_case caso_default '}' | SWITCH '(' error ')' '{' lineas_case caso_default '}' {yyerror("Condici\162n de entrada no v\160lida en sentencia switch");}
			;
lineas_case:		lineas_case case | case
			;
case:		CASE constante ':' lineas_de_codigo BREAK ';'
			;
caso_default:		DEFAULT ':' lineas_de_codigo BREAK ';'
			;
funciones:		funciones funcion | funcion
			;
funcion:		tipo_de_retorno ID '(' parametros_entrada ')' '{' lineas_de_codigo '}' | tipo_de_retorno ID '(' error ')' '{' lineas_de_codigo '}' {yyerror("Error al definir los par\160metros de la funci\162n");}
			;
tipo_de_retorno:		tipo_de_dato | VOID
			;
parametros_entrada:		parametros_def |;
parametros_def:		parametros_def ',' tipo_de_dato ID | tipo_de_dato ID
			;