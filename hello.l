/*** Definition Section ***/
%{

int count = 0;

%}

DIG0    [0-9]
DIG     [1-9]
LTR     [A-Za-z]
ID      ({LTR}|_)({LTR}|{DIG0}|_)*
ENT     -?{DIG0}+
DEC     -?{DIG0}+[.]{DIG0}*
ELV     ({ENT}|{DEC})e{ENT}
IMG     ({ENT}|{DEC})(j|J)
CNT     [^'^"^,^\n]*
STR     (\'CNT\')|(\"CNT\")
CMT     \#.*\n



/*** Rule Section ***/
%%

{ID} {
    printf("%s : Una variable\n", yytext);
}

{ENT} {
    printf("%s : Un numero entero\n", yytext);
}

{IMG} {
    printf("%s : Un numero imaginario\n", yytext);
}

{DEC} {
printf("%s : Un numero decimal\n", yytext);
}

{ELV} {
printf("%s : Un numero elevado\n", yytext);
}

{STR} {
printf("%s : Una string\n", yytext);
}

{CMT} {
printf("%s : Un comentario\n", yytext);
}

. {
    //printf("%s : Not a variable\n", yytext);
}

\n {
    return 0;
}

\s {

};

%%
/*** Code Section ***/

int yywrap(){
    return 1;
}

int main(){

// Explanation:
// yywrap() - wraps the above rule section
/* yyin - takes the file pointer
		which contains the input*/
/* yylex() - this is the main flex function
		which runs the Rule Section*/
// yytext is the text in the buffer

// Uncomment the lines below
// to take input from file
// FILE *fp;
// char filename[50];
// printf("Enter the filename: \n");
// scanf("%s",filename);
// fp = fopen(filename,"r");
// yyin = fp;

    yylex();
//    printf("\nNumber of Captial letters in the given input - %d\n", count);

    return 0;
}
