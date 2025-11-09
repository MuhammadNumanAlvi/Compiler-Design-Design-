%{
#include <stdio.h>
#include <string.h>

int line_number = 1;
FILE *fout;
%}

%%
"~"                             { fprintf(fout, "Line %d: END OF LINE - %s\n", line_number, yytext); }
"\n"                            { line_number++; }  
[ \t\r]+                        { /* Ignore whitespace */ }
(workspace|load|start|def|export|import|unit|duplicate|text|color|toggle|select|otherwise|repeat|loop|save|blend) { fprintf(fout, "Line %d: KEYWORD - %s\n", line_number, yytext); }
"!!"[^'\n']*                   { fprintf(fout, "Line %d: COMMENT (single-line) - %s\n", line_number, yytext); }

"!*"([^*]|\*[^!])*"\*!"         { fprintf(fout, "Line %d: COMMENT (multi-line) - %s\n", line_number, yytext); }


[@][a-zA-Z_][a-zA-Z0-9_]*  { fprintf(fout, "Line %d: IDENTIFIER - %s\n", line_number, yytext); }
[a-zA-Z_][a-zA-Z0-9_]*  { fprintf(fout, "Line %d: ERROR - %s (invalid identifier)\n", line_number, yytext); }



[0-9]+                          { fprintf(fout, "Line %d: INTEGER - %s\n", line_number, yytext); }
[0-9]*\.[0-9]+                  { fprintf(fout, "Line %d: FLOAT - %s\n", line_number, yytext); }

\"([^\"\n]*)\"                  { fprintf(fout, "Line %d: STRING - %s\n", line_number, yytext); }
\"[^\"\n]*\n                    { fprintf(fout, "Line %d: UNTERMINATED STRING - %s\n", line_number, yytext); }

\'[a-zA-Z0-9`!@#$%^&*()_+=\-;'.]\'  { fprintf(fout, "Line %d: CHAR - %s\n", line_number, yytext); }
\'.{2,}\'                       { fprintf(fout, "Line %d: INVALID CHAR - %s\n", line_number, yytext); }

"=="   { fprintf(fout, "Line %d: OPERATOR (assignment) - %s\n", line_number, yytext); }

"++"    { fprintf(fout, "Line %d: OPERATOR (addition) - %s\n", line_number, yytext); }
"--"    { fprintf(fout, "Line %d: OPERATOR (subtraction) - %s\n", line_number, yytext); }
"**"    { fprintf(fout, "Line %d: OPERATOR (multiply) - %s\n", line_number, yytext); }
"//"    { fprintf(fout, "Line %d: OPERATOR (divide) - %s\n", line_number, yytext); }
"%%"    { fprintf(fout, "Line %d: OPERATOR (mod) - %s\n", line_number, yytext); }
"!="    { fprintf(fout, "Line %d: OPERATOR (not equal) - %s\n", line_number, yytext); }
"\|\|"  { fprintf(fout, "Line %d: OPERATOR (or) - %s\n", line_number, yytext); }
"&&"    { fprintf(fout, "Line %d: OPERATOR (and) - %s\n", line_number, yytext); }
"!"     { fprintf(fout, "Line %d: OPERATOR (not) - %s\n", line_number, yytext); }
"<="    { fprintf(fout, "Line %d: OPERATOR (less than equal) - %s\n", line_number, yytext); }
">="    { fprintf(fout, "Line %d: OPERATOR (greater than equal) - %s\n", line_number, yytext); }
"<>"    { fprintf(fout, "Line %d: OPERATOR (not equal) - %s\n", line_number, yytext); }
"<"     { fprintf(fout, "Line %d: OPERATOR (less than) - %s\n", line_number, yytext); }
">"     { fprintf(fout, "Line %d: OPERATOR (greater than) - %s\n", line_number, yytext); }
"="     { fprintf(fout, "Line %d: OPERATOR (Equal) - %s\n", line_number, yytext); }


[{}(),\"':]   { fprintf(fout, "Line %d: PUNCTUATION - %s\n", line_number, yytext); }




.                       { fprintf(fout, "Line %d: ERROR - %s\n", line_number,
 yytext); }
 
 "\(\(:"      { fprintf(fout, "Line %d: OPERATOR (output) - %s\n", line_number, yytext); }
"\)\):"      { fprintf(fout, "Line %d: OPERATOR (input) - %s\n", line_number, yytext); }

%%

int yywrap(void) { return 1; }

int main() {
    fout = fopen("output.txt", "w");
    if (!fout) {
        printf("Error: Unable to open output.txt for writing.\n");
        return 1;
    }
    yylex();
    fclose(fout);
    printf("All tokens written to output.txt successfully!\n");
    return 0;
}

