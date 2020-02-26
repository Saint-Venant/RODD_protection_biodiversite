/*********************************************
 * OPL 12.9.0.0 Model
 * Author: Matthieu Roux
 * Creation Date: 5 févr. 2020 at 15:31:18
 *********************************************/

 int N = ...; // nombre total d'individus
 int Nm = ...; // nombre d'individus mâles
 int Nf = ...; // nombre d'individus femelles
 int C = ...;
 int G = ...; // nombre de gènes
 int A = ...; // nombre d'allèles par gène
 int T = ...;
 float init = ...;
 
 int individu[1..N][1..C][1..G][1..2] = ...;
 
 // Par la suite on ne considèrera qu'un seul chromosome !
 
 // ensemble des individus ayant 2 allèles k identiques pour le gène i
 {int} E2[i in 1..G][k in 1..A] = { j | j in 1..N : (individu[j][1][i][1] == k) && (individu[j][1][i][2] == k) };
 // ensemble des individus ayant une seule copie de l'allèle k du gène i
 {int} E1[i in 1..G][k in 1..A] = { j | j in 1..N : ((individu[j][1][i][1] == k) || (individu[j][1][i][2] == k)) && (individu[j][1][i][1] != individu[j][1][i][2]) };
 
 // ensemble des theta_r
 float theta[r in 1..T] = pow(init, (T-r)/(T-1));
 float ln2 = ln(2);
 
 
 dvar int+ x[j in 1..N];
 dvar float+ z[i in 1..G][k in 1..A];
 dvar float+ t[i in 1..G][k in 1..A];
 
 minimize sum(i in 1..G, k in 1..A) z[i][k];
 
 subject to {
 	ctz: forall(i in 1..G, k in 1..A) z[i][k] >= t[i][k] - sum(j in E2[i][k]) x[j];
 	
 	ctt: forall(i in 1..G, k in 1..A, r in 1..T) ln(theta[r]) + (t[i][k] - theta[r])/theta[r] >= -ln2*sum(j in E1[i][k]) x[j];
 	
 	ctmf: sum(j in 1..Nm) x[j] == sum(j in (Nm+1)..N) x[j];
 	
 	ctStability: sum(j in 1..N) x[j] == 2*N;
 	
 	ctMax: forall(j in 1..N) x[j] <= 3;
 }
 
 float value = sum(i in 1..G, k in 1..A) z[i][k];
 float ub = 0;
 
 execute{ 
 	for (var i=1; i<=G; i++) {
 		for (var k=1; k<=A; k++) {
 			var zz = 1;
 			for (var j in E2[i][k]) {
 				if (x[j] > 0) {
 					zz = 0;
 					break; 				
 				}	
 			}
 			for (var j in E1[i][k]) {
 				zz *= Math.pow(0.5, x[j]); 			
 			}
 			ub += zz;
 			writeln(zz);
 		} 	
 	}
 
	var stat = cplex.status;
	writeln("status = " + stat);
	writeln("value = " + value);
	writeln("upper bound = " + ub);
}