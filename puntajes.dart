import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math';

void main(){
  new File('puntajes.csv').readAsString().then((String contents) {
    var separar = contents.split(";");
    int tt = separar.length;
    for(int bb = 1; bb < 7; bb++){
      double promedio = calcular_promedio(separar,tt,bb); //Variable que guardara el promedio de los nems hasta el promedio de los resultados en historia
      double desviacion_est = calcular_desv_est(separar,tt,bb,promedio); //Variable que guardara la desviacion estandar de los nems hasta el de los resultados en historia
      double mediana = calcular_mediana(separar,tt,bb); //Variable que guardara la mediana de los nems hasta la mediana de los resultados en historia
      int moda = calcular_moda(separar,tt,bb); //Variable que guardara la moda de los nems hasta la de los resultados en historia
      mostrar(bb,promedio,desviacion_est,mediana,moda); //Funcion que mostrara en pantalla los resultados anteriores
    }
    integrantes();
  }); 
}

double calcular_promedio(var hh, int numero, int ind){
  var dato = [1]; //Arreglo donde se guardaran todos los resultados de cada nem
  while(ind < numero){
    var ent = int.parse(hh[ind]); //Transforma el dato a un valor int 
    dato.add(ent); //Se almacena dentro del arreglo
    ind = ind + 7; //Se aumenta en 7 unidades para ir iterando por cada nem
  }
  int suma = 0; //Suma de todos los nems registrados, inicializada en 0
  int n = 0; //Numero de valores (Xi), inicializado en 0
  for(int f = 1; f < dato.length; f++){
    suma += dato[f];
    n++;
  }
  double promedio = suma/n;
  return promedio;
}

double calcular_desv_est(var hh, int nn, int indice, double prom){
  var dato = [1]; //Se repite el proceso de obtencion de datos de la funcion calcular_promedio (lineas 21-26)
  while(indice < nn){
    var ent = int.parse(hh[indice]);
    dato.add(ent);
    indice = indice + 7;
  }
  double suma = 0; //Variable que almacenara el resultado de la sumatoria, inicializada en 0
  double n = 0; //Numero de valores (Xi), inicializado en 0
  for(int e = 1; e < dato.length; e++){ //En el for se realiza el proceso que calcula la sumatoria 
    double gg = dato[e] - prom; //todos los valores (Xi) se restan con el promedio
    suma += pow(gg,2); //el resultado de dicha operacion se eleva al cuadrado, operacion acumulativa
    n++;
  }
  double k = suma/(n-1); //Hacemos la division (aplicando la formula que se encuentra dentro de la raiz)
  double des_est = pow(k,0.5); //Aplicamos raiz cuadrada del resultado anterior, aqui se obtiene la desviacion estandar
  return des_est;
}

double calcular_mediana(var ff, int numero, int ind){
  var dato = [1]; //Se repite el proceso de obtencion de datos de la funcion calcular_promedio (lineas 21-26)
  int contador = 0;
  //var mediana;
  while(ind < numero){
    var ent = int.parse(ff[ind]);
    dato.add(ent);
    ind = ind + 7;
    contador++;
  }
  var aux;
  for(int d = 1; d < (dato.length-1); d++){ //Se aplica el algoritmo de ordenamiento burbuja, para que ordene los datos (Xi) de menor a mayor
    for(int r = 1; r < (dato.length-1); r++){
      if(dato[r] > dato[r+1]){
        aux = dato[r];
        dato[r] = dato[r+1];
        dato[r+1] = aux;
      }
    }
  }
  if(contador%2 != 0){ //Si el numero de datos es impar, entonces buscamos el valor que se encuentra justo en el medio
    var largo = dato.length; //En realidad, el largo del array dato es par (dado que siempre al inicio se agrega un valor inicial (1) )
    var pos = (largo/2); //Dividimos el numero total de datos registrados a la mitad
    var pos_int = pos.toInt(); //Por si acaso, transformamos el numero a un int
    var mediana_impar = dato[pos_int].toDouble(); //Transformamos el valor escogido a un double (dado que la funcion tiene que retornar un valor double)
    return mediana_impar;
  }

  if(contador%2 == 0){ //Si es par, entonces hay dos valores en el medio (En realidad, el largo del array es impar, por la misma razon que la linea 77)
    var numm = (contador/2); //Obtenemos uno de los valores (se calcula dividiendo por la posicion del ultimo dato del array dato, representado en la variable contador)
    var num1 = numm.toInt();
    var num2 = num1 + 1; //El otro valor intermedio se obtiene aumentando el resultado de la variable en una unidad
    var nn = dato[num1].toDouble(); //Ambos valores se transforman a numeros de tipo double, para que el resultado de la division no salga un error
    var nv = dato[num2].toDouble();
    var mediana_par = ((nn+nv)/2).toDouble(); //Los dos valores que se encuentran en el medio se suman, posteriormente el resultado del dividendo se divide en dos
    return mediana_par;
  }
}

