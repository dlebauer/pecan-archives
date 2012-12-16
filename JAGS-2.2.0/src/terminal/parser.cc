/* A Bison parser, made by GNU Bison 2.4.3.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C
   
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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.4.3"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1

/* Using locations.  */
#define YYLSP_NEEDED 0

/* Substitute the variable and function names.  */
#define yyparse         zzparse
#define yylex           zzlex
#define yyerror         zzerror
#define yylval          zzlval
#define yychar          zzchar
#define yydebug         zzdebug
#define yynerrs         zznerrs


/* Copy the first part of user declarations.  */

/* Line 189 of yacc.c  */
#line 2 "parser.yy"

#include <config.h>

#ifdef Win32
#include <windows.h>   /* For getCurrentDirectory */
#include <io.h>        /* For chdir */
#else
#include <unistd.h>    /* For getcwd, chdir */
#endif

//#include <limits.h>

#include <cstdlib>
#include <cstdio>
#include <iostream>
#include <fstream>
#include <map>
#include <algorithm>
#include <cmath>
#include <sstream>
#include <fstream>
#include <list>
#include <iterator>
#include <string>
#include <utility>

#include <dirent.h>
#include <time.h>
#include <errno.h>

#include <Console.h>
#include <Module.h>
#include <compiler/ParseTree.h>
#include <util/nainf.h>
#include <cstring>
#include <ltdl.h>

//Required for warning about masked distributions after module loading
#include <deque>
#include <distribution/Distribution.h>
#include <compiler/Compiler.h>

#include "ReadData.h"

    typedef void(*pt2Func)();

    int zzerror(const char *);
    int zzlex();
    int zzlex_destroy();
#define YYERROR_VERBOSE 0
    static Console *console;
    bool interactive;
    extern int command_buffer_count;
    void setName(ParseTree *p, std::string *name);
    std::map<std::string, SArray> _data_table;
    std::deque<lt_dlhandle> _dyn_lib;
    bool open_data_buffer(std::string const *name);
    bool open_command_buffer(std::string const *name);
    void return_to_main_buffer();
    void setMonitor(ParseTree const *var, int thin, std::string const &type);
    void clearMonitor(ParseTree const *var, std::string const &type);
    void doCoda (ParseTree const *var, std::string const &stem);
    void doAllCoda (std::string const &stem);
    void doDump (std::string const &file, DumpType type, unsigned int chain);
    void dumpMonitors(std::string const &file, std::string const &type);
    void doSystem(std::string const *command);
    std::string ExpandFileName(char const *s);

    static bool getWorkingDirectory(std::string &name);
    static void errordump();
    static void updatestar(long niter, long refresh, int width);
    static void adaptstar(long niter, long refresh, int width);
    static void setParameters(ParseTree *p, ParseTree *param1);
    static void setParameters(ParseTree *p, std::vector<ParseTree*> *parameters);
    static void setParameters(ParseTree *p, ParseTree *param1, ParseTree *param2);
    static void loadModule(std::string const &name);
    static void unloadModule(std::string const &name);
    static void dumpSamplers(std::string const &file);
    static void delete_pvec(std::vector<ParseTree*> *);
    static void print_unused_variables();
    static void listFactories(FactoryType type);
    static void setFactory(std::string const &name, FactoryType type,
                           std::string const &status);

    

/* Line 189 of yacc.c  */
#line 167 "parser.cc"

/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif


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

/* Line 214 of yacc.c  */
#line 91 "parser.yy"

  int intval;
  double val;
  std::string *stringptr;
  ParseTree *ptree;
  std::vector<ParseTree*> *pvec;
  std::vector<double> *vec;
  std::vector<long> *ivec;



/* Line 214 of yacc.c  */
#line 319 "parser.cc"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 331 "parser.cc"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int yyi)
#else
static int
YYID (yyi)
    int yyi;
