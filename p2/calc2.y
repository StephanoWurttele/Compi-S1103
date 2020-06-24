%{
    #include <errno.h>
    #include <stdlib.h>
    #include <stdio.h>
    #include <ctype.h>

    struct Node{
      int val;
      int base;
      int tipo;
      struct Node* right;
      struct Node* left;
    };

    struct Node* initNode(int value, int tipo){
      struct Node* node = (struct Node*) malloc (sizeof(struct Node));
      node->val = value;
      node->tipo = tipo;
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
      printf("%d ", nodo->val);
      printTree(nodo->left,space);
      printf("\n");
    }

    int eval(struct Node* root){
      switch (root->tipo){
        case 0:
          root->left->base = root->base;
          if(eval(root->left)==-1){ return -1; };
          root->val = root->left->val;
          break;
        case 1:
          root->left->base = root->base;
          if(root->right){
            root->right->base = root->base;
            if (eval(root->right) == -1){ return -1; }
            if (eval(root->left) == -1){ return -1; }
            root->val = root->right->val + root->left->val * root->base;
          }
          else {
            if (eval(root->left) == -1){ return -1; }
            root->val = root->left->val;
          }
          break;
        case 2:
          if(root->val >= root->base) { return -1; }
          break;
      }
      return 0;
    }
%}

%union
{
  struct Node* nodo;
  int digit;
}
%token<digit> NUMBER
%token<digit> o
%token<digit> d
%type<digit> carbase
%type<nodo> num
%type<nodo> numbase
%type<nodo> digito

%start numbase
%%

numbase: num carbase {
                  $$ = initNode(0, 0);
                  $$->base = $2;
                  $$->left = $1;
                  if(eval($$) == -1){printf("Digit to big for base\n"); yyerrok;} else { printf("Base is %d and final number is %d\n", $$->base, $1->val); printTree($1,2); };
                    };

carbase: o {
            $$ = 8;
           }
       |
         d {
            $$ = 10;
           };

num: num digito{
                  $$ = initNode(0, 1);
                  $$->left = $1;
                  $$->right = $2;
                }
     |
     digito {
                  $$ = initNode(0, 1);
                  $$->left = $1;
            };

digito: NUMBER  {
                  $$ = initNode($1, 2);
                } ;
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
