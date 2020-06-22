%{
    #include <errno.h>
    #include <stdlib.h>
    #include <stdio.h>
    #include <ctype.h>

    struct Node{
      char* val;
      int tipo;
      int base;
      int result;
      int size;
      struct Node* right;
      struct Node* left;
    };

    struct Node* initNode(char* value, int size, int tipo){
      struct Node* node = (struct Node*) malloc (sizeof(struct Node));
      node->val = value;
      node->size = size;
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
      printf("%s ", nodo->val);
      printTree(nodo->left,space);
      printf("\n");
    }
  
    int definirBase(char* base){
      return base[0] == '0' ? 8 : 10;
    }
    
    int numVal(int base, char* number, int size){
      int result = 0;
      int power = 1;
      int num = 0;
      for (int i = size -1; i >= 0 ; i-- ) {
        num = number[i] - '0';
        if(num >= base){ return NULL; }
        result += num * power;
        power = power * base;
      }
      return result;
    }

    int eval(struct Node* root){
      switch (root->tipo){
        case 0:
          if(root->right){
            eval(root->left);
            int base = root->left->base;
            root->base = base == 8 ? base : 10;
            int result = numVal(root->base, root->val, root->size);
            if(result){ root->result = result; }
            else { printf("Invalid number, digit too big for base\n"); return -1; }
          }
          else {
            eval(root->left);
            root->base = 10;
            root->result = numVal(root->base,root->left->val,1);
          }
          break;
        case 1:
          root->base = definirBase(root->left->val);          
          break;
      }
      return 0;
    }
%}

%code requires{
  struct s{
    char* val;
    int size;
  };
}

%union
{
  struct Node* nodo;
  char* digit;
  struct s sval;
}
%token<sval> NUMBER
%type<nodo> numero
%type<nodo> base
%type<nodo> num
%type<nodo> digito

%start command
%%
command: numero {
                 printTree($1, 2);
                 if(eval($1) == -1){yyerrok;} else { printf("Base is %d and final number is %d\n", $1->base, $1->result); };
              }
                    ;
numero: base num {
                  int size = $1->size + $2->size;
                  char* fullNum = (char*) malloc (size);
                  fullNum[0] = $1->val[0];
                  for(int i=1;i<size;i++) fullNum[i]=$2->val[i-1];
                  $$ = initNode(fullNum, size, 0);
                  $$->left = $1;
                  $$->right = $2;
                    }
        |
        digito {
                  $$ = initNode($1->val, 1, 0);
                  $$->left = $1;
               };

base: digito   {
                  $$ = initNode($1->val, 1, 1);
                  $$->left = $1;
               };

num: digito num {
                  int size = $1->size + $2->size;
                  char* fullNum = (char*) malloc (size);
                  fullNum[0]=$1->val[0];
                  for(int i=1;i<size;i++) fullNum[i]=$2->val[i-1];
                  $$ = initNode(fullNum, size, 2);
                  $$->left = $1;
                  $$->right = $2;
                }
     |
     digito {
                  $$ = initNode($1->val, 1, 2);
                  $$->left = $1;
            };

digito: NUMBER  {
                  char* input = (char*) malloc (1);
                  input[0] = $1.val[0];
                  $$ = initNode(" ", 1, 3); 
                  $$->val = input;
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
