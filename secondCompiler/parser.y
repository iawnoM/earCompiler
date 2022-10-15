%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "symbolTable.h"
#include "AST.h"
#include "IRcode.h"
#include "mipsCode.h"
#include "Calculator.h"

extern int yylex();
extern int yyparse();
extern FILE* yyin;
FILE * IRcode;

void yyerror(const char* s);
char currentScope[50]; // global or the name of the function
int semanticCheckPassed = 1; 
%}

%union {
	int number;
	char character;
	char* string;
	struct AST* ast;
}

%token <string> TYPE
%token <string> ID
%token <char> SEMICOLON
%token <char> EQ
%token <char> LBRACE
%token <char> RBRACE
%token <char> BinOp
%token <char> AddOp
%token <char> SubOp
%token <char> MultOp
%token <char> DivOp
%token <char> LBRACKET
%token <char> RBRACKET
%token <number> NUMBER
%token WRITE


%printer { fprintf(yyoutput, "%s", $$); } ID;
%printer { fprintf(yyoutput, "%d", $$); } NUMBER;

%type <ast> Program DeclList Decl VarDecl Stmt StmtList AddExpr Expr //Primary

%start Program

%%

/*	TODO for Parser:
	1. Reimpliment block type to work in functions
	2. Define functionalities for arrays 
	3. 
	*/


Program: 
	DeclList  {
		printf("Program started:\n");
		$$ = $1;
		//printf("left: %s %s | %s", $$->left, $$->left->LHS, $$->left->left);
		printAST($$, 3);

	}	
;

//TODO create FuncVar and FuncVarList

DeclList:	
	Decl DeclList	{ 

		// printf("\nTest debug DECLDECLLIST\n");
		$1->left = $2;
		$$ = $1;
	
	} | StmtList DeclList  { 

		// printf("Test debug STMTDECLLIST\n");
		$1->left = $2;
		$$ = $1;

	} | Decl {

		$$ = $1;

	}
;

Decl: 		
	VarDecl
	| StmtList
;

StmtList:	
	Stmt
	| Stmt StmtList {

		printf("-----Rule Found: StmtList------ | %s\n", $1->nodeType);
		$1->left = $2;
		$$ = $1;

	}
;

Stmt:	SEMICOLON	{}
	| Expr SEMICOLON	{

		printf("\n--------Valid Statement Found------- | \n");

		//AST
		$$ = $1;
	}
	//| WRITE Expr SEMICOLON { printf("\n RECOGNIZED RULE: WRITE statement\n");
	//			}
	/* | Block */
;

VarDecl:	
	TYPE ID SEMICOLON	{ 

		printf("\n RECOGNIZED RULE: Variable declaration %s\n", $2);

		// ----- Symbol Table ----- //
		symTabAccess();
		int inSymTab = found($2, currentScope);
		//printf("looking for %s in symtab - found: %d \n", $2, inSymTab);
		
		if (inSymTab == 0) 
			addItem($2, "Var", $1,0, currentScope);
		else
			printf("SEMANTIC ERROR: Var %s is already in the symbol table\n", $2);

		showSymTable();
		
		// ---- SEMANTIC ACTIONS by PARSER ---- //
		$$ = AST_Type("TYPE", $1, $2);
		//printf("--------> Node:%s, %s\n", $$->nodeType, $$->RHS);

	}
						
;

AddExpr:
	ID AddOp AddExpr {
		
		int idValue = getValue($1, currentScope);
		printf("idValue = %d\n", idValue);
		addNumToArray(idValue);
		//addNumToArray($3);

		// -------- SEMANTIC CHECK -------- //
		// printf("ID is an int! rv = %s", getNodeType($1, currentScope));
		if (strcmp(getNodeType($1, currentScope), "int") != 0) {
			semanticCheckPassed = 0;
		}

	}

	| NUMBER AddOp AddExpr {

		addNumToArray($1);
		
		// char sum[50];
		// sprintf(sum, "%d", returnSum());
		//returnSum();
	}

	| ID {

		//Get value of ID from symbol table
		int idValue = getValue($1, currentScope);
		addNumToArray(idValue);

		// -------- SEMANTIC CHECK -------- //
		//printf("ID is an int! rv = %s", getNodeType($1, currentScope));

		if (strcmp(getNodeType($1, currentScope), "int") != 0) {
			semanticCheckPassed = 0;
		}

	}

	| NUMBER {
		addNumToArray($1);
	}

;


Expr:	

	ID EQ AddExpr { 

		// Assign int value to char array
		char exprValue[50];
		sprintf(exprValue, "%d", returnSum()); //Get full addtion value

		clearNumArray(); 

		printf("\n RECOGNIZED RULE: Assignment statement\n"); 
		


		// -------- SYMBOL TABLE -------- //

		semanticCheckPassed = setItemValue($1, exprValue, currentScope);

		// -------- AST -------- //

		$$ = AST_assignment("=", $1, exprValue);

		// -------- CODE GENERATION -------- //

		if (semanticCheckPassed == 1) {
			printf("\n\n>>> AssignStmt Rule is SEMANTICALLY correct and IR code is emitted! <<<\n\n");

			// ---- EMIT IR 3-ADDRESS CODE ---- //
		
			// The IR code is printed to a separate file
			printf("\nEmmitting IR Code!\n");
			int idNum = getItemID($1, currentScope);
			// printf("%s id = %d", $1, idNum);
			emitConstantIntAssignment(idNum, exprValue);

			// ---- EMIT MIPS Code --- //
			emitMIPSConstantIntAssignment(idNum, exprValue);

		}

	}
	
	| WRITE ID 	{ 
		printf("\nRECOGNIZED RULE: WRITE statement");

		// --------- AST -------- //
		$$ = AST_Write("write",$2,"");
		
		// ---- SEMANTIC ANALYSIS ACTIONS ---- //  

		// Check if identifiers have been declared
		if(found($2, currentScope) != 1) {
			printf("SEMANTIC ERROR: Variable %s has NOT been declared in scope %s \n", $2, currentScope);
			semanticCheckPassed = 0;
		}

		if (semanticCheckPassed == 1) {
			printf("\n\nRule is semantically correct!\n\n");


			// ---- EMIT IR 3-ADDRESS CODE ---- //		
			int idNum = getItemID($2, currentScope);	
			emitWriteId(idNum);


			// ---- EMIT MIPS CODE ---- //
			// emitMIPSWriteId($2);
			emitMIPSWriteInt(idNum);
		}
	}

;



/* Block: LBRACE DeclList StmtList RBRACE{}
; */

%%

int main(int argc, char**argv)
{
/*
	#ifdef YYDEBUG
		yydebug = 1;
	#endif
*/
	printf("\n\n##### COMPILER STARTED #####\n\n");

	// Initialize IR File
	initIRcodeFile();

	// Initialize MIPS.h
	initAssemblyFile();
	
	if (argc > 1){
	  if(!(yyin = fopen(argv[1], "r")))
          {
		perror(argv[1]);
		return(1);
	  }
	}
	yyparse();

	printf("\n\n##### IR CODE EMMITED #####\n\n");
	printf("\n\n##### MIPS CODE EMMITED #####\n\n");
	printf("\n\n##### COMPILER CLOSING #####\n\n");
	
	emitEndOfAssemblyCode();
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}