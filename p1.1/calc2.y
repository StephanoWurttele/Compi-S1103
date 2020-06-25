%{
    #include <errno.h>
    #include <stdlib.h>
    #include <stdio.h>
    #include <ctype.h>

    struct Node{
      int val;
      int base;
      struct Node* right;
      struct Node* left;
    };

    struct Node* initNode(int value, int base){
      struct Node* node = (struct Node*) malloc (sizeof(struct Node));
      node->val = value;
      node->base = base;
      node->right = NULL;
      node->left = NULL;
      return node;
    }


    void printTree(struct Node* nodo, int space){
      if(nodo == NULL) return(NULL);
      space += 10;
      printTree(nodo->right,space);
      printf("\n");
      for(int i=10; i<space; i++){
        printf(" ");
      };
      printf("Nodo->val = %d ", nodo->val);
      printTree(nodo->left,space);
      printf("\n");
    }

%}

%union
{
  struct Node* nodo;
  int digit;
}
%token<digit> NUMBER
%token<digit> ZERO
%type<nodo> octo
%type<nodo> deci
%type<nodo> numero

%start numero
%%

numero: ZERO octo {
                  printTree($2, 2);
                 }
       |
        deci {
                  printTree($1, 2);
        };

octo: 
    octo NUMBER{
                  $$ = initNode(0, 8);
                  $$->left = $1;
                  $$->right = initNode($2, 8);
                  $$->val = $1->val * $$->base + $$->right->val;
                }
     |
    octo ZERO{
                  $$ = initNode(0, 8);
                  $$->left = $1;
                  $$->right = initNode($2, 8);
                  $$->val = $1->val * $$->base + $$->right->val;
                }
     |
     NUMBER {
                  $$ = initNode($1, 8);
            }
     |
     ZERO {
                  $$ = initNode(0, 8);
            };

deci: 
    deci NUMBER{
                  $$ = initNode(0, 10);
                  $$->left = $1;
                  $$->right = initNode($2, 8);
                  $$->val = $1->val * $$->base + $$->right->val;
                }
     |
    deci ZERO{
                  $$ = initNode(0, 10);
                  $$->left = $1;
                  $$->right = initNode($2, 8);
                  $$->val = $1->val * $$->base + $$->right->val;
                }
     |
     NUMBER {
                  $$ = initNode($1, 10);
            }
     |
     ZERO {
                  $$ = initNode(0, 10);
            };
%%

int main(){
  do {
    yyparse();
  } while (!feof(stdin));
  return 0;
}

int yyerror(char *s){
    fprintf(stderr,"%s\n",s);
    return 0;
}

int yywrap(){
  return(1);
}
