/*********************************************
 * OPL 12.10.0.0 Model
 * Author: Guilhem
 * Creation Date: 29 janv. 2020 at 15:23:00
 *********************************************/

 int m =...;
 int n = ...;
 int B = ...;
 int Amin = ...;
 int Amax= ...;
 
 float lambda = ...;
 
 int c [1..m][1..n] = ...;
 float d [1..m][1..n][1..m][1..n];
 
 execute{
   for (var i=1; i<m+1; i++){
   	  for (var j=1; j<n+1; j++){
   	     for (var k=1; k<m+1; k++){
   	          for (var l=1; l<n+1; l++){
   	            d[i][j][k][l]=Math.sqrt(Math.pow(i-k,2)+Math.pow(j-l,2));
   	          }
   	     }
  	 }    
   }
 }
 
 dvar boolean x[1..m][1..n];
 dvar float+ y[1..m][1..n][1..m][1..n];
 dvar float f;
 dvar float g;
 
 maximize -f-lambda*g;
 			
 subject to {
   f == sum (i in 1..m, j in 1..n, k in 1..m, l in 1..n)  y[i][j][k][l]*d[i][j][k][l];
   g == sum(i in 1..m, j in 1..n) x[i][j];
   
   forall (i in 1..m, j in 1..n) sum (k in 1..m, l in 1..n : k != i || l != j) y[i][j][k][l] == x[i][j];
   
   forall (i in 1..m, j in 1..n, k in 1..m, l in 1..n) y[i][j][k][l] <= x[k][l];
   
   sum (i in 1..m, j in 1..n) x[i][j] <= Amax;
   sum (i in 1..m, j in 1..n) x[i][j] >= Amin;
   
   sum (i in 1..m, j in 1..n) 10*c[i][j]*x[i][j] <= B;   
 }
 
main {
	var model= thisOplModel;
	model.generate();
	var data = model.dataElements;
	
	var eps = 1.0e-3;
   	var currentObj;
   	var newLambda;
   	
   	cplex.solve();
   	writeln("Objectif = ", cplex.getObjValue());
   	currentObj = cplex.getObjValue();
   	writeln("f = " + model.f);
   	writeln("g = " + model.g);
   	writeln("f/g = " + model.f / model.g);
   	
   	while (Math.abs(currentObj) > eps ){ 
   	  newLambda = -model.f/model.g;
   	  writeln("newLambda = ",newLambda, "\n");
     
      var nextCplex = new IloCplex();
      var nextSource = new IloOplModelSource("Fragmentation2.mod");
   	  var nextDef = new IloOplModelDefinition(nextSource);
      var nextModel = new IloOplModel(nextDef,nextCplex);
      var nextData = new IloOplDataElements();
      nextData.m = data.m;
      nextData.n = data.n;
      nextData.B = data.B;
      nextData.Amin = data.Amin;
      nextData.Amax = data.Amax;
      nextData.c = data.c;
      nextData.lambda = newLambda;
      nextModel.addDataSource(nextData);
      nextModel.generate();
      
      model = nextModel;
      cplex = nextCplex;
      cplex.solve();
  	
  	  writeln("Objectif = ", cplex.getObjValue());
   	  currentObj = cplex.getObjValue();
   	  writeln("f = " + model.f);
   	  writeln("g = " + model.g);
   	  writeln("f/g = " + model.f / model.g);
  	}
}
 