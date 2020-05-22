import "dart:async";
import "dart:io";
import "dart:convert";
import "dart:math";

void main() { 
  new File('puntajes.csv').readAsString().then((String contents) { //Abrimos el archivo csv
    var separar = contents.split(";"); //Separamos los datos como si se tratara de un array
    int tt = separar.length;   //Largo de los datos (en teoria, n° de filas x n° de columnas)
    for(int bb = 1; bb < 7; bb++){
      if(bb != 6){
        double promedio = calcular_promedio_ver_or(separar,tt,bb); //Variable que guardara el promedio de los nems hasta el promedio de los resultados en ciencias
        double desviacion_est = calcular_desv_est_ver_or(separar,tt,bb,promedio); //Variable que guardara la desviacion estandar de los nems hasta el de los resultados en ciencias
        double mediana = calcular_mediana_ver_or(separar,tt,bb); //Variable que guardara la mediana de los nems hasta la mediana de los resultados en ciencias
        int moda = calcular_moda_ver_or(separar,tt,bb); //Variable que guardara la moda de los nems hasta la de los resultados en ciencias
        mostrar(bb,promedio,desviacion_est,mediana,moda); //Funcion que mostrara en pantalla los resultados anteriores
      }
      if(bb == 6){ //Dado que la obtencion de los datos de historia requieren condiciones especiales, se tienen que crear funciones para dichos datos (las razones se explican mas adelante)
        double promedio = calcular_promedio_ver_mod(separar,tt,bb); //Variable que guardara el promedio de los resultados en historia
        double desviacion_est = calcular_desv_est_ver_mod(separar,tt,bb,promedio); //Variable que guardara la desviacion estandar de los resultados en historia
        double mediana = calcular_mediana_ver_mod(separar,tt,bb); //Variable que guardara la mediana de los resultados en historia
        int moda = calcular_moda_ver_mod(separar,tt,bb); //Variable que guardara la moda de los resultados en historia
        mostrar(bb,promedio,desviacion_est,mediana,moda); //Lo mismo que la linea 16
      }
    }
    integrantes();
  });
}

