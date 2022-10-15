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
NUMBER      {digit}+(\.{digit}+)?(E[+\-]?(digit)+)?
ws          {delim}+

%%
"/*"    				{
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
			
{NUMBER}		{words++; chars += strlen(yytext);
			  printf("%s : NUMBER\n",yytext);
			  yylval.number = atoi(strdup(yytext)); 
			  return NUMBER;
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
		  printf("%s : AddOp\n", yytext);
		  yylval.string = strdup(yytext); 
		  return AddOp;
		}

"-"		{chars++;
		  printf("%s : SubOp\n", yytext);
		  yylval.string = strdup(yytext); 
		  return SubOp;
		}

"/"		{chars++;
		  printf("%s : DivOp\n", yytext);
		  yylval.string = strdup(yytext); 
		  return DivOp;
		}

"*"		{chars++;
		  printf("%s : MultOp\n", yytext);
		  yylval.string = strdup(yytext); 
		  return MultOp;
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
		  return LBRACKET;
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
		
[\n]	{lines++; chars=0;}
[ \t]	{chars++;}
.		{chars++;
         printf("%s : Unrecognized symbol at line %d char %d\n", yytext,lines,chars);
		}
		

%%