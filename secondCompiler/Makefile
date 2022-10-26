all: parser

lexer: lexer_standalone.l
	flex lexer_standalone.l
	gcc -o lexer_standalone lex.yy.c
	./lexer_standalone testProg.cmm
# lexer: lexer.l
# 	flex lexer.l
# 	gcc -o lexer.l lex.yy.c
# 	./lexer.l textProg.cmm

parser.tab.c parser.tab.h:	parser.y
	bison -t -v -d --graph -x parser.y
	bison --print-datadir
	xsltproc /usr/share/bison/xslt/xml2xhtml.xsl parser.xml >parser.html

lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

parser: lex.yy.c parser.tab.c parser.tab.h symbolTable.h AST.h
	gcc -o parser parser.tab.c lex.yy.c
	./parser testProg.cmm

clean:
	rm -f parser lexer parser.tab.c lex.yy.c parser.tab.h parser.output
	rm -f parser lexer parser.gv parser.html parser.ps parser.xml lexer_standalone
	ls -l