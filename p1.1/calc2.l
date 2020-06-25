%{
#include <stdio.h>
#include "y.tab.h"
%}
%%

[0-9]     {
            yylval.digit = atoi(yytext);
            if (yylval.digit == 0) { return(ZERO); }
            return(NUMBER);
          }

\n       {return 0;}
.        {return 0;}
