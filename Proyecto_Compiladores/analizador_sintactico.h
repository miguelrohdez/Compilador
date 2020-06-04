/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_ANALIZADOR_SINTACTICO_H_INCLUDED
# define YY_YY_ANALIZADOR_SINTACTICO_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    VOID = 258,
    MAIN = 259,
    ID = 260,
    ENTERO = 261,
    FLOTANTE = 262,
    DOBLEPRECISION = 263,
    CADENA = 264,
    BOOLEANO = 265,
    INTEGER = 266,
    FLOAT = 267,
    DOUBLE = 268,
    CHAR = 269,
    BOOLEAN = 270,
    ASIGNADOR = 271,
    SUMA = 272,
    RESTA = 273,
    MULTIPLICACION = 274,
    DIVISION = 275,
    INCREMENTO = 276,
    DECREMENTO = 277,
    MAYOR = 278,
    MENOR = 279,
    IGUAL = 280,
    MAYORIGUAL = 281,
    MENORIGUAL = 282,
    DISTINTO = 283,
    IF = 284,
    ELSE = 285,
    FOR = 286,
    WHILE = 287,
    SWITCH = 288,
    CASE = 289,
    BREAK = 290,
    DEFAULT = 291,
    OR = 292,
    AND = 293
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_ANALIZADOR_SINTACTICO_H_INCLUDED  */
