/*********************************************
 * OPL 12.9.0.0 Model
 * Author: Matthieu Roux
 * Creation Date: 22 janv. 2020 at 15:11:00
 *********************************************/

int m = ...;
int n = ...;
int p = ...;
int q = ...;

range rares = 1..p;
range communes = (p+1)..(p+q);
range especes = 1..(p+q);

float alpha[especes] = ...;
float proba[especes][i in 1..m][j in 1..n] = ...;
int c[i in 1..m][j in 1..n] = ...;

dvar boolean x[i in 1..m][j in 1..n];
dvar boolean y[i in 2..(m-1)][j in 2..(n-1)];

minimize sum(i in 1..m, j in 1..n) c[i,j]*x[i,j];

subject to{

	forall(k in communes)
   	  ctPresenceCommunes: sum(i in 1..m, j in 1..n) ln(1-proba[k,i,j])*x[i,j] <= ln(1-alpha[k]);
   	
   	forall(k in rares)
   	  ctPresenceRares: sum(i in 2..(m-1), j in 2..(n-1)) ln(1-proba[k,i,j])*y[i,j] <= ln(1-alpha[k]);
   	
   	forall(i in 2..(m-1), j in 2..(n-1), e1 in -1..1, e2 in -1..1)
   	  ctParcellesCentrales:  y[i,j] <= x[i+e1,j+e2];
}

float value = sum(i in 1..m, j in 1..n) c[i,j]*x[i,j];
float survieRares[k in rares] = 1 - exp(sum(i in 2..(m-1), j in 2..(n-1)) ln(1-proba[k,i,j])*y[i,j]);
float survieCommunes[k in communes] = 1 - exp(sum(i in 1..m, j in 1..n) ln(1-proba[k,i,j])*x[i,j]);

execute{
	var stat = cplex.status;
	writeln("status = " + stat);
	writeln("value = " + value);
	writeln("survie especes rares = " + survieRares);
	writeln("survie especes communes = " + survieCommunes);
}