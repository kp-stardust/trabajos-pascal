program TrianguloNumerico;

Const
     MIN = 1;
     MAX = 10;
Var
   dimension: integer;

(*--------------------- FUNCIONES Y PROCEDIMIENTOS--------------- *)

FUNCTION confirma (msg: string): boolean;
(*Devuelve verdadero si confirma o falso, si no.
 Precond: msg = M
 Poscond: confirma = verdadero o confirma = falso*)
 Var
    resp: char;

 BEGIN
      Repeat
            writeln(msg, 'S/N');
            readln (resp);
      until (resp = 'n') or (resp= 'N') or (resp = 'S') or (resp = 's');

      confirma := (resp = 'S') or (resp = 's');
 END;

(*-----------------------------------------------------------------*)
FUNCTION enteroEnRango (msg: string; tope1, tope2:integer): integer;
(*Que hace: muestra un mensaje por pantalla y solicita al usuario una
dimension para el triangulo.
Precond: msg = M;  tope1 = T1; tope2 = T2; T1 <= T2.
Poscond: enteroEnRango = D y T1 <= D <= T2*)
Var
   d:integer;

begin
     Repeat
           writeln (msg);
           readln (d);
     until (d >= tope1) and (d<= tope2);
     enteroEnRango := d;
end;

(*-----------------------------------------------------------------*)

FUNCTION sumaFilaTriangulo (n:integer):integer;
(*Que hace: suma los elementos de una fila del triangulo.
Precond: n = N
Poscond: sumaFilaTriangulo = S*)

begin
     if n=0 then
        sumaFilaTriangulo := 0
     else
         sumaFilaTriangulo := n + sumaFilaTriangulo (n-1)
end;


(*-----------------------------------------------------------------*)
PROCEDURE baseTriangulo (cantNum: integer);
(* Que hace: muestra una fila del triangulo.
Precond: cantNum: C y C > 0
Poscond: no tiene*)
Var
   base, i: integer;

begin
     base := 1;
     FOR i := 1 TO cantNum DO
     begin
         write(base);
         base := base + 1
     end;

end;

(*-----------------------------------------------------------------*)

PROCEDURE dibujarTriangulo (num: integer);
(*Que hace: dibuja el triangulo.
Precond: num=N
Poscond: no tiene*)

begin
     if (num = 1) then
     begin
        write(num);
     end
     else
     begin
         dibujarTriangulo (num-1);
         writeln;
         baseTriangulo (num);
     end
end;


(*-----------------------------------------------------------------*)
FUNCTION sumaLado (numero: integer): integer;
(*Que hace: suma los elementos del cateto opuesto o de la hipotenusa
Precond: numero = N
Poscond: sumaLado = H o sumaLado = C *)

begin
     if numero = 1 then
        sumaLado := 0
        (* devuelve 0 cuando numero vale 1 ya que los unos pertenecen
        al cateto adyacente y su cálculo lo realiza la función sumaColumna*)
     else
         sumaLado := numero + sumaLado (numero - 1);
end;

(*-----------------------------------------------------------------*)
FUNCTION sumaColumna (n: integer): integer;
(*Que hace: suma los elementos correspondientes al cateto adyacente del triangulo
Precond: n = N
Poscond: sumaColumna = C *)
begin
     if n = 1 then
        sumaColumna := 1
     else
         sumaColumna := 1 + sumaColumna (n-1);
     (*va sumando uno ya que el cateto adyacente siempre tiene unos*)
end;

(*-----------------------------------------------------------------*)
FUNCTION calcularSuperficie (nro:integer): integer;
(*Que hace: suma todos los elementos del triangulo para obtener su superficie
Precond: nro= N
Poscond: calcularSuperficie = S *)

Var
   sup, i:integer;

begin
     sup:= 0;
     FOR i := 1 TO nro DO
         sup:= sup + sumaFilaTriangulo (i);

     calcularSuperficie := sup;
end;



(*-----------------------------------------------------------------*)
FUNCTION calcularPerimetro (valor: integer): integer;
(*Que hace: calcula el perímetro del triangulo
Precond: valor = V
Poscond: calcularPerimetro = P*)

Var
   per:integer;

begin
     per := 0;
     if (valor = 1) then
        per := 1
     else
     begin
         per:= sumaLado (valor) + sumaLado (valor - 1);
         (*la primera parte de la expresion obtiene el valor de la hipotenusa y
         la segunda el del cateto opuesto*)
         per := per + sumaColumna (valor);
     end;

     calcularPerimetro := per;

end;

(*-----------------------------------------------------------------*)
PROCEDURE muestraCalculo (dim: integer);
(*Que hace: muestra los resultados del cálculo de superficie y de perímetro.
Precon: dim = D.
Poscond: no tiene*)

begin
     writeln; (*Para que muestre el triangulo y los msjes en distinta linea*)
     writeln ('La superficie del triangulo es: ', calcularSuperficie(dim));
     writeln ('El perimetro del triangulo es: ', calcularPerimetro(dim));
end;


(*------------------------PROGRAMA PRINCIPAL-----------------------*)

begin
     WHILE confirma ('¿Desea dibujar un triangulo?') DO
     begin
           dimension := enteroEnRango ('Ingrese dimension triangulo', MIN, MAX);
           writeln; (*para que haga un espacio entre la respuesta y el triangulo*)
           dibujarTriangulo (dimension);
           muestraCalculo (dimension);
     end;
     readln;
end.