double calcular_promedio_ver_or(var hh, int numero, int ind){ 
  var dato = [1]; //Arreglo donde se guardaran todos los resultados de cada nem
  while(ind < numero){
    var ent = int.parse(hh[ind]); //Transforma el dato a un valor int 
    dato.add(ent); //Se almacena dentro del arreglo
    ind = ind + 6; //Se aumenta en 6 unidades para ir iterando por cada nem
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

double calcular_promedio_ver_mod(var hh, int numero, int ind){ //Se creo una segunda funcion de promedio para capturar los datos de la prueba de historia (no se puede hacer de la misma manera que los otros datos)
  var dato = new List(1000); //Creamos una lista lo suficientemente grande para almacenar todos los datos
  int gg = 0; //Numero de resultados de historia, inicializado en 0
  var datos = [1];
  while(ind < numero){
    var nm = hh[ind].toString(); //Transforma el dato a un string
    dato[gg] = nm; //La variable anterior se almacena en la lista
    ind = ind + 6; //Lo mismo que la linea 35
    gg++;
  }
  for(int ik = 0; ik < gg; ik++){ //La razon de la funcion es porque la lista guarda cada dato de la siguiente manera: historia1 rut2, historia2 rut3, como si se tratara de un mismo dato (ej: 532 16392301, 678 16392302)
    var nume = dato[ik]; //La intencion es separar el puntaje con el rut asociado, por ello, esta variable guarda cada dato registrado en la lista dato
    var puntaje = ""; //Variable que se utilizara para guardar el puntaje de historia
    for(int er = 0; er < 3; er++){ //El for llega hasta el numero tres dado que ahi se presenta un espacio en blanco (ej 678 17923025)
      puntaje += nume[er];         //                                                                                pos 0123456789
    } //Al salir el for, la variable puntaje tendra solo el puntaje correspondiente al puntaje de historia
    var entero = int.parse(puntaje); //Transformamos el string generado a un int
    datos.add(entero); //Se guarda en el array datos
  }
  int suma = 0; //Se repite el proceso de las lineas 37-44 (o de la funcion anterior)
  int n = 0;
  for(int f = 1; f < datos.length; f++){
    suma += datos[f];
    n++;
  }
  double promedio = suma/n;
  return promedio;

}

double calcular_desv_est_ver_or(var hh, int nn, int indice, double prom){
  var dato = [1]; //Se repite el proceso de obtencion de datos de la funcion calcular_promedio_ver_or (lineas 31-35)
  while(indice < nn){
    var ent = int.parse(hh[indice]);
    dato.add(ent);
    indice = indice + 6;
  }
  double suma = 0; //Variable que almacenara el resultado de la sumatoria, inicializada en 0
  double n = 0; //Numero de valores (Xi)
  for(int e = 1; e < dato.length; e++){ //En el for se realiza el proceso que calcula la sumatoria 
    double gg = dato[e] - prom; //todos los valores (Xi) se restan con el promedio
    suma += pow(gg,2); //el resultado de dicha operacion se eleva al cuadrado
    n++;
  }
  double k = suma/(n-1); //Hacemos la division (aplicando la formula que se encuentra dentro de la raiz)
  double des_est = pow(k,0.5); //Aplicamos raiz cuadrada del resultado anterior, aqui se obtiene la desviacion estandar
  return des_est;
}

double calcular_desv_est_ver_mod(var hh, int numero, int ind, double promedio){
  var dato = new List(1000); //Se repite el proceso de obtencion de datos de la funcion calcular_promedio_ver_mod (lineas 48-64)
  int gg = 0;
  var datos = [1];
  while(ind < numero){
    var nm = hh[ind].toString();
    dato[gg] = nm;
    ind = ind + 6;
    gg++;
  }
  for(int ik = 0; ik < gg; ik++){
    var nume = dato[ik];
    var puntaje = "";
    for(int er = 0; er < 3; er++){
      puntaje += nume[er];
    }
    var entero = int.parse(puntaje);
    datos.add(entero);
  }
  double suma = 0; //Se repite el proceso de las lineas 84-93 (o de la funcion anterior)
  double n = 0;
  for(int e = 1; e < datos.length; e++){
    double pp = datos[e] - promedio;
    suma += pow(pp,2);
    n++;
  }
  double k = suma/(n-1);
  double des_est = pow(k,0.5);
  return des_est;

}

double calcular_mediana_ver_or(var ff, int numero, int ind){
  var dato = [1];  //Se repite el proceso de obtencion de datos de la funcion calcular_promedio_ver_or (lineas 31-35)
  int contador = 0; //Utilizamos un contador, que sera utilizado mas adelante
  //var mediana;
  while(ind < numero){
    var ent = int.parse(ff[ind]);
    dato.add(ent);
    ind = ind + 6;
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

  if(contador%2 == 0){ //Si es par, entonces hay dos valores en el medio (En realidad, el largo del array es impar, por la misma razon que la linea 149)
    var numm = (contador/2); //Obtenemos uno de los valores (se calcula dividiendo por la posicion del ultimo dato del array dato, representado en la variable contador)
    var num1 = numm.toInt(); 
    var num2 = num1 + 1; //El otro valor intermedio se obtiene aumentando el resultado de la variable en una unidad
    var nn = dato[num1].toDouble(); //Ambos valores se transforman a numeros de tipo double, para que el resultado de la division no salga un error
    var nv = dato[num2].toDouble();
    var mediana_par = ((nn+nv)/2).toDouble(); //Los dos valores que se encuentran en el medio se suman, posteriormente el resultado del dividendo se divide en dos
    return mediana_par;
  }
}

double calcular_mediana_ver_mod(var hh, int numero, int ind){
  var dato = new List(1000); //Se repite el proceso de obtencion de datos de la funcion calcular_promedio_ver_mod (lineas 48-64)
  int gg = 0;
  int contador = 0;
  var datos = [1];
  while(ind < numero){
    var nm = hh[ind].toString();
    dato[gg] = nm;
    ind = ind + 6;
    gg++;
  }
  for(int ik = 0; ik < gg; ik++){
    var nume = dato[ik];
    var puntaje = "";
    for(int er = 0; er < 3; er++){
      puntaje += nume[er];
    }
    var entero = int.parse(puntaje);
    datos.add(entero);
    contador++;
  }
  var aux; //Se repite el proceso de las lineas 138-144 (o de la funcion anterior)
  for(int d = 1; d < (datos.length-1); d++){
    for(int r = 1; r < (datos.length-1); r++){
      if(datos[r] > datos[r+1]){
        aux = datos[r];
        datos[r] = datos[r+1];
        datos[r+1] = aux;
      }
    }
  }

  if(contador%2 != 0){ //Se repite el proceso de las lineas 148-163 (o de la funcion anterior)
    var largo = dato.length;
    var pos = (largo/2);
    var pos_int = pos.toInt();
    var mediana_impar = datos[pos_int].toDouble();
    return mediana_impar;
  }

  if(contador%2 == 0){
    var numm = (contador/2);
    var num1 = numm.toInt();
    var num2 = num1 + 1;
    var nn = datos[num1].toDouble();
    var nv = datos[num2].toDouble();
    var mediana_par = ((nn+nv)/2).toDouble();
    return mediana_par;
  }
}

int calcular_moda_ver_or(var datos, int numer, int ind){
  var dato = [1]; //Se repite el proceso de obtencion de datos de la funcion calcular_promedio_ver_or (lineas 31-35)
  int contador_p = 0; //Variable que guardara el total de numeros unicos (no se cuentan los repetidos)
  var moda = ""; //Variable que guardara la(s) moda(s), puede haber mas de una
  while(ind < numer){
    var ent = int.parse(datos[ind]);
    dato.add(ent);
    ind = ind + 6;
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
          indices.add(i.toInt());
          contador_p += 1;
          break;
        }
      }
		}
	}
  for(int e = 1; e < numeros.length; e++){ 
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

int calcular_moda_ver_mod(var hh, int numero, int ind){
  var dato = new List(1000); //Se repite el proceso de obtencion de datos de la funcion calcular_promedio_ver_mod (lineas 48-64)
  int gg = 0;
  var datos = [1];
  int contador_p = 0;
  var moda = "";
  while(ind < numero){
    var nm = hh[ind].toString();
    dato[gg] = nm;
    ind = ind + 6;
    gg++;
  }
  for(int ik = 0; ik < gg; ik++){
    var nume = dato[ik];
    var puntaje = "";
    for(int er = 0; er < 3; er++){
      puntaje += nume[er];
    }
    var entero = int.parse(puntaje);
    datos.add(entero);
  }
  var numeros = [1]; //De aqui hasta el final de la funcion, se repite el proceso de las lineas 227-276 (o de la funcion anterior)
  var indices = [1];
  var repeticion = [0];
  int mas_alto = 1;
  for(int i = 1; i < datos.length; i++){ 
		if(i==1){
			int numerito = datos[i].toInt();
      numeros.add(numerito);
      indices.add(i.toInt());
			contador_p += 1;
    }
    if(i > 1){
      int var_random = 0;
      for(int u = 1; u < i; u++){
        if(numeros[u] == datos[i]){ 
          var_random = 1;
        }
        if(var_random == 0){ 
          int numerito = datos[i].toInt();
          numeros.add(numerito);
          indices.add(i.toInt());
          contador_p += 1;
          break;
        }
      }
		}
	}
  for(int e = 1; e < numeros.length; e++){ 
    int contador_letras = 0; 
    for(int w = 1; w < numeros.length; w++){
      if(numeros[w] == numeros[e]){
        contador_letras++;
      }
    }
    repeticion.add(contador_letras.toInt());
  }
  for(int rr = 1; rr < repeticion.length; rr++){
    for(int ww = 1; ww < repeticion.length; ww++){
      if((repeticion[rr] > repeticion[ww]) & (repeticion[rr] > mas_alto)){
        mas_alto = repeticion[rr].toInt();
      }
    }
  }
  for(int mm = 1; mm < repeticion.length; mm++){
    var hg = numeros[mm].toString();
    moda += hg;
    break;
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