/* A Bison parser, made by GNU Bison 2.4.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006,
   2009, 2010 Free Software Foundation, Inc.
   
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


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     INT = 258,
     DOUBLE = 259,
     NAME = 260,
     STRING = 261,
     SYSCMD = 262,
     ENDCMD = 263,
     MODEL = 264,
     DATA = 265,
     IN = 266,
     TO = 267,
     INITS = 268,
     PARAMETERS = 269,
     COMPILE = 270,
     INITIALIZE = 271,
     ADAPT = 272,
     UPDATE = 273,
     BY = 274,
     MONITORS = 275,
     MONITOR = 276,
     TYPE = 277,
     SET = 278,
     CLEAR = 279,
     THIN = 280,
     CODA = 281,
     STEM = 282,
     EXIT = 283,
     NCHAINS = 284,
     CHAIN = 285,
     LOAD = 286,
     UNLOAD = 287,
     SAMPLER = 288,
     SAMPLERS = 289,
     RNGTOK = 290,
     FACTORY = 291,
     FACTORIES = 292,
     LIST = 293,
     STRUCTURE = 294,
     DIM = 295,
     NA = 296,
     R_NULL = 297,
     DIMNAMES = 298,
     ITER = 299,
     ARROW = 300,
     ENDDATA = 301,
     ASINTEGER = 302,
     DIRECTORY = 303,
     CD = 304,
     PWD = 305,
     RUN = 306,
     ENDSCRIPT = 307
   };
#endif
/* Tokens.  */
#define INT 258
#define DOUBLE 259
#define NAME 260
#define STRING 261
#define SYSCMD 262
#define ENDCMD 263
#define MODEL 264
#define DATA 265
#define IN 266
#define TO 267
#define INITS 268
#define PARAMETERS 269
#define COMPILE 270
#define INITIALIZE 271
#define ADAPT 272
#define UPDATE 273
#define BY 274
#define MONITORS 275
#define MONITOR 276
#define TYPE 277
#define SET 278
#define CLEAR 279
#define THIN 280
#define CODA 281
#define STEM 282
#define EXIT 283
#define NCHAINS 284
#define CHAIN 285
#define LOAD 286
#define UNLOAD 287
#define SAMPLER 288
#define SAMPLERS 289
#define RNGTOK 290
#define FACTORY 291
#define FACTORIES 292
#define LIST 293
#define STRUCTURE 294
#define DIM 295
#define NA 296
#define R_NULL 297
#define DIMNAMES 298
#define ITER 299
#define ARROW 300
#define ENDDATA 301
#define ASINTEGER 302
#define DIRECTORY 303
#define CD 304
#define PWD 305
#define RUN 306
#define ENDSCRIPT 307




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1685 of yacc.c  */
#line 91 "parser.yy"

  int intval;
  double val;
  std::string *stringptr;
  ParseTree *ptree;
  std::vector<ParseTree*> *pvec;
  std::vector<double> *vec;
  std::vector<long> *ivec;



/* Line 1685 of yacc.c  */
#line 167 "parser.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE zzlval;


