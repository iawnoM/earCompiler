%option noyywrap

%{
#include <stdio.h>
#include <string.h>

#define YY_DECL int yylex()
#include "parser.tab.h"

int words = 0;
int chars = 0;
int lines = 0;

%}

letter      [a-zA-Z]
digit       [0-9]
ID          {letter}({letter}|{digit})*
delim       [ \t\n]
INTEGER     {digit}?
FLOAT       {digit}+(\.{digit}+)?(E[+\-]?(digit)+)?
ws          {delim}+
CHARACTER   ["'"]({letter}|{digit})["'"]

%%
"/*"   {
		int c;
		while((c = input()) != 0) {
			if(c == '*') {
				if((c = input()) == '/')
					break;
				else
					unput(c);
			}
		}
	}
						
"int"	{words++; chars += strlen(yytext);
			printf("%s : TYPE\n", yytext);
			yylval.string = strdup(yytext); 
			return TYPE;
		}

"char"	{words++; chars += strlen(yytext);
			printf("%s : TYPE\n", yytext);
			yylval.string = strdup(yytext); 
			return TYPE;
		}

"float"	{words++; chars += strlen(yytext);
			printf("%s : TYPE\n", yytext);
			yylval.string = strdup(yytext); 
			return TYPE;
		}

"write"	{words++; chars += strlen(yytext);
			printf("%s : KEYWORD\n", yytext);
			yylval.string = strdup(yytext); 
			return WRITE;
		}


{ID}	{words++; chars += strlen(yytext);
			  printf("%s : IDENTIFIER\n",yytext);
			  yylval.string = strdup(yytext); 
			  return ID;
			}
			
{INTEGER}	{words++; chars += strlen(yytext);
			  printf("%s : INTEGER\n",yytext);
			  yylval.number = atoi(strdup(yytext)); 
			  return INTEGER;
			}

{CHARACTER}	 {
	words++; chars += strlen(yytext);
	printf("%s : IDENTIFIER\n",yytext);
	yylval.string = strdup(yytext); 
	return CHARACTER;
}

{FLOAT}		{words++; chars += strlen(yytext);
			printf("%s : FLOAT\n",yytext);
			  yylval.number = atoi(strdup(yytext)); 
			  return FLOAT;
			}

";"		{chars++;
		  printf("%s : SEMICOLON\n", yytext);
		  yylval.string = strdup(yytext); 
		  return SEMICOLON;
		}
		
"="		{chars++;
		  printf("%s : EQ\n", yytext);
		  yylval.string = strdup(yytext); 
		  return EQ;
		}

"+"		{chars++;
		  printf("%s : BinOp\n", yytext);
		  yylval.string = strdup(yytext); 
		  return BinOp;
		}

"-"		{chars++;
		  printf("%s : BinOp\n", yytext);
		  yylval.string = strdup(yytext); 
		  return BinOp;
		}

"/"		{chars++;
		  printf("%s : BinOp\n", yytext);
		  yylval.string = strdup(yytext); 
		  return BinOp;
		}

"*"		{chars++;
		  printf("%s : BinOp\n", yytext);
		  yylval.string = strdup(yytext); 
		  return BinOp;
		}

"{"		{chars++;
		  printf("%s : LBRACE\n", yytext);
		  yylval.string = strdup(yytext); 
		  return LBRACE;
		}

"}"		{chars++;
		  printf("%s : RBRACE\n", yytext);
		  yylval.string = strdup(yytext); 
		  return RBRACE;
		}

"["		{chars++;
		  printf("%s : LBRACKET\n", yytext);
		  yylval.string = strdup(yytext); 
		  return LBRACKET;
		}

"]"		{chars++;
		  printf("%s : RBRACKET\n", yytext);
		  yylval.string = strdup(yytext); 
		  return RBRACKET;
		}

"("		{chars++;
		  printf("%s : LPAREN\n", yytext);
		  yylval.string = strdup(yytext); 
		  return LPAREN;
		}

")"		{chars++;
		  printf("%s : RPAREN\n", yytext);
		  yylval.string = strdup(yytext); 
		  return RPAREN;
		}

"'"		{chars++;
		  printf("%s : APOST\n", yytext);
		  yylval.string = strdup(yytext); 
		  return APOST;
		}
		
[\n]	{lines++; chars=0;}
[ \t]	{chars++;}
.		{chars++;
         printf("%s : Unrecognized symbol at line %d char %d\n", yytext,lines,chars);
		}
		

%%