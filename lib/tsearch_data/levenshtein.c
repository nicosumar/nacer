/*****************************************************/
/*Function prototypes and libraries needed to compile*/
/*****************************************************/

#include <stdlib.h>
#include <malloc.h>
#include <string.h>
#include <ctype.h>
int levenshtein_distance(char *s,char*t);
int minimum(int a,int b,int c);

void main()
{
  char linea[100];
  char *lista_ary[25000];
  int j, k, primero, alguno;
  float lev;
  int i = 0;
  FILE *lista = fopen("lista_nueva.txt", "r");
  FILE *tesauro = fopen("tesauro_nombres.txt", "w");
  FILE *xsyn = fopen("xsyn.txt", "w");

  /* Cargar la lista en memoria */
  while ( !feof(lista) )
  {
    fgets(linea, 100, lista);
    if ( strlen(linea) > 1 )
    {
      lista_ary[i] = (char *) malloc(strlen(linea));
      memcpy(lista_ary[i], linea, strlen(linea) - 1);
      lista_ary[i][strlen(linea)] = '\0';
      i++;
    }
  }

  for ( j = 0; j < i - 1; j++ )
  {
    primero = -1;
    alguno = 0;
    for ( k = 0; k < i - 1; k++ )
    {
      if ( strlen(lista_ary[j]) <= strlen(lista_ary[k]) )
        lev = (float) levenshtein_distance(lista_ary[j], lista_ary[k]) / ((float) strlen(lista_ary[j]) - 0.5) * (1.0 + (float) (strlen(lista_ary[k]) - strlen(lista_ary[j])) / 10.0);
      else
        lev = (float) levenshtein_distance(lista_ary[j], lista_ary[k]) / ((float) strlen(lista_ary[k]) - 0.5) * (1.0 + (float) (strlen(lista_ary[j]) - strlen(lista_ary[k])) / 10.0);
      if ( lista_ary[j][0] != lista_ary[k][0] )
        lev *= 1.33;

      if ( lev < 0.334 )
      {
        alguno = -1;
        if ( primero )
        {
	  if ( j == k )
            fprintf(tesauro, "%s : *%s", lista_ary[j], lista_ary[j]);
	  else
	  {
	    fprintf(xsyn, "%s %s", lista_ary[j], lista_ary[k]);
            primero = 0;
	  }
        }
        else
	{
	  if ( j != k )
            fprintf(xsyn, " %s", lista_ary[k]);
	}
      }
    }
    if ( alguno )
      fprintf(tesauro, "\n");
      fprintf(xsyn, "\n");
  }
}

/****************************************/
/*Implementation of Levenshtein distance*/
/****************************************/

int levenshtein_distance(char *s,char*t)
/*Compute levenshtein distance between s and t*/
{
  //Step 1
  int k,i,j,n,m,cost,*d,distance;
  n=strlen(s); 
  m=strlen(t);
  if(n!=0&&m!=0)
  {
    d=malloc((sizeof(int))*(m+1)*(n+1));
    m++;
    n++;
    //Step 2
    for(k=0;k<n;k++)
      d[k]=k;
    for(k=0;k<m;k++)
      d[k*n]=k;
    //Step 3 and 4
    for(i=1;i<n;i++)
      for(j=1;j<m;j++)
      {
        //Step 5
        if(s[i-1]==t[j-1])
          cost=0;
        else
          cost=1;
        //Step 6 
        d[j*n+i]=minimum(d[(j-1)*n+i]+1,d[j*n+i-1]+1,d[(j-1)*n+i-1]+cost);
      }
    distance=d[n*m-1];
    free(d);
    return distance;
  }
  else 
    return -1; //a negative return value means that one or both strings are empty.
}

int minimum(int a,int b,int c)
/*Gets the minimum of three values*/
{
  int min=a;
  if(b<min)
    min=b;
  if(c<min)
    min=c;
  return min;
}

