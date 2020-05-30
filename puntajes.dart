import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math';

void main(){
  new File('file2.csv').readAsString().then((String contents) {
    var separar = contents.split(";");
    int tt = separar.length;
    for(int bb = 1; bb < 7; bb++){
      double promedio = calcular_promedio(separar,tt,bb); //Variable que guardara el promedio de los nems hasta el promedio de los resultados en historia
      double desviacion_est = calcular_desv_est(separar,tt,bb,promedio); //Variable que guardara la desviacion estandar de los nems hasta el de los resultados en historia
      double mediana = calcular_mediana(separar,tt,bb); //Variable que guardara la mediana de los nems hasta la mediana de los resultados en historia
      mostrar(bb,promedio,desviacion_est,mediana); //Funcion que mostrara en pantalla los resultados anteriores
      calcular_moda(separar,tt,bb); //La moda se mostrara por separado al ser una funcion void
    }
    integrantes();
  }); 
}

double calcular_promedio(var hh, int numero, int ind){
  int suma = 0; //Suma de todos los nems registrados, inicializada en 0
  int n = 0; //Numero de valores (Xi), inicializado en 0
  while(ind < numero){
    var ent = int.parse(hh[ind]); //Transforma el dato a un valor int 
    suma += ent;
    n++;
    ind = ind + 7; //Se aumenta en 7 unidades para ir iterando por cada nem
  }
  double promedio = suma/n;
  return promedio;
}

double calcular_desv_est(var hh, int nn, int indice, double prom){
  double suma = 0; //Variable que almacenara el resultado de la sumatoria, inicializada en 0
  double n = 0; //Numero de valores (Xi), inicializado en 0
  while(indice < nn){
    var entero = int.parse(hh[indice]);
    double gg = entero - prom; //todos los valores (Xi) se restan con el promedio
    suma += pow(gg,2); //el resultado de dicha operacion se eleva al cuadrado, operacion acumulativa
    n++;
    indice = indice + 7;
  }
  double k = suma/(n-1); //Hacemos la division (aplicando la formula que se encuentra dentro de la raiz)
  double des_est = pow(k,0.5); //Aplicamos raiz cuadrada del resultado anterior, aqui se obtiene la desviacion estandar
  return des_est;
}

double calcular_mediana(var ff, int numero, int ind){
  int contador = 0; //Contador hara la funcion de contar la cantidad de columnas del archivo csv
  var aux;
  for(int d = ind; d < numero; d = d + 7){ //Se aplica el algoritmo de ordenamiento burbuja, para que ordene los datos (Xi) de menor a mayor
    for(int r = ind; r < numero; r = r + 7){
      int n1 = int.parse(ff[d]);
      int n2 = int.parse(ff[r]);
      if(n1 > n2){
        aux = ff[d];
        ff[d] = ff[r];
        ff[r] = aux;
      }
    }
    contador++;
  }
  if(contador%2 != 0){ //Si el numero de datos es impar, entonces buscamos el valor que se encuentra justo en el medio
    var largo = contador-1; //Para que el resultado de la variable de la siguiente linea, le quitamos 1 unidad al contador 
    var pos = (largo/2).toInt(); //Dividimos el numero total de datos registrados a la mitad
    int indice = (pos * 7) + ind;
    var numeros = int.parse(ff[indice]);
    var mediana_impar = numeros.toDouble(); //Transformamos el valor escogido a un double (dado que la funcion tiene que retornar un valor double)
    return mediana_impar;
  }

  if(contador%2 == 0){ //Si es par, entonces hay dos valores en el medio 
    var nu1 = (contador/2).toInt(); //Obtenemos uno de los valores (se calcula dividiendo la cantidad de columnas a la mitad, representado en la variable contador)
    var nu2 = nu1 + 1; //El otro valor intermedio se obtiene aumentando el resultado de la variable en una unidad
    int indice1 = ((nu1 - 1) * 7) + ind;
    int indice2 = ((nu2 - 1) * 7) + ind;
    var num1 = int.parse(ff[indice1]);
    var num2 = int.parse(ff[indice2]);
    var nn = num1.toDouble(); //Ambos valores se transforman a numeros de tipo double, para que el resultado de la division no salga un error
    var nv = num2.toDouble();
    var mediana_par = ((nn+nv)/2).toDouble(); //Los dos valores que se encuentran en el medio se suman, posteriormente el resultado del dividendo se divide en dos
    return mediana_par;
  }
}

