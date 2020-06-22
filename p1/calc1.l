%{
#include <stdio.h>
#include "y.tab.h"
%}
%%

[0-9]     {
            struct s digit = {yytext, 1};
            yylval.sval = digit;
            return(NUMBER);
          }
\n       {return 0;}
.        {return 0;}
