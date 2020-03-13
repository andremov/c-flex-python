/*** Definition Section ***/
%{
#include<stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
char ids[300] = "";
int idCount = 0;
char ops[300] = "";
int opCount = 0;
char dels[300] = "";
int delCount = 0;
int errCount = 0;
char errStr[100] = "";
bool haveError = false;
void dumpErrorString();
int getIdNum();
int getOpNum();
int getDelNum();
%}

DIG             [0-9]
LTR             [A-Za-z]
SPACE           [ ]*

IDENTIFIER      ({LTR}|_)({LTR}|{DIG}|_)*

CHAR             [^'^"^,^\n]
STRING           ((\'{CHAR}*\')|(\"{CHAR}*\"))

NSIGN            [-]?
NINTEGER         {NSIGN}{DIG}+
NINTEGERL        {NINTEGER}[Ll]?

NENTERO          {NINTEGER}|{NINTEGERL}
NFLOAT         {NSIGN}(({DIG}+(\.){DIG}*)|({DIG}*(\.){DIG}+))
NDECIMAL         ({NFLOAT}([e]{NINTEGER})?)|({NINTEGER}[e]{NINTEGER})
NIMAGINARY       ({NINTEGER}|{NDECIMAL})[jJ]

KEYWORDS        (and|else|is|return|break|for|not|while|continue|if|or|def|import|pass|elif|in|print|True|False|range)

OPCOMPARISON    (~|<|>|<=|>=|==|!=|<>)
OPARITHMETIC    (\+|-|\*|\*\*|\/|\/\/|%|>>|<<|\^|\||&)
OPERATORS       ({OPCOMPARISON}|{OPARITHMETIC})

DELIMSEQ        ({OPARITHMETIC}?=)
DELIMSPUNCT     (;|,|:|\.|\(|\)|\[|\])
DELIMS          ({DELIMSEQ}|{DELIMSPUNCT})

COMMENT         (#.*)$

/*** Rule Section ***/
%%


{DELIMS} {
dumpErrorString();
fprintf(yyout,"del%d=%s ",getDelNum(yytext),yytext);
}

{OPERATORS} {
dumpErrorString();
    fprintf(yyout,"op%d=%s ",getOpNum(yytext),yytext);
}

{KEYWORDS} {
dumpErrorString();
fprintf(yyout,"%s ",strupr(yytext));
}

{STRING} {
dumpErrorString();
fprintf(yyout,"cadena=%s ",yytext);
}

{NENTERO} {
dumpErrorString();
fprintf(yyout,"entero=%s ",yytext);
}

{NDECIMAL} {
dumpErrorString();
fprintf(yyout,"decimal=%s ",yytext);
}

{NIMAGINARY} {
dumpErrorString();
fprintf(yyout,"imaginario=%s ",yytext);
}

{IDENTIFIER} {
dumpErrorString();
fprintf(yyout,"id%d=%s ",getIdNum(yytext),yytext);
}

{SPACE} {
dumpErrorString();
fprintf(yyout," ");
}

{COMMENT} {
dumpErrorString();
}

. {
    haveError = true;
    strcat(errStr, yytext);
}


\n {
dumpErrorString();
fprintf(yyout,"\n");
};

%%
/*** Code Section ***/

int yywrap() {}

void dumpErrorString() {
    if (haveError) {
        haveError = false;
        errCount = errCount + 1;
        fprintf(yyout,"ERROR%d=%s ", errCount, errStr);
        strcpy(errStr, "");
    }
}

int getDelNum(char *curIn){
    if (delCount == 0) {
        delCount = 1;
        strcat(dels, curIn);
    } else {
        char wrap[300] = "";
        strcat(wrap, dels);
        char *token = strtok(wrap, " ");
        int index = 0;
        while (token != NULL) {
            index = index + 1;
            if (strcmp(token, curIn) ==0) {
                return index;
            }
            token = strtok(NULL, " ");
        }
        delCount =delCount + 1;
        strcat(dels, " ");
        strcat(dels, curIn);
    }
    return delCount;
}

int getOpNum(char *curIn){
    if (opCount == 0) {
        opCount = 1;
        strcat(ops, curIn);
    } else {
        char wrap[300] = "";
        strcat(wrap, ops);
        char *token = strtok(wrap, " ");
        int index = 0;
        while (token != NULL) {
            index = index + 1;
            if (strcmp(token, curIn) ==0) {
                return index;
            }
            token = strtok(NULL, " ");
        }
        opCount =opCount + 1;
        strcat(ops, " ");
        strcat(ops, curIn);
    }
    return opCount;
}

int getIdNum(char *curIn){
    if (idCount == 0) {
        idCount = 1;
        strcat(ids, curIn);
    } else {
        char wrap[300] = "";
        strcat(wrap, ids);
        char *token = strtok(wrap, " ");
        int index = 0;
        while (token != NULL) {
            index = index + 1;
            if (strcmp(token, curIn) ==0) {
                return index;
            }
            token = strtok(NULL, " ");
        }
        idCount =idCount + 1;
        strcat(ids, " ");
        strcat(ids, curIn);
    }
    return idCount;
}

int main(int argc, char *argv[]){
    
    FILE *fp = fopen(argv[1], "r");
    FILE *out_file = fopen("salida.txt", "w");
    
    yyin = fp;
    yyout = out_file;
    
    yylex();

    fprintf(yyout,"\n");
    fprintf(yyout,"%d Identificadores\n", idCount);
    char wrap[300] = "";
    strcat(wrap, ids);
    char *token = strtok(wrap, " ");
    int index = 0;
    while (token != NULL) {
        index = index + 1;
        fprintf(yyout,"id%d=%s\n",index,token);
        token = strtok(NULL, " ");
    }

    fprintf(yyout,"%d Errores\n", errCount );

    fclose(yyin);
    //fclose(yyout);
    return 0;
}
