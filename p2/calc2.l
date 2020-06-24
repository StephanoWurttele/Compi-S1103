%{
#include <stdio.h>
#include "y.tab.h"
%}
%%

[0-9]     {
            yylval.digit = atoi(yytext);
            return(NUMBER);
          }

o        {return(o);}

d        {return(d);}

\n       {return 0;}
.        {return 0;}