void calcular_moda(var datos, int numer, int ind){
  var moda = ""; //Variable que guardara la(s) moda(s), puede haber mas de una
  var repeticion = [0]; //Array que guardara el numero de veces que se repite cada dato encontrado
  int mas_alto = 1; //Variable que almacenara la cantidad maxima de oportunidades que se repite un numero
  var modas = [1];
  for(int e = ind; e < numer; e = e + 7){
    int contador_letras = 0; //Esta variable permite calcular el numero de veces que se repite cada dato unico (Xi)
    for(int w = ind; w < numer; w = w + 7){
      int n1 = int.parse(datos[e]);
      int n2 = int.parse(datos[w]);
      if(n1 == n2){ //Los for permiten realizar la comparacion de cada valor unico y comprobar la cantidad de veces que se repite
        contador_letras++;
      }
    }
    repeticion.add(contador_letras.toInt());
  }
  for(int rr = 1; rr < repeticion.length; rr++){
    if(repeticion[rr] > mas_alto){ //Este algoritmo permite comparar el numero de repeticiones de cada dato para saber cual es el mas alto (cantidad maxima de repeticiones de un valor(es))
      mas_alto = repeticion[rr].toInt(); //Si los condicionantes del if son verdaderos, entonces se ha encontrado un valor de repeticiones mas alto, dicho valor se almacena en la variable mas_alto
    }
  }
  int nun = 1; //Nun sirve para conocer si existe mas de una moda (en caso de que esta variable sea mayor que uno)
  for(int mm = 1; mm < repeticion.length; mm++){ //Si hay varios valores (mas de uno) que se repiten la misma cantidad de ocasiones, entonces se guardaran en una sola variable
    if(repeticion[mm] == mas_alto){
      int indice = ((mm-1)*7) + ind;
      var hg = int.parse(datos[indice]);
      if(nun == 1){
        modas.add(hg);
        nun++;
      }
      if(nun > 1){
        int var_random = 0; //var_random sirve para distingir cuando aparece una nuevo dato considerado como moda (ya que un valor cualquiera se repite mas de una vez)
        for(int jj = 1; jj < modas.length; jj++){
          if(modas[jj] == hg){ //Esta operacion compara si el dato se encuentra repetido, si eso ocurre, entonces var_random adopta un 1 como valor
            var_random = 1; //Esto evita que la terminal imprima un mismo dato varias veces (ej: Moda: 600 600 600)
          }
        }
        if(var_random == 0){ //Si el valor original de var_random no se altera, entonces se ha encontrado otra moda
          modas.add(hg);
          nun++;
        }
      }
    }
  }
  for(int rt = 1; rt < modas.length; rt++){
    moda += modas[rt].toString(); //Concatenamos todas las modas encontradas, para asi mostrarlas en pantallas como un string
    moda += " ";
  }
  print('Moda: $moda');
}

void mostrar(int posicion, double prom, double des, double med){ //Funcion void que mostrara los resultados obtenidos solicitados (a excepcion de la moda)
  if(posicion == 1){
    print('=== Nem ===');
  }
  if(posicion == 2){
    print('=== Ranking ===');
  }
  if(posicion == 3){
    print('=== Matematicas ===');
  }
  if(posicion == 4){
    print('=== Lenguaje ===');
  }
  if(posicion == 5){
    print('=== Ciencias ===');
  }
  if(posicion == 6){
    print('=== Historia ===');
  }
  print('Promedio: $prom');
  print('Desviacion Estandar: $des');
  print('Mediana: $med');
}

void integrantes(){
  print('=== Integrantes === ');
  print('Ricardo Aliste');
  print('Daniel Cajas');
  print('Rodrigo Carmona');
}