#endif
{
  return yyi;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
	Stack = &yyptr->Stack_alloc;					\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  2
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   268

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  64
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  55
/* YYNRULES -- Number of rules.  */
#define YYNRULES  135
/* YYNRULES -- Number of states.  */
#define YYNSTATES  288

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   307

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      54,    55,    59,     2,    53,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    58,    60,
       2,    62,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    56,     2,    57,     2,     2,    61,     2,     2,    63,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     4,     7,     9,    12,    15,    17,    20,
      23,    25,    27,    29,    31,    33,    35,    37,    39,    41,
      43,    45,    47,    49,    51,    53,    55,    57,    59,    61,
      63,    65,    67,    71,    74,    78,    80,    84,    88,    91,
      95,   104,   106,   110,   119,   123,   127,   129,   136,   138,
     141,   149,   152,   160,   162,   164,   169,   171,   175,   177,
     181,   183,   185,   187,   191,   200,   203,   211,   219,   231,
     243,   247,   256,   260,   269,   271,   273,   276,   284,   287,
     295,   298,   301,   305,   313,   321,   329,   339,   349,   359,
     361,   364,   368,   372,   376,   380,   382,   384,   388,   395,
     397,   399,   403,   407,   411,   413,   415,   420,   422,   427,
     429,   433,   435,   437,   441,   443,   447,   449,   453,   455,
     460,   462,   467,   472,   474,   476,   481,   483,   487,   489,
     494,   496,   500,   502,   505,   507
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      65,     0,    -1,    -1,    65,    66,    -1,     8,    -1,    67,
       8,    -1,     1,     8,    -1,   118,    -1,    52,     8,    -1,
       7,     8,    -1,    68,    -1,    69,    -1,    70,    -1,    72,
      -1,    73,    -1,    74,    -1,    76,    -1,    77,    -1,    78,
      -1,    79,    -1,    85,    -1,    88,    -1,    90,    -1,    91,
      -1,    92,    -1,    80,    -1,   117,    -1,   115,    -1,   116,
      -1,    93,    -1,    94,    -1,    95,    -1,     9,    11,    89,
      -1,     9,    24,    -1,    71,    96,    46,    -1,    71,    -1,
      10,    12,    89,    -1,    10,    11,    89,    -1,    10,    24,
      -1,    75,    96,    46,    -1,    75,    96,    46,    53,    30,
      54,     3,    55,    -1,    75,    -1,    14,    12,    89,    -1,
      14,    12,    89,    53,    30,    54,     3,    55,    -1,    14,
      11,    89,    -1,    13,    11,    89,    -1,    15,    -1,    15,
      53,    29,    54,     3,    55,    -1,    16,    -1,    17,     3,
      -1,    17,     3,    53,    19,    54,     3,    55,    -1,    18,
       3,    -1,    18,     3,    53,    19,    54,     3,    55,    -1,
      28,    -1,     5,    -1,     5,    56,    82,    57,    -1,    83,
      -1,    82,    53,    83,    -1,    84,    -1,    84,    58,    84,
      -1,     3,    -1,    86,    -1,    87,    -1,    21,    23,    81,
      -1,    21,    23,    81,    53,    25,    54,     3,    55,    -1,
      21,    81,    -1,    21,    81,    53,    25,    54,     3,    55,
      -1,    21,    81,    53,    22,    54,     5,    55,    -1,    21,
      81,    53,    22,    54,     5,    55,    25,    54,     3,    55,
      -1,    21,    81,    53,    25,    54,     3,    55,    22,    54,
       5,    55,    -1,    21,    24,    81,    -1,    21,    24,    81,
      53,    22,    54,     5,    55,    -1,    20,    12,    89,    -1,
      20,    12,    89,    53,    22,    54,     5,    55,    -1,     5,
      -1,     6,    -1,    26,    81,    -1,    26,    81,    53,    27,
      54,    89,    55,    -1,    26,    59,    -1,    26,    59,    53,
      27,    54,    89,    55,    -1,    31,    89,    -1,    32,     5,
      -1,    34,    12,    89,    -1,    38,    37,    53,    22,    54,
      33,    55,    -1,    38,    37,    53,    22,    54,    35,    55,
      -1,    38,    37,    53,    22,    54,    21,    55,    -1,    23,
      36,     6,     5,    53,    22,    54,    33,    55,    -1,    23,
      36,     5,     5,    53,    22,    54,    35,    55,    -1,    23,
      36,     5,     5,    53,    22,    54,    21,    55,    -1,    97,
      -1,    96,    97,    -1,    96,    60,    97,    -1,    98,    45,
      99,    -1,    98,    45,   102,    -1,    98,    45,     6,    -1,
       6,    -1,     5,    -1,    61,     5,    61,    -1,    39,    54,
     102,    53,   100,    55,    -1,   101,    -1,   107,    -1,   100,
      53,   107,    -1,   100,    53,   101,    -1,    40,    62,   102,
      -1,   103,    -1,   104,    -1,    47,    54,   104,    55,    -1,
     106,    -1,    63,    54,   105,    55,    -1,   106,    -1,   105,
      53,   106,    -1,     4,    -1,    41,    -1,     5,    62,   110,
      -1,   109,    -1,   108,    53,   109,    -1,   110,    -1,     5,
      62,   110,    -1,   111,    -1,    47,    54,   111,    55,    -1,
     113,    -1,    38,    54,   108,    55,    -1,    39,    54,   108,
      55,    -1,    42,    -1,     4,    -1,    63,    54,   112,    55,
      -1,     4,    -1,   112,    53,     4,    -1,     6,    -1,    63,
      54,   114,    55,    -1,     6,    -1,   114,    53,     6,    -1,
      50,    -1,    49,    89,    -1,    48,    -1,    51,    89,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   168,   168,   172,   178,   179,   180,   181,   182,   183,
     186,   187,   188,   189,   190,   191,   192,   193,   194,   195,
     196,   197,   198,   199,   200,   201,   202,   203,   204,   205,
     206,   207,   210,   221,   226,   234,   237,   243,   254,   260,
     279,   292,   295,   299,   305,   314,   326,   330,   336,   343,
     347,   352,   357,   362,   365,   368,   374,   377,   382,   385,
     391,   394,   395,   398,   401,   404,   407,   410,   414,   418,
     424,   427,   433,   439,   451,   452,   455,   458,   461,   464,
     469,   472,   475,   482,   487,   492,   498,   505,   512,   522,
     525,   528,   533,   536,   541,   549,   550,   551,   556,   567,
     568,   569,   570,   573,   578,   579,   582,   585,   589,   595,
     596,   599,   600,   606,   609,   610,   613,   614,   617,   618,
     619,   620,   621,   622,   625,   626,   629,   630,   633,   634,
     637,   638,   643,   654,   662,   686
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "INT", "DOUBLE", "NAME", "STRING",
  "SYSCMD", "ENDCMD", "MODEL", "DATA", "IN", "TO", "INITS", "PARAMETERS",
  "COMPILE", "INITIALIZE", "ADAPT", "UPDATE", "BY", "MONITORS", "MONITOR",
  "TYPE", "SET", "CLEAR", "THIN", "CODA", "STEM", "EXIT", "NCHAINS",
  "CHAIN", "LOAD", "UNLOAD", "SAMPLER", "SAMPLERS", "RNGTOK", "FACTORY",
  "FACTORIES", "LIST", "STRUCTURE", "DIM", "NA", "R_NULL", "DIMNAMES",
  "ITER", "ARROW", "ENDDATA", "ASINTEGER", "DIRECTORY", "CD", "PWD", "RUN",
  "ENDSCRIPT", "','", "'('", "')'", "'['", "']'", "':'", "'*'", "';'",
  "'`'", "'='", "'c'", "$accept", "input", "line", "command", "model",
  "data_in", "data_to", "data", "data_clear", "parameters_in",
  "parameters_to", "parameters", "compile", "initialize", "adapt",
  "update", "exit", "var", "range_list", "range_element", "index",
  "monitor", "monitor_set", "monitor_clear", "monitors_to", "file_name",
  "coda", "load", "unload", "samplers_to", "list_factories", "set_factory",
  "r_assignment_list", "r_assignment", "r_name", "r_structure",
  "r_attribute_list", "r_dim", "r_collection", "r_integer_collection",
  "r_value_collection", "r_value_list", "r_value", "r_generic_attribute",
  "r_generic_list", "r_generic_list_element", "r_generic_vector",
  "r_numeric_vector", "r_double_list", "r_character_vector",
  "r_string_list", "get_working_dir", "set_working_dir", "read_dir",
  "run_script", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,    44,    40,    41,    91,    93,    58,    42,
      59,    96,    61,    99
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    64,    65,    65,    66,    66,    66,    66,    66,    66,
      67,    67,    67,    67,    67,    67,    67,    67,    67,    67,
      67,    67,    67,    67,    67,    67,    67,    67,    67,    67,
      67,    67,    68,    68,    69,    69,    70,    71,    72,    73,
      73,    73,    74,    74,    75,    75,    76,    76,    77,    78,
      78,    79,    79,    80,    81,    81,    82,    82,    83,    83,
      84,    85,    85,    86,    86,    86,    86,    86,    86,    86,
      87,    87,    88,    88,    89,    89,    90,    90,    90,    90,
      91,    92,    93,    94,    94,    94,    95,    95,    95,    96,
      96,    96,    97,    97,    97,    98,    98,    98,    99,   100,
     100,   100,   100,   101,   102,   102,   103,   104,   104,   105,
     105,   106,   106,   107,   108,   108,   109,   109,   110,   110,
     110,   110,   110,   110,   111,   111,   112,   112,   113,   113,
     114,   114,   115,   116,   117,   118
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     2,     1,     2,     2,     1,     2,     2,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     3,     2,     3,     1,     3,     3,     2,     3,
       8,     1,     3,     8,     3,     3,     1,     6,     1,     2,
       7,     2,     7,     1,     1,     4,     1,     3,     1,     3,
       1,     1,     1,     3,     8,     2,     7,     7,    11,    11,
       3,     8,     3,     8,     1,     1,     2,     7,     2,     7,
       2,     2,     3,     7,     7,     7,     9,     9,     9,     1,
       2,     3,     3,     3,     3,     1,     1,     3,     6,     1,
       1,     3,     3,     3,     1,     1,     4,     1,     4,     1,
       3,     1,     1,     3,     1,     3,     1,     3,     1,     4,
       1,     4,     4,     1,     1,     4,     1,     3,     1,     4,
       1,     3,     1,     2,     1,     2
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     1,     0,     0,     4,     0,     0,     0,     0,
      46,    48,     0,     0,     0,     0,     0,     0,    53,     0,
       0,     0,     0,   134,     0,   132,     0,     0,     3,     0,
      10,    11,    12,    35,    13,    14,    15,    41,    16,    17,
      18,    19,    25,    20,    61,    62,    21,    22,    23,    24,
      29,    30,    31,    27,    28,    26,     7,     6,     9,     0,
      33,     0,     0,    38,     0,     0,     0,     0,    49,    51,
       0,    54,     0,     0,    65,     0,    78,    76,    74,    75,
      80,    81,     0,     0,   133,   135,     8,     5,    96,    95,
       0,     0,    89,     0,     0,    32,    37,    36,    45,    44,
      42,     0,     0,     0,    72,     0,    63,    70,     0,     0,
       0,     0,     0,    82,     0,     0,    34,     0,    90,     0,
      39,     0,     0,     0,     0,     0,    60,     0,    56,    58,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    97,
      91,   111,    94,     0,   112,     0,     0,    92,    93,   104,
     105,   107,     0,     0,     0,     0,     0,     0,     0,    55,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    47,     0,     0,     0,    57,
      59,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   109,     0,     0,    50,    52,
       0,     0,     0,    67,    66,     0,     0,    79,    77,    85,
      83,    84,     0,   106,     0,   108,     0,    43,    73,    64,
      71,     0,     0,     0,     0,     0,     0,     0,     0,    99,
     100,   110,    40,     0,     0,    88,    87,    86,     0,     0,
       0,    98,     0,     0,   124,   128,     0,     0,   123,     0,
       0,   113,   118,   120,   103,   102,   101,    68,    69,     0,
       0,     0,     0,     0,     0,   114,   116,     0,     0,     0,
     126,   130,     0,     0,     0,     0,   121,   122,     0,   119,
       0,   125,     0,   129,   117,   115,   127,   131
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,    28,    29,    30,    31,    32,    33,    34,    35,
      36,    37,    38,    39,    40,    41,    42,    74,   127,   128,
     129,    43,    44,    45,    46,    80,    47,    48,    49,    50,
      51,    52,    91,    92,    93,   147,   228,   229,   148,   149,
     150,   194,   151,   230,   264,   265,   266,   252,   272,   253,
     273,    53,    54,    55,    56
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -236
static const yytype_int16 yypact[] =
{
    -236,    87,  -236,    -4,     7,  -236,    10,   100,    42,   129,
      39,  -236,    57,    62,    86,     9,    63,     2,  -236,    18,
     101,    97,    77,  -236,    18,  -236,    18,   109,  -236,   112,
    -236,  -236,  -236,    25,  -236,  -236,  -236,    25,  -236,  -236,
    -236,  -236,  -236,  -236,  -236,  -236,  -236,  -236,  -236,  -236,
    -236,  -236,  -236,  -236,  -236,  -236,  -236,  -236,  -236,    18,
    -236,    18,    18,  -236,    18,    18,    18,    94,    89,    98,
      18,    96,   148,   148,   102,   144,   103,   104,  -236,  -236,
    -236,  -236,    18,   105,  -236,  -236,  -236,  -236,  -236,  -236,
     149,    20,  -236,   114,    23,  -236,  -236,  -236,  -236,  -236,
     107,   108,   142,   145,   110,   162,   113,   115,    60,   164,
     165,   140,   146,  -236,   150,   116,  -236,    25,  -236,    16,
     118,   151,   171,   121,   122,   156,  -236,    69,  -236,   125,
     154,   158,   128,   130,   132,   133,   134,   135,   136,  -236,
    -236,  -236,  -236,   137,  -236,   138,   139,  -236,  -236,  -236,
    -236,  -236,   157,   141,   143,   191,   193,   147,   162,  -236,
     162,   152,   153,   192,   196,   178,   180,    18,    18,    56,
      15,     4,     8,   155,   200,  -236,   159,   160,   199,  -236,
    -236,   202,   203,   161,   163,   166,   167,   168,   169,   170,
     172,   173,   176,   175,    21,  -236,   207,   177,  -236,  -236,
     179,   181,   182,   186,   190,    -8,   184,  -236,  -236,  -236,
    -236,  -236,    31,  -236,     8,  -236,   183,  -236,  -236,  -236,
    -236,   185,   187,   188,   189,   194,   195,   197,    74,  -236,
    -236,  -236,  -236,   210,   214,  -236,  -236,  -236,    12,    15,
      31,  -236,   198,   201,  -236,  -236,   204,   206,  -236,   208,
     209,  -236,  -236,  -236,  -236,  -236,  -236,  -236,  -236,     5,
       5,     1,   124,   205,    78,  -236,  -236,    79,   211,   213,
    -236,  -236,    92,    93,    12,     5,  -236,  -236,   218,  -236,
     222,  -236,   225,  -236,  -236,  -236,  -236,  -236
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -236,  -236,  -236,  -236,  -236,  -236,  -236,  -236,  -236,  -236,
    -236,  -236,  -236,  -236,  -236,  -236,  -236,     0,  -236,    75,
      80,  -236,  -236,  -236,  -236,   -24,  -236,  -236,  -236,  -236,
    -236,  -236,   215,    -1,  -236,  -236,  -236,    -5,  -169,  -236,
      71,  -236,  -166,     6,   -15,   -28,  -235,   -13,  -236,  -236,
    -236,  -236,  -236,  -236,  -236
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint16 yytable[] =
{
      84,   192,    85,   251,    57,   244,   195,    71,   141,   244,
     263,   245,   141,   223,    71,    58,   244,    77,   245,   141,
     141,    59,   142,    78,    79,    88,    89,   224,    88,    89,
      88,    89,    72,    73,    60,    95,   226,    96,    97,   284,
      98,    99,   100,   246,   247,   144,   104,   248,   231,   144,
     246,   247,   249,    64,   248,   143,   144,   144,   113,   249,
      68,    76,   145,   145,   268,    69,   116,   146,   250,   120,
     254,   227,   106,   107,   214,   250,   215,   189,   146,   146,
     117,    90,   132,   117,    90,   133,    90,     2,     3,   190,
     118,   191,    67,   118,     4,     5,     6,     7,    70,    75,
       8,     9,    10,    11,    12,    13,    81,    14,    15,    82,
      16,    61,    62,    17,    83,    18,   140,    86,    19,    20,
      87,    21,   158,   101,    63,    22,   159,   240,   270,   241,
     271,   275,   275,   276,   277,    23,    24,    25,    26,    27,
      65,    66,   102,   187,   188,   280,   282,   281,   283,   109,
     110,   103,   105,    71,   115,   108,   111,   112,   114,   119,
     121,   123,   122,   125,   124,   126,   130,   136,   131,   134,
     135,   152,   138,   137,   154,   155,   156,   139,   157,   161,
     162,   153,   163,   160,   164,   165,   166,   173,   167,   168,
     169,   170,   171,   172,   176,   174,   177,   183,   175,   184,
     185,   178,   186,   197,   200,   201,   181,   182,   202,   196,
     216,   221,   222,   242,   198,   199,   203,   225,   204,   243,
     205,   206,   270,   207,   208,   209,   286,   210,   211,   212,
     213,   287,   217,   179,   218,   255,   219,   220,   232,   233,
     180,   234,   193,   235,   236,   267,   256,   285,   269,   237,
       0,     0,    94,   257,     0,     0,   258,   238,   259,   239,
     260,     0,   261,   262,     0,   278,     0,   274,   279
};

static const yytype_int16 yycheck[] =
{
      24,   170,    26,   238,     8,     4,   172,     5,     4,     4,
       5,     6,     4,    21,     5,     8,     4,    17,     6,     4,
       4,    11,     6,     5,     6,     5,     6,    35,     5,     6,
       5,     6,    23,    24,    24,    59,     5,    61,    62,   274,
      64,    65,    66,    38,    39,    41,    70,    42,   214,    41,
      38,    39,    47,    11,    42,    39,    41,    41,    82,    47,
       3,    59,    47,    47,    63,     3,    46,    63,    63,    46,
     239,    40,    72,    73,    53,    63,    55,    21,    63,    63,
      60,    61,    22,    60,    61,    25,    61,     0,     1,    33,
      91,    35,    53,    94,     7,     8,     9,    10,    12,    36,
      13,    14,    15,    16,    17,    18,     5,    20,    21,    12,
      23,    11,    12,    26,    37,    28,   117,     8,    31,    32,
       8,    34,    53,    29,    24,    38,    57,    53,     4,    55,
       6,    53,    53,    55,    55,    48,    49,    50,    51,    52,
      11,    12,    53,   167,   168,    53,    53,    55,    55,     5,
       6,    53,    56,     5,     5,    53,    53,    53,    53,    45,
      53,    19,    54,    53,    19,     3,    53,    27,    53,     5,
       5,    53,    22,    27,     3,    54,    54,    61,    22,    25,
      22,    30,    54,    58,    54,    53,    53,    30,    54,    54,
      54,    54,    54,    54,     3,    54,     3,     5,    55,     3,
      22,    54,    22,     3,     5,     3,    54,    54,     5,    54,
       3,    25,    22,     3,    55,    55,    55,    33,    55,     5,
      54,    54,     4,    55,    55,    55,     4,    55,    55,    53,
      55,     6,    55,   158,    55,   240,    55,    55,    55,    54,
     160,    54,   171,    55,    55,   260,   240,   275,   261,    55,
      -1,    -1,    37,    55,    -1,    -1,    55,    62,    54,    62,
      54,    -1,    54,    54,    -1,    54,    -1,    62,    55
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    65,     0,     1,     7,     8,     9,    10,    13,    14,
      15,    16,    17,    18,    20,    21,    23,    26,    28,    31,
      32,    34,    38,    48,    49,    50,    51,    52,    66,    67,
      68,    69,    70,    71,    72,    73,    74,    75,    76,    77,
      78,    79,    80,    85,    86,    87,    88,    90,    91,    92,
      93,    94,    95,   115,   116,   117,   118,     8,     8,    11,
      24,    11,    12,    24,    11,    11,    12,    53,     3,     3,
      12,     5,    23,    24,    81,    36,    59,    81,     5,     6,
      89,     5,    12,    37,    89,    89,     8,     8,     5,     6,
      61,    96,    97,    98,    96,    89,    89,    89,    89,    89,
      89,    29,    53,    53,    89,    56,    81,    81,    53,     5,
       6,    53,    53,    89,    53,     5,    46,    60,    97,    45,
      46,    53,    54,    19,    19,    53,     3,    82,    83,    84,
      53,    53,    22,    25,     5,     5,    27,    27,    22,    61,
      97,     4,     6,    39,    41,    47,    63,    99,   102,   103,
     104,   106,    53,    30,     3,    54,    54,    22,    53,    57,
      58,    25,    22,    54,    54,    53,    53,    54,    54,    54,
      54,    54,    54,    30,    54,    55,     3,     3,    54,    83,
      84,    54,    54,     5,     3,    22,    22,    89,    89,    21,
      33,    35,   102,   104,   105,   106,    54,     3,    55,    55,
       5,     3,     5,    55,    55,    54,    54,    55,    55,    55,
      55,    55,    53,    55,    53,    55,     3,    55,    55,    55,
      55,    25,    22,    21,    35,    33,     5,    40,   100,   101,
     107,   106,    55,    54,    54,    55,    55,    55,    62,    62,
      53,    55,     3,     5,     4,     6,    38,    39,    42,    47,
      63,   110,   111,   113,   102,   101,   107,    55,    55,    54,
      54,    54,    54,     5,   108,   109,   110,   108,    63,   111,
       4,     6,   112,   114,    62,    53,    55,    55,    54,    55,
      53,    55,    53,    55,   110,   109,     4,     6
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  However,
   YYFAIL appears to be in use.  Nevertheless, it is formally deprecated
   in Bison 2.4.2's NEWS entry, where a plan to phase it out is
   discussed.  */

#define YYFAIL		goto yyerrlab
#if defined YYFAIL
  /* This is here to suppress warnings from the GCC cpp's
     -Wunused-macros.  Normally we don't worry about that warning, but
     some users do, and we want to make it easy for users to remove
     YYFAIL uses, which will produce warnings from Bison 2.5.  */
#endif

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
#else
static void
yy_stack_print (yybottom, yytop)
    yytype_int16 *yybottom;
    yytype_int16 *yytop;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}

/* Prevent warnings from -Wmissing-prototypes.  */
#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */


/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*-------------------------.
| yyparse or yypush_parse.  |
`-------------------------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{


    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       `yyss': related to states.
       `yyvs': related to semantic values.

       Refer to the stacks thru separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yytoken = 0;
  yyss = yyssa;
  yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */
  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss_alloc, yyss);
	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:

/* Line 1464 of yacc.c  */
#line 168 "parser.yy"
    {
    if (interactive && command_buffer_count == 0) 
	std::cout << ". " << std::flush;
}
    break;

  case 3:

/* Line 1464 of yacc.c  */
#line 172 "parser.yy"
    {
    if (interactive && command_buffer_count == 0) 
	std::cout << ". " << std::flush;
}
    break;

  case 4:

/* Line 1464 of yacc.c  */
#line 178 "parser.yy"
    {}
    break;

  case 5:

/* Line 1464 of yacc.c  */
#line 179 "parser.yy"
    {}
    break;

  case 6:

/* Line 1464 of yacc.c  */
#line 180 "parser.yy"
    {if(interactive) yyerrok; else exit(1); }
    break;

  case 7:

/* Line 1464 of yacc.c  */
#line 181 "parser.yy"
    {}
    break;

  case 8:

/* Line 1464 of yacc.c  */
#line 182 "parser.yy"
    {}
    break;

  case 9:

/* Line 1464 of yacc.c  */
#line 183 "parser.yy"
    { doSystem((yyvsp[(1) - (2)].stringptr)); delete (yyvsp[(1) - (2)].stringptr);}
    break;

  case 32:

/* Line 1464 of yacc.c  */
#line 210 "parser.yy"
    {
    std::FILE *file = std::fopen(ExpandFileName(((yyvsp[(3) - (3)].stringptr))->c_str()).c_str(), "r");
    if (!file) {
	std::cerr << "Failed to open file " << *((yyvsp[(3) - (3)].stringptr)) << std::endl;
    }
    else {
	console->checkModel(file);
	std::fclose(file);
    }
    delete (yyvsp[(3) - (3)].stringptr);
}
    break;

  case 33:

/* Line 1464 of yacc.c  */
#line 221 "parser.yy"
    {
    console->clearModel();
}
    break;

  case 34:

/* Line 1464 of yacc.c  */
#line 226 "parser.yy"
    {
    std::string rngname;
    readRData((yyvsp[(2) - (3)].pvec), _data_table, rngname);
    if (rngname.size() != 0) {
	std::cerr << "WARNING: .RNG.name assignment ignored" << std::endl;
    }
    delete_pvec((yyvsp[(2) - (3)].pvec));
 }
    break;

  case 35:

/* Line 1464 of yacc.c  */
#line 234 "parser.yy"
    {}
    break;

  case 36:

/* Line 1464 of yacc.c  */
#line 237 "parser.yy"
    {
    doDump(*(yyvsp[(3) - (3)].stringptr), DUMP_DATA, 1);
    delete (yyvsp[(3) - (3)].stringptr);
}
    break;

  case 37:

/* Line 1464 of yacc.c  */
#line 243 "parser.yy"
    {
    if(open_data_buffer((yyvsp[(3) - (3)].stringptr))) {
	std::cout << "Reading data file " << *(yyvsp[(3) - (3)].stringptr) << std::endl;
    }
    else {
	std::cerr << "Unable to open file " << *(yyvsp[(3) - (3)].stringptr) << std::endl << std::flush;
    }
    delete (yyvsp[(3) - (3)].stringptr);
 }
    break;

  case 38:

/* Line 1464 of yacc.c  */
#line 254 "parser.yy"
    {
  std::cout << "Clearing data table " << std::endl;
  _data_table.clear();
}
    break;

  case 39:

/* Line 1464 of yacc.c  */
#line 261 "parser.yy"
    {
    std::map<std::string, SArray> parameter_table;
    std::string rngname;
    readRData((yyvsp[(2) - (3)].pvec), parameter_table, rngname);
    delete_pvec((yyvsp[(2) - (3)].pvec));
    /* Set all chains to the same state. If the user sets the
       RNG state in addition to the parameter values then all
       chains will be identical!
    */
    for (unsigned int i = 1; i <= console->nchain(); ++i) {
	/* We have to set the name first, because the state or seed
	   might be embedded in the parameter_table */
	if (rngname.size() != 0) {
	    console->setRNGname(rngname, i);
	}
	console->setParameters(parameter_table, i);
    }
}
    break;

  case 40:

/* Line 1464 of yacc.c  */
#line 280 "parser.yy"
    {
    std::map<std::string, SArray> parameter_table;
    std::string rngname;
    readRData((yyvsp[(2) - (8)].pvec), parameter_table, rngname);
    delete (yyvsp[(2) - (8)].pvec);
    /* We have to set the name first, because the state or seed
       might be embedded in the parameter_table */
    if (rngname.size() != 0) {
        console->setRNGname(rngname, (yyvsp[(7) - (8)].intval));
    }
    console->setParameters(parameter_table, (yyvsp[(7) - (8)].intval));
}
    break;

  case 41:

/* Line 1464 of yacc.c  */
#line 292 "parser.yy"
    {}
    break;

  case 42:

/* Line 1464 of yacc.c  */
#line 295 "parser.yy"
    {
    doDump(*(yyvsp[(3) - (3)].stringptr), DUMP_PARAMETERS, 1);
    delete (yyvsp[(3) - (3)].stringptr);
}
    break;

  case 43:

/* Line 1464 of yacc.c  */
#line 299 "parser.yy"
    {
    doDump(*(yyvsp[(3) - (8)].stringptr), DUMP_PARAMETERS, (yyvsp[(7) - (8)].intval));
    delete (yyvsp[(3) - (8)].stringptr);
}
    break;

  case 44:

/* Line 1464 of yacc.c  */
#line 305 "parser.yy"
    {
  if(open_data_buffer((yyvsp[(3) - (3)].stringptr))) {
    std::cout << "Reading parameter file " << *(yyvsp[(3) - (3)].stringptr) << std::endl;
  }
  else {
    std::cerr << "Unable to open file " << *(yyvsp[(3) - (3)].stringptr) << std::endl << std::flush;
  }
  delete (yyvsp[(3) - (3)].stringptr);
}
    break;

  case 45:

/* Line 1464 of yacc.c  */
#line 314 "parser.yy"
    {
  /* Legacy option to not break existing scripts */
  if(open_data_buffer((yyvsp[(3) - (3)].stringptr))) {
    std::cout << "Reading initial values file " << *(yyvsp[(3) - (3)].stringptr) << std::endl;
  }
  else {
    std::cerr << "Unable to open file " << *(yyvsp[(3) - (3)].stringptr) << std::endl << std::flush;
  }
  delete (yyvsp[(3) - (3)].stringptr);
}
    break;

  case 46:

/* Line 1464 of yacc.c  */
#line 326 "parser.yy"
    {
    console->compile(_data_table, 1, true);
    print_unused_variables();
}
    break;

  case 47:

/* Line 1464 of yacc.c  */
#line 330 "parser.yy"
    {
    console->compile(_data_table, (yyvsp[(5) - (6)].intval), true);
    print_unused_variables();
}
    break;

  case 48:

/* Line 1464 of yacc.c  */
#line 336 "parser.yy"
    {
  if (!console->initialize()) {
    errordump();
  }
}
    break;

  case 49:

/* Line 1464 of yacc.c  */
#line 343 "parser.yy"
    {
    long refresh = (yyvsp[(2) - (2)].intval)/40;
    adaptstar((yyvsp[(2) - (2)].intval), refresh, 40);
}
    break;

  case 50:

/* Line 1464 of yacc.c  */
#line 347 "parser.yy"
    {
    adaptstar((yyvsp[(2) - (7)].intval),(yyvsp[(6) - (7)].intval),40);
}
    break;

  case 51:

/* Line 1464 of yacc.c  */
#line 352 "parser.yy"
    {
  //fixme: put refresh option
  long refresh = (yyvsp[(2) - (2)].intval)/40;
  updatestar((yyvsp[(2) - (2)].intval), refresh, 40);
}
    break;

  case 52:

/* Line 1464 of yacc.c  */
#line 357 "parser.yy"
    {
  updatestar((yyvsp[(2) - (7)].intval),(yyvsp[(6) - (7)].intval), 40);
}
    break;

  case 53:

/* Line 1464 of yacc.c  */
#line 362 "parser.yy"
    { return 0; }
    break;

  case 54:

/* Line 1464 of yacc.c  */
#line 365 "parser.yy"
    {
  (yyval.ptree) = new ParseTree(P_VAR); setName((yyval.ptree), (yyvsp[(1) - (1)].stringptr));
}
    break;

  case 55:

/* Line 1464 of yacc.c  */
#line 368 "parser.yy"
    {
  (yyval.ptree) = new ParseTree(P_VAR); setName((yyval.ptree), (yyvsp[(1) - (4)].stringptr));
  setParameters((yyval.ptree), (yyvsp[(3) - (4)].pvec));
}
    break;

  case 56:

/* Line 1464 of yacc.c  */
#line 374 "parser.yy"
    {
  (yyval.pvec) = new std::vector<ParseTree*>(1, (yyvsp[(1) - (1)].ptree)); 
}
    break;

  case 57:

/* Line 1464 of yacc.c  */
#line 377 "parser.yy"
    {
  (yyval.pvec)=(yyvsp[(1) - (3)].pvec); (yyval.pvec)->push_back((yyvsp[(3) - (3)].ptree));
}
    break;

  case 58:

/* Line 1464 of yacc.c  */
#line 382 "parser.yy"
    {
  (yyval.ptree) = new ParseTree(P_RANGE); setParameters((yyval.ptree),(yyvsp[(1) - (1)].ptree));
}
    break;

  case 59:

/* Line 1464 of yacc.c  */
#line 385 "parser.yy"
    {
  (yyval.ptree) = new ParseTree(P_RANGE); setParameters((yyval.ptree), (yyvsp[(1) - (3)].ptree), (yyvsp[(3) - (3)].ptree));
}
    break;

  case 60:

/* Line 1464 of yacc.c  */
#line 391 "parser.yy"
    {(yyval.ptree) = new ParseTree(P_VALUE); (yyval.ptree)->setValue((yyvsp[(1) - (1)].intval));}
    break;

  case 63:

/* Line 1464 of yacc.c  */
#line 398 "parser.yy"
    { 
    setMonitor((yyvsp[(3) - (3)].ptree), 1, "trace"); delete (yyvsp[(3) - (3)].ptree);
}
    break;

  case 64:

/* Line 1464 of yacc.c  */
#line 401 "parser.yy"
    { 
    setMonitor((yyvsp[(3) - (8)].ptree), (yyvsp[(7) - (8)].intval), "trace"); delete (yyvsp[(3) - (8)].ptree);
}
    break;

  case 65:

/* Line 1464 of yacc.c  */
#line 404 "parser.yy"
    {
    setMonitor((yyvsp[(2) - (2)].ptree), 1, "trace"); delete (yyvsp[(2) - (2)].ptree);
}
    break;

  case 66:

/* Line 1464 of yacc.c  */
#line 407 "parser.yy"
    { 
    setMonitor((yyvsp[(2) - (7)].ptree), (yyvsp[(6) - (7)].intval), "trace"); delete (yyvsp[(2) - (7)].ptree);
}
    break;

  case 67:

/* Line 1464 of yacc.c  */
#line 410 "parser.yy"
    {
    setMonitor((yyvsp[(2) - (7)].ptree), 1, *(yyvsp[(6) - (7)].stringptr));
    delete (yyvsp[(6) - (7)].stringptr);
}
    break;

  case 68:

/* Line 1464 of yacc.c  */
#line 414 "parser.yy"
    {
    setMonitor((yyvsp[(2) - (11)].ptree), (yyvsp[(10) - (11)].intval), *(yyvsp[(6) - (11)].stringptr)); 
    delete (yyvsp[(6) - (11)].stringptr);
}
    break;

  case 69:

/* Line 1464 of yacc.c  */
#line 418 "parser.yy"
    {
    setMonitor((yyvsp[(2) - (11)].ptree), (yyvsp[(6) - (11)].intval), *(yyvsp[(10) - (11)].stringptr)); 
    delete (yyvsp[(10) - (11)].stringptr);
}
    break;

  case 70:

/* Line 1464 of yacc.c  */
#line 424 "parser.yy"
    {
    clearMonitor((yyvsp[(3) - (3)].ptree), "trace"); delete (yyvsp[(3) - (3)].ptree);
}
    break;

  case 71:

/* Line 1464 of yacc.c  */
#line 427 "parser.yy"
    {
    clearMonitor((yyvsp[(3) - (8)].ptree), *(yyvsp[(7) - (8)].stringptr));
    delete (yyvsp[(7) - (8)].stringptr);
}
    break;

  case 72:

/* Line 1464 of yacc.c  */
#line 434 "parser.yy"
    {
    dumpMonitors(*(yyvsp[(3) - (3)].stringptr), "trace");
    delete (yyvsp[(3) - (3)].stringptr);
}
    break;

  case 73:

/* Line 1464 of yacc.c  */
#line 439 "parser.yy"
    {
    dumpMonitors(*(yyvsp[(3) - (8)].stringptr), *(yyvsp[(7) - (8)].stringptr));
    delete (yyvsp[(3) - (8)].stringptr);
    delete (yyvsp[(7) - (8)].stringptr); 
}
    break;

  case 74:

/* Line 1464 of yacc.c  */
#line 451 "parser.yy"
    { (yyval.stringptr) = (yyvsp[(1) - (1)].stringptr);}
    break;

  case 75:

/* Line 1464 of yacc.c  */
#line 452 "parser.yy"
    { (yyval.stringptr) = (yyvsp[(1) - (1)].stringptr); }
    break;

  case 76:

/* Line 1464 of yacc.c  */
#line 455 "parser.yy"
    {
  doCoda ((yyvsp[(2) - (2)].ptree), "CODA"); delete (yyvsp[(2) - (2)].ptree);
}
    break;

  case 77:

/* Line 1464 of yacc.c  */
#line 458 "parser.yy"
    {
  doCoda ((yyvsp[(2) - (7)].ptree), *(yyvsp[(6) - (7)].stringptr)); delete (yyvsp[(2) - (7)].ptree); delete (yyvsp[(6) - (7)].stringptr);
}
    break;

  case 78:

/* Line 1464 of yacc.c  */
#line 461 "parser.yy"
    {
  doAllCoda ("CODA"); 
}
    break;

  case 79:

/* Line 1464 of yacc.c  */
#line 464 "parser.yy"
    {
  doAllCoda (*(yyvsp[(6) - (7)].stringptr)); delete (yyvsp[(6) - (7)].stringptr); 
}
    break;

  case 80:

/* Line 1464 of yacc.c  */
#line 469 "parser.yy"
    { loadModule(*(yyvsp[(2) - (2)].stringptr)); }
    break;

  case 81:

/* Line 1464 of yacc.c  */
#line 472 "parser.yy"
    { unloadModule(*(yyvsp[(2) - (2)].stringptr)); }
    break;

  case 82:

/* Line 1464 of yacc.c  */
#line 476 "parser.yy"
    {
    dumpSamplers(*(yyvsp[(3) - (3)].stringptr));
    delete (yyvsp[(3) - (3)].stringptr);
}
    break;

  case 83:

/* Line 1464 of yacc.c  */
#line 483 "parser.yy"
    {
    listFactories(SAMPLER_FACTORY);
}
    break;

  case 84:

/* Line 1464 of yacc.c  */
#line 488 "parser.yy"
    {
    listFactories(RNG_FACTORY);
}
    break;

  case 85:

/* Line 1464 of yacc.c  */
#line 493 "parser.yy"
    {
    listFactories(MONITOR_FACTORY);
}
    break;

  case 86:

/* Line 1464 of yacc.c  */
#line 499 "parser.yy"
    {
    setFactory(*(yyvsp[(3) - (9)].stringptr), SAMPLER_FACTORY, *(yyvsp[(4) - (9)].stringptr));
    delete (yyvsp[(3) - (9)].stringptr);
    delete (yyvsp[(4) - (9)].stringptr);
}
    break;

  case 87:

/* Line 1464 of yacc.c  */
#line 506 "parser.yy"
    {
    setFactory(*(yyvsp[(3) - (9)].stringptr), RNG_FACTORY, *(yyvsp[(4) - (9)].stringptr));
    delete (yyvsp[(3) - (9)].stringptr);
    delete (yyvsp[(4) - (9)].stringptr);
}
    break;

  case 88:

/* Line 1464 of yacc.c  */
#line 513 "parser.yy"
    {
    setFactory(*(yyvsp[(3) - (9)].stringptr), MONITOR_FACTORY, *(yyvsp[(4) - (9)].stringptr));
    delete (yyvsp[(3) - (9)].stringptr);
    delete (yyvsp[(4) - (9)].stringptr);
}
    break;

  case 89:

/* Line 1464 of yacc.c  */
#line 522 "parser.yy"
    {
  (yyval.pvec) = new std::vector<ParseTree*>(1, (yyvsp[(1) - (1)].ptree));
}
    break;

  case 90:

/* Line 1464 of yacc.c  */
#line 525 "parser.yy"
    {
  (yyval.pvec) = (yyvsp[(1) - (2)].pvec); (yyval.pvec)->push_back((yyvsp[(2) - (2)].ptree));
}
    break;

  case 91:

/* Line 1464 of yacc.c  */
#line 528 "parser.yy"
    {
  (yyval.pvec) = (yyvsp[(1) - (3)].pvec); (yyval.pvec)->push_back((yyvsp[(3) - (3)].ptree));
}
    break;

  case 92:

/* Line 1464 of yacc.c  */
#line 533 "parser.yy"
    {
  (yyval.ptree) = (yyvsp[(3) - (3)].ptree); setName((yyval.ptree), (yyvsp[(1) - (3)].stringptr));
}
    break;

  case 93:

/* Line 1464 of yacc.c  */
#line 536 "parser.yy"
    {
  (yyval.ptree) = new ParseTree(P_ARRAY);
  setName((yyval.ptree), (yyvsp[(1) - (3)].stringptr));
  setParameters((yyval.ptree), (yyvsp[(3) - (3)].ptree));
}
    break;

  case 94:

/* Line 1464 of yacc.c  */
#line 541 "parser.yy"
    {
  /* Allow this for setting the NAME of the random number generator */
  (yyval.ptree) = new ParseTree(P_VAR); setName((yyval.ptree), (yyvsp[(1) - (3)].stringptr));
  ParseTree *p = new ParseTree(P_VAR); setName(p, (yyvsp[(3) - (3)].stringptr));
  setParameters((yyval.ptree), p);
}
    break;

  case 97:

/* Line 1464 of yacc.c  */
#line 551 "parser.yy"
    {
    /* R >= 2.4.0 uses backticks for quoted names */
    (yyval.stringptr) = (yyvsp[(2) - (3)].stringptr);
}
    break;

  case 98:

/* Line 1464 of yacc.c  */
#line 556 "parser.yy"
    {
  (yyval.ptree) = new ParseTree(P_ARRAY); 
  if ((yyvsp[(5) - (6)].ptree)) 
    setParameters((yyval.ptree), (yyvsp[(3) - (6)].ptree), (yyvsp[(5) - (6)].ptree));
  else
    setParameters((yyval.ptree), (yyvsp[(3) - (6)].ptree));
}
    break;

  case 100:

/* Line 1464 of yacc.c  */
#line 568 "parser.yy"
    {(yyval.ptree)=0;}
    break;

  case 102:

/* Line 1464 of yacc.c  */
#line 570 "parser.yy"
    {(yyval.ptree)=(yyvsp[(3) - (3)].ptree);}
    break;

  case 103:

/* Line 1464 of yacc.c  */
#line 573 "parser.yy"
    {
  (yyval.ptree) = (yyvsp[(3) - (3)].ptree);
}
    break;

  case 106:

/* Line 1464 of yacc.c  */
#line 582 "parser.yy"
    {(yyval.ptree) = (yyvsp[(3) - (4)].ptree);}
    break;

  case 107:

/* Line 1464 of yacc.c  */
#line 585 "parser.yy"
    { 
  (yyval.ptree) = new ParseTree(P_VECTOR); 
  setParameters((yyval.ptree), (yyvsp[(1) - (1)].ptree));
}
    break;

  case 108:

/* Line 1464 of yacc.c  */
#line 589 "parser.yy"
    {
  (yyval.ptree) = new ParseTree(P_VECTOR);
  setParameters((yyval.ptree), (yyvsp[(3) - (4)].pvec));
}
    break;

  case 109:

/* Line 1464 of yacc.c  */
#line 595 "parser.yy"
    {(yyval.pvec) = new std::vector<ParseTree*>(1, (yyvsp[(1) - (1)].ptree)); }
    break;

  case 110:

/* Line 1464 of yacc.c  */
#line 596 "parser.yy"
    {(yyval.pvec) = (yyvsp[(1) - (3)].pvec); (yyval.pvec)->push_back((yyvsp[(3) - (3)].ptree));}
    break;

  case 111:

/* Line 1464 of yacc.c  */
#line 599 "parser.yy"
    {(yyval.ptree) = new ParseTree(P_VALUE); (yyval.ptree)->setValue((yyvsp[(1) - (1)].val));}
    break;

  case 112:

/* Line 1464 of yacc.c  */
#line 600 "parser.yy"
    {(yyval.ptree) = new ParseTree(P_VALUE); (yyval.ptree)->setValue(JAGS_NA);}
    break;

  case 113:

/* Line 1464 of yacc.c  */
#line 606 "parser.yy"
    {;}
    break;

  case 114:

/* Line 1464 of yacc.c  */
#line 609 "parser.yy"
    {;}
    break;

  case 115:

/* Line 1464 of yacc.c  */
#line 610 "parser.yy"
    {;}
    break;

  case 116:

/* Line 1464 of yacc.c  */
#line 613 "parser.yy"
    {;}
    break;

  case 117:

/* Line 1464 of yacc.c  */
#line 614 "parser.yy"
    {;}
    break;

  case 118:

/* Line 1464 of yacc.c  */
#line 617 "parser.yy"
    {;}
    break;

  case 119:

/* Line 1464 of yacc.c  */
#line 618 "parser.yy"
    {;}
    break;

  case 120:

/* Line 1464 of yacc.c  */
#line 619 "parser.yy"
    {;}
    break;

  case 121:

/* Line 1464 of yacc.c  */
#line 620 "parser.yy"
    {;}
    break;

  case 122:

/* Line 1464 of yacc.c  */
#line 621 "parser.yy"
    {;}
    break;

  case 123:

/* Line 1464 of yacc.c  */
#line 622 "parser.yy"
    {;}
    break;

  case 124:

/* Line 1464 of yacc.c  */
#line 625 "parser.yy"
    {;}
    break;

  case 126:

/* Line 1464 of yacc.c  */
#line 629 "parser.yy"
    {;}
    break;

  case 127:

/* Line 1464 of yacc.c  */
#line 630 "parser.yy"
    {;}
    break;

  case 128:

/* Line 1464 of yacc.c  */
#line 633 "parser.yy"
    {;}
    break;

  case 129:

/* Line 1464 of yacc.c  */
#line 634 "parser.yy"
    {;}
    break;

  case 130:

/* Line 1464 of yacc.c  */
#line 637 "parser.yy"
    {;}
    break;

  case 131:

/* Line 1464 of yacc.c  */
#line 638 "parser.yy"
    {;}
    break;

  case 132:

/* Line 1464 of yacc.c  */
#line 644 "parser.yy"
    {
    std::string name;
    if (getWorkingDirectory(name)) {
	std::cout << name << std::endl;
    }
    else {
	std::cout << "ERROR: " << name << std::endl;
    }
}
    break;

  case 133:

/* Line 1464 of yacc.c  */
#line 655 "parser.yy"
    {
    if (chdir(((yyvsp[(2) - (2)].stringptr))->c_str()) == -1) {
	std::cout << "ERROR: Cannot change working directory" << std::endl;
    }
    delete (yyvsp[(2) - (2)].stringptr);
}
    break;

  case 134:

/* Line 1464 of yacc.c  */
#line 663 "parser.yy"
    {
    std::string name;
    if (!getWorkingDirectory(name)) {
	std::cerr << "ERROR: Unable to get working directory name\n"
		  << name << std::endl;
	return 0;
    }
	
    DIR *dir;
    struct dirent *de;
    if ((dir = opendir(name.c_str())) != 0) {
	while ((de = readdir(dir)) != 0) {
	    if (std::strcmp(de->d_name, ".") && std::strcmp(de->d_name, "..")) {
		std::cout << de->d_name << "\n";
	    }
	}
	closedir(dir);
    }
    else {
	std::cerr << "Unable to open working directory" << std::endl;
    }
}
    break;

  case 135:

/* Line 1464 of yacc.c  */
#line 686 "parser.yy"
    {
    if(open_command_buffer((yyvsp[(2) - (2)].stringptr))) {
	std::cout << "Running script file " << *(yyvsp[(2) - (2)].stringptr) << std::endl;
    }
    else {
	std::cerr << "Unable to open script file " << *(yyvsp[(2) - (2)].stringptr) << std::endl;
    }
    delete (yyvsp[(2) - (2)].stringptr);
 }
    break;



/* Line 1464 of yacc.c  */
#line 2774 "parser.cc"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  *++yyvsp = yylval;


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined(yyoverflow) || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}



/* Line 1684 of yacc.c  */
#line 697 "parser.yy"


int zzerror (const char *s)
{
    return_to_main_buffer();
    std::cerr << s << std::endl;
    return 0;
}

static Range getRange(ParseTree const *var)
{
  /* 
     Blank arguments, e.g. foo[] or bar[,1]  are not allowed.
  */
  unsigned int size = var->parameters().size();

  std::vector<int>  ind_lower(size), ind_upper(size);
  for (unsigned int i = 0; i < size; ++i) {
    ParseTree const *range_element = var->parameters()[i];
    switch(range_element->parameters().size()) {
    case 1:
      ind_lower[i] = (int) (range_element->parameters()[0]->value() + 1.0E-6);
      ind_upper[i] = ind_lower[i];
      break;
    case 2:
      ind_lower[i] = (int) (range_element->parameters()[0]->value() + 1.0E-6);  
      ind_upper[i] = (int) (range_element->parameters()[1]->value() + 1.0E-6);
      break;
    default:
      //Error! FIXME
      break;
    }
  }
  return Range(ind_lower, ind_upper);
}

void setMonitor(ParseTree const *var, int thin, std::string const &type)
{
    std::string const &name = var->name();
    if (var->parameters().empty()) {
	/* Requesting the whole node */
	console->setMonitor(name, Range(), thin, type);
    }
    else {
	/* Requesting subset of a multivariate node */
	console->setMonitor(name, getRange(var), thin, type);
    }
}

void clearMonitor(ParseTree const *var, std::string const &type)
{
    std::string const &name = var->name();
    if (var->parameters().empty()) {
	/* Requesting the whole node */
	console->clearMonitor(name, Range(), type);
    }
    else {
	/* Requesting subset of a multivariate node */
	console->clearMonitor(name, getRange(var), type);
    }
}

void doAllCoda (std::string const &stem)
{
    console->coda(stem);
}

void doCoda (ParseTree const *var, std::string const &stem)
{
    //FIXME: Allow list of several nodes

    std::vector<std::pair<std::string, Range> > dmp;
    if (var->parameters().empty()) {
	/* Requesting the whole node */
	dmp.push_back(std::pair<std::string,Range>(var->name(), Range()));
    }
    else {
	/* Requesting subset of a multivariate node */
	dmp.push_back(std::pair<std::string,Range>(var->name(), getRange(var)));
    }
    console->coda(dmp, stem);
}

/* Helper function for doDump that handles all the special cases
   (missing values etc) when writing a double value */
static void writeValue(double x, std::ostream &out, bool isdiscrete)
{
  using namespace std;

  if (x == JAGS_NA) {
    out << "NA";
  }
  else if (jags_isnan(x)) {
    out << "NaN";
  }
  else if (!jags_finite(x)) {
    if (x > 0)
      out << "Inf";
    else
      out << "-Inf";
  }
  else if (isdiscrete) {
      out << static_cast<int>(x) << "L";
  }
  else {
    out << x;
  }
}

void doDump(std::string const &file, DumpType type, unsigned int chain)
{
    std::map<std::string,SArray> data_table;
    std::string rng_name;
    if (!console->dumpState(data_table, rng_name, type, chain)) {
	return;
    }

    /* Open output file */
    std::ofstream out(file.c_str());
    if (!out) {
	std::cerr << "Failed to open file " << file << std::endl;
	return;
    }
  
    if (rng_name.size() != 0) {
	out << "`.RNG.name` <- \"" << rng_name << "\"\n";
    }

    for (std::map<std::string, SArray>::const_iterator p = data_table.begin();
	 p != data_table.end(); ++p) {
	std::string const &name = p->first;
	SArray const &sarray = p->second;
	std::vector<double> const &value = sarray.value();
	long length = sarray.length();
	out << "`" << name << "` <- " << std::endl;
	std::vector<unsigned int> const &dim = sarray.dim(false);
	bool discrete = sarray.isDiscreteValued();

	if (dim.size() == 1) {
	    // Vector 
	    if (dim[0] == 1) {
		// Scalar
		writeValue(value[0], out, discrete);
	    }
	    else {
		// Vector of length > 1
		out << "c(";
		for (int i = 0; i < length; ++i) {
		    if (i > 0) {
			out << ",";
		    }
		    writeValue(value[i], out, discrete);
		}
		out << ")";
	    }
	}
	else {
	    // Array 
	    out << "structure(c(";
	    for (int i = 0; i < length; ++i) {
		if (i > 0) {
		    out << ",";
		}
		writeValue(value[i], out, discrete);
	    }
	    out << "), .Dim = c(";
	    for (unsigned int j = 0; j < dim.size(); ++j) {
		if (j > 0) {
		    out << ",";
		}
		out << dim[j] << "L";
	    }
	    out << "))";
	}
	out << "\n";
    }
    out.close();
}  

void dumpMonitors(std::string const &file, std::string const &type)
{
    std::map<std::string,SArray> data_table;

    if (!console->dumpMonitors(data_table, type, false)) {
	return;
    }

    /* Open output file */
    std::ofstream out(file.c_str());
    if (!out) {
	std::cerr << "Failed to open file " << file << std::endl;
	return;
    }

    out << "`" << type << "` <-\nstructure(list(";

    std::map<std::string, SArray>::const_iterator p;
    for (p = data_table.begin(); p != data_table.end(); ++p) {
	std::string const &name = p->first;
	SArray const &sarray = p->second;
	std::vector<double> const &value = sarray.value();
	long length = sarray.length();

	if (p != data_table.begin()) {
	    out << ", \n";
	}
	out << "\"" << name << "\" = ";
	std::vector<unsigned int> const &dim = sarray.dim(false);
	bool discrete = sarray.isDiscreteValued();
	bool named = !sarray.dimNames().empty();

	if (dim.size() == 1 && !named) {
	    // Vector 
	    if (dim[0] == 1) {
		// Scalar
		writeValue(value[0], out, discrete);
	    }
	    else {
		// Vector of length > 1
		out << "c(";
		for (int i = 0; i < length; ++i) {
		    if (i > 0) {
			out << ",";
		    }
		    writeValue(value[i], out, discrete);
		}
		out << ")";
	    }
	}
	else {
	    // Array 
	    out << "structure(c(";
	    for (int i = 0; i < length; ++i) {
		if (i > 0) {
		    out << ",";
		}
		writeValue(value[i], out, discrete);
	    }
	    out << "), .Dim = ";
	    if (named) {
		out << "structure(";
	    }
	    out << "c(";
	    for (unsigned int j = 0; j < dim.size(); ++j) {
		if (j > 0) {
		    out << ",";
		}
		out << dim[j] << "L";
	    }
	    out << ")";
	    if (named) {
		std::vector<std::string> const &dnames = sarray.dimNames();
		out << ", .Names = c(";
		for (unsigned int k = 0; k < dnames.size(); ++k) {
		    if (k > 0) {
			out << ",";
		    }
		    out << "\"" << dnames[k] << "\"";
		}
		out << "))";
	    }
	    out << ")";
	}
    }

    out << "), \n.Names = c(";
    for (p = data_table.begin(); p != data_table.end(); ++p) {
	if (p != data_table.begin()) {
	    out << ", ";
	}
	std::string const &name = p->first;
	out << "\"" << name << "\"";
    }
    out << "))";
    out.close();
}

void setParameters(ParseTree *p, std::vector<ParseTree*> *parameters)
{
  /* 
     The parser dynamically allocates vectors of (pointers to)
     parameters. These vectors must be deleted when we are done with
     them.
  */
  p->setParameters(*parameters);
  delete parameters; 
}

void setParameters(ParseTree *p, ParseTree *param1)
{
  /*
    Wrapper function that creates a vector containing param1
    to be passed to ParseTree::setParameters.
  */
  std::vector<ParseTree *> parameters(1, param1);
  p->setParameters(parameters);
}

void setParameters(ParseTree *p, ParseTree *param1, ParseTree *param2)
{
  /*
    Wrapper function that creates a vector containing param1
    and param2, to be passed to ParseTree::setParameters
  */
  std::vector<ParseTree *> parameters;
  parameters.push_back(param1);
  parameters.push_back(param2);
  p->setParameters(parameters);
}

void setName(ParseTree *p, std::string *name)
{
  p->setName(*name);
  delete name;
}

static void errordump()
{
  if (console->model()) {
    std::ostringstream fname;
    for (unsigned int i = 1; i <= console->nchain(); ++i) {
       fname << "jags.dump" << i << ".R";
       std::cout << "Dumping chain " << i << " at iteration " 
                 << console->iter() << " to file " << fname.str() << std::endl;
       doDump(fname.str(), DUMP_ALL, i);
       fname.str("");
    }
  }
}

static void updatestar(long niter, long refresh, int width)
{
    bool adapt = console->isAdapting();
	
    if (refresh == 0) {
	console->update(niter/2);
	bool status = true;
	if (adapt && !console->adaptOff(status)) {
	    errordump();
	    return;
	}
	console->update(niter - niter/2);
	if (!status) {
	    std::cerr << "WARNING: Adaptation incomplete\n";
	}
	return;
    }

    if (width > niter / refresh + 1)
	width = niter / refresh + 1;

    std::cout << "Updating " << niter << std::endl;
    for (int i = 0; i < width - 1; ++i) {
	std::cout << "-";
    }
    std::cout << "| " << std::min(width * refresh, niter) << std::endl 
	      << std::flush;

    int col = 0;
    bool status = true;
    for (long n = niter; n > 0; n -= refresh) {
	if (adapt && n <= niter/2) {
	    // Turn off adaptive mode half way through burnin
	    if (console->adaptOff(status)) {
		adapt = false;
	    }
	    else {
		std::cout << std::endl;
		errordump();
		return;
	    }
	}
	long nupdate = std::min(n, refresh);
	if(console->update(nupdate))
	    std::cout << "*" << std::flush;
	else {
	    std::cout << std::endl;
	    errordump();
	    return;
	}
	col++;
	if (col == width || n <= nupdate) {
	    int percent = 100 - (n-nupdate) * 100/niter;
	    std::cout << " " << percent << "%" << std::endl;
	    if (n > nupdate) {
		col = 0;
	    }
	}
    }
    if (!status) {
	std::cerr << "WARNING: Adaptation incomplete\n";
    }
}

static void adaptstar(long niter, long refresh, int width)
{
    if (!console->isAdapting()) {
	std::cerr << "NOTE: Model is not in adaptive mode\n";
    }
	
    bool status = true;
    if (refresh == 0) {
	console->update(niter);
	if (!console->adaptOff(status)) {
	    errordump();
	    return;
	}
	if (!status) {
	    std::cerr << "WARNING: Adaptation incomplete\n";
	}
	return;
    }

    if (width > niter / refresh + 1)
	width = niter / refresh + 1;

    std::cout << "Adapting " << niter << std::endl;
    for (int i = 0; i < width - 1; ++i) {
	std::cout << "-";
    }
    std::cout << "| " << std::min(width * refresh, niter) << std::endl 
	      << std::flush;

    int col = 0;
    for (long n = niter; n > 0; n -= refresh) {
	long nupdate = std::min(n, refresh);
	if(console->update(nupdate))
	    std::cout << "+" << std::flush;
	else {
	    std::cout << std::endl;
	    errordump();
	    return;
	}
	col++;
	if (col == width || n <= nupdate) {
	    int percent = 100 - (n-nupdate) * 100/niter;
	    std::cout << " " << percent << "%" << std::endl;
	    if (n > nupdate) {
		col = 0;
	    }
	}
    }
    if (!console->adaptOff(status)) {
	std::cout << std::endl;
	errordump();
	return;
    }
    if (!status) {
	std::cerr << "WARNING: Adaptation incomplete\n";
    }
}

static void loadModule(std::string const &name)
{
    lt_dlhandle mod = lt_dlopenext(name.c_str());
    if (mod == NULL) {
	std::cout << lt_dlerror() << std::endl;
    }
    else {
	std::cout << "Loading module: " << name << std::endl;
	_dyn_lib.push_front(mod);
	Console::loadModule(name);
    }
}

static void unloadModule(std::string const &name)
{
    std::cout << "Unloading module: " << name << std::endl;
    Console::unloadModule(name);
}

int main (int argc, char **argv)
{
  extern std::FILE *zzin;

  std::FILE *cmdfile = 0;
  if (argc > 2) {
    std::cerr << "Too many arguments" << std::endl;
  }
  else if (argc == 2) {
    interactive = false;
    cmdfile = std::fopen(ExpandFileName(argv[1]).c_str(),"r");
    if (cmdfile) {
      zzin = cmdfile;
    }
    else {
      std::cerr << "Unable to open command file " << argv[1] << std::endl;
      return 1;
    }
  }
  else {
    interactive = true;
  }

#ifndef WIN32
  /* 
     - Allows emulation of dynamic loading on platforms that do not
     support it by preloading modules. 
     - Causes build failures on mingw-w64 (as at 21 April 2010) so
     not used on Windows platform.
  */
  LTDL_SET_PRELOADED_SYMBOLS();
#endif

  if(lt_dlinit()) {
      std::cerr << lt_dlerror() << std::endl;
      return 1;
  }

  /*
  pt2Func load_base = (pt2Func)(lt_dlsym(base, "load"));
  if (load_base == NULL) {
      std::cout << lt_dlerror() << std::endl;
      return 1;
  }
  else{
      (*load_base)();
  }
  */
  
  time_t t;
  time(&t);
  std::cout << "Welcome to " << PACKAGE_STRING << " on " << ctime(&t);
  std::cout << "JAGS is free software and comes with ABSOLUTELY NO WARRANTY" 
            << std::endl;
  loadModule("basemod");
  loadModule("bugs");

  console = new Console(std::cout, std::cerr);

  zzparse();
  zzlex_destroy();

  if (argc==2) {
      std::fclose(cmdfile);
  }
  
  //Unload modules
  std::vector<std::string> mods = Console::listModules();
  for (unsigned int i = 0; i < mods.size(); ++i) {
      Console::unloadModule(mods[i]);
  }
  delete console;
  //Release dynamic libraries. 
  for (unsigned int i = 0; i < _dyn_lib.size(); ++i) {
      lt_dlclose(_dyn_lib[i]);
  }
  lt_dlexit();
}

static bool getWorkingDirectory(std::string &name)
{
    char buf[FILENAME_MAX];
#ifdef Win32
    if (getCurrentDirectory(FILENAME_MAX, buf)) {
	name = buf;
	return true;
    }
    else {
	name = "Error in getCurrentDirectory";
	return false;
    }
#else
    if (getcwd(buf, FILENAME_MAX)) {
	name = buf;
	return true;
    }
    else {
	switch(errno) {
	case EACCES:
	    name = "Access denied";
	    break;
	case ENOENT:
	    name = "Not found";
	    break;
	case ERANGE:
	    name = "Directory name too long";
	    break;
	default:
	    name = "Error in getcwd";
	    break;
	}
	return false;
    }
#endif
}

static void dumpSamplers(std::string const &file)
{
    std::ofstream out(file.c_str());
    if (!out) {
	std::cerr << "Failed to open file " << file << std::endl;
	return;
    }

    std::vector<std::vector<std::string> > sampler_list;
    console->dumpSamplers(sampler_list);
    for (unsigned int i = 0; i < sampler_list.size(); ++i) {
	for (unsigned int j = 1; j < sampler_list[i].size(); ++j) {
	    out << i + 1 << "\t" 
		<< sampler_list[i][0] << "\t" //First element is sampler name
		<< sampler_list[i][j] << "\n"; //Rest are node names
	}
    }

    out.close();
}

static void delete_pvec(std::vector<ParseTree*> *pv)
{
    for (unsigned int i = 0; i < pv->size(); ++i) {
	delete (*pv)[i];
    }
    delete pv;
}

static void print_unused_variables()
{
    std::vector<std::string> data_vars;
    for (std::map<std::string, SArray>::const_iterator p = _data_table.begin();
	 p != _data_table.end(); ++p)
    {
	data_vars.push_back(p->first);
    }
    
    std::vector<std::string> unused_vars;
    std::vector<std::string> const &model_vars = console->variableNames();

    std::set_difference(data_vars.begin(), data_vars.end(),
			model_vars.begin(), model_vars.end(),
			std::inserter(unused_vars, unused_vars.begin()));

    if (!unused_vars.empty()) {
	std::cerr << "\nWARNING: Unused variable(s) in data table:\n";
	std::copy(unused_vars.begin(), unused_vars.end(),
		  std::ostream_iterator<std::string>(std::cerr, "\n"));
	std::cerr << "\n";
    }

}

std::string ExpandFileName(char const *s)
{
    if(s[0] != '~') return s;
    std::string name = s;
    if(name.size() > 1 && s[1] != '/') return s;

    char const *p = getenv("HOME");
    if (p) {
	std::string UserHOME = p;
	if (!UserHOME.empty()) {
	    if (name.size() == 1) 
		return UserHOME;
	    else
		return UserHOME + name.substr(1);
	}
    }
    return name;
}


void doSystem(std::string const *command)
{
    std::system(command->c_str());
}

void listFactories(FactoryType type)
{
    std::vector<std::pair<std::string, bool> > faclist = 
	Console::listFactories(type);

    std::vector<std::pair<std::string, bool> >::const_iterator p;
    unsigned int max_strlen = 0;
    for (p = faclist.begin(); p != faclist.end(); ++p) {
	if (p->first.length() > max_strlen)
	    max_strlen = p->first.length();
    }
    if (max_strlen < 4)
	max_strlen = 4;

    //Header
    std::cout << "Name";
    for (int i = max_strlen - 4; i >=0; --i) {
	std::cout << " ";
    }
    std::cout << "Status\n";

    //Body
    for (p = faclist.begin(); p != faclist.end(); ++p) {
	std::cout << p->first << " ";
	for (int i = max_strlen - p->first.length(); i >= 0; --i) {
	    std::cout << " ";
	}
	if (p->second) {
	    std::cout << "on";
	}
	else {
	    std::cout << "off";
	}
	std::cout << "\n";
    }
}

void setFactory(std::string const &name, FactoryType type, 
		std::string const &status)
{
    if (status == "on") {
	Console::setFactoryActive(name, type, true);
    }
    else if (status == "off") {
	Console::setFactoryActive(name, type, false);
    }
    else {
	std::cout << "status should be \"on\" or \"off\"";
    }
}
	    