int calcular_moda(var datos, int numer, int ind){
  var dato = [1]; //Se repite el proceso de obtencion de datos de la funcion calcular_promedio (lineas 21-26)
  int contador_p = 0; //Variable que guardara el total de numeros unicos (no se cuentan los repetidos)
  var moda = ""; //Variable que guardara la(s) moda(s), puede haber mas de una
  while(ind < numer){
    var ent = int.parse(datos[ind]);
    dato.add(ent);
    ind = ind + 7;
  }
  var numeros = [1]; //Array que guardara los numeros unicos encontrados durante la recoleccion de datos
  var indices = [1]; //Array que guardara las posiciones donde fueron encontrados los numeros unicos
  var repeticion = [0]; //Array que guardara el numero de veces que se repite cada dato encontrado
  int mas_alto = 1; //Variable que almacenara la cantidad maxima de oportunidades que se repite un numero
  for(int i = 1; i < dato.length; i++){ 
		if(i==1){ //El primer dato se guarda automaticamente en el array numeros
			int numerito = dato[i].toInt();
      numeros.add(numerito);
      indices.add(i.toInt());
			contador_p += 1;
    }
    if(i > 1){
      int var_random = 0;
      for(int u = 1; u < i; u++){
        if(dato[u] == dato[i]){ //El for y posterior if comprueba si el numero de la iteracion se encuentra repetido en el array numeros
          var_random = 1; //Si var_random = 1, quiere decir que efectivamente el numero de la iteracion es un dato repetido
        }
        if(var_random == 0){ //Si el valor de var_random no cambio a 1, entonces se ha encontrado un dato diferente (no repetido)
          int numerito = dato[i].toInt();
          numeros.add(numerito); //Entonces, el numero valor unico encontrado se almacena en su array dedicado
          indices.add(i.toInt()); //Tambien se almacena la posicion donde fue encontrado
          contador_p += 1;
          break;
        }
      }
		}
	}
  for(int e = 1; e < indices.length; e++){
    int contador_letras = 0; //Esta variable permite calcular el numero de veces que se repite cada dato unico (Xi)
    for(int w = 1; w < numeros.length; w++){
      if(numeros[w] == numeros[e]){ //Los for permiten realizar la comparacion de cada valor unico y comprobar la cantidad de veces que se repite
        contador_letras++;
      }
    }
    repeticion.add(contador_letras.toInt());
  }
  for(int rr = 1; rr < repeticion.length; rr++){
    for(int ww = 1; ww < repeticion.length; ww++){
      if((repeticion[rr] > repeticion[ww]) & (repeticion[rr] > mas_alto)){ //Este algoritmo permite comparar el numero de repeticiones de cada dato para saber cual es el mas alto (cantidad maxima de repeticiones de un valor(es))
        mas_alto = repeticion[rr].toInt(); //Si los condicionantes del if son verdaderos, entonces se ha encontrado un valor de repeticiones mas alto, dicho valor se almacena en la variable mas_alto
      }
    }
  }
  for(int mm = 1; mm < repeticion.length; mm++){ //Si hay varios valores (mas de uno) que se repiten la misma cantidad de ocasiones, entonces se guardaran en una sola variable
    var hg = numeros[mm].toString();
    moda += hg;
    break; //El break lo ejecutamos en caso de que solo querramos un valor, que representara la moda obtenida
  }
  var modas = int.parse(moda);
  return modas;
}

void mostrar(int posicion, double prom, double des, double med, int mod){ //Funcion void que mostrara los resultados obtenidos solicitados
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
  print('Moda: $mod');
}

void integrantes(){
  print('=== Integrantes === ');
  print('Ricardo Aliste');
  print('Daniel Cajas');
  print('Rodrigo Carmona');
}
