Program Agenda;
USES
    crt, sysutils;

CONST
      AGENDA_ORIGINAL='C:\micodigo\AGENDA.DAT';
      MAXLISTA = 50;
      AGENDA_ORDENADA = 'C:\micodigo\AGENDA_ORDENADA.DAT';

TYPE
    tRegFecha = record
              dia: integer;
              mes: integer;
              anio: integer;
    end;

    tRegPersona = record
                nombre: string;
                apellido: string;
                direccion: string;
                ciudad: string;
                provincia: string;
                cod_postal: string;
                telefono: string;
                fecha_nac: tRegFecha;
    end;

    tArchAgenda = File of tRegPersona;

    tArch = File;

    tPersonas = array [1.. MAXLISTA] OF tRegPersona;


(*----------------------------------------------------------------------------*)
Function existeArchivo(nombre:string):boolean;
(* Verifica la existencia de un archivo
   Prec: nombre = N
   Posc: existeArchivo = Verdadero o existeArchivo = Falso
*)
Var
  f: tArch;
begin
     Assign(f, nombre); (* vincula f con el nombre de archivo a abrir *)
     {$I-}(* desactivo el control de errores de E/S*)
     reset(f);(* intento abrirlo *)
     close(f);(* intento cerrarlo*)
     existeArchivo:= IOResult = 0; (* Si no hubo error => existe el archivo*)
     {$I+}(* activo el control de errores *)
end;

(*----------------------------------------------------------------------------*)
Procedure abrirArchivo(VAR arch: tArch; nombre:string);
(* Permite abrir un archivo existente
   Prec: arch = A, nombre = N, N existente
   Posc: Archivo de nombre N abierto o muestra mensaje que indica que no existe
*)
begin
     if (existeArchivo(nombre)) then
     begin
        assign(arch, nombre);
        reset(arch);
     end
     else
        writeln('No existe el archivo ', nombre);
end;

(*----------------------------------------------------------------------------*)
Procedure mostrarFecha(fecha: tRegFecha);
(* Muestra una fecha en formato dd/mm/aaaa
   Prec: fecha = F y F v?lida
   Posc: -
*)
begin
     writeln ('Fecha de nacimiento: ', IntToStr(fecha.dia) + '/' + IntToStr(fecha.mes) + '/' + IntToStr(fecha.anio));
end;

(*----------------------------------------------------------------------------*)
Procedure mostrarPersona(persona: tRegPersona);
(* Muestra los campos de un registro
   Prec: persona = P
   Posc: -
*)
begin
     writeln('Apellido y Nombre: ', persona.apellido + ', '+ persona.nombre);
     writeln('Direccion: ', persona.direccion);
     writeln('Ciudad: ', persona.ciudad);
     writeln('Provincia: ', persona.provincia);
     writeln('Codigo Postal: ', persona.cod_postal);
     mostrarFecha(persona.fecha_nac);
     writeln('-----------------------------------------------------');
end;

(*----------------------------------------------------------------------------*)
Procedure encabezado(VAR lineas: integer; VAR hoja: integer);
(* Qué hace: muestra el encabezado del listado.
Pre: H = hojas y H >= 0
Pos: Hojas = H', Lineas = L; L >=1; H' = H+1 *)

begin
	hoja := hoja + 1;
    writeln('=====================================================');
	writeln('        AGENDA DE CONTACTOS. Hoja nro: ', hoja);
    writeln('=====================================================');
	lineas := 1;
end;

(*----------------------------------------------------------------------------*)
Procedure PieDePagina ();
(* Qué hace: muestra un mensaje solicitando presionar una tecla para continuar *)

Var
	c: char;
begin	
	  writeln('Presione una tecla para continuar');
	  readln (c);
end;	  

(*----------------------------------------------------------------------------*)
Procedure ListarAgenda(nombre:string);
(* Lista el contenido de un archivo existente
   Prec: nombre = N
   Posc: -*)

Const
	TOPE = 7;
var
   lineas, hoja: integer;
   arch: tArchAgenda;
   persona: tRegPersona;
begin
     hoja := 0;
     abrirArchivo(arch, nombre);
	 encabezado (lineas, hoja);
     while not (eof(arch)) do
     begin
          if lineas > TOPE then
		  begin
				PieDePagina ();
				encabezado (lineas, hoja);
		  end;		
		  read(arch, persona);
          mostrarPersona(persona);
          lineas := lineas + 1;
     end;
     close(arch);
end;
(*----------------------------------------------------------------------------*)
 Procedure mostrarDatosPersona (persona: tRegPersona; pos: integer);
 (* Muestra un registro con los datos de una persona y su posición en el arreglo
  Pre: Persona = P, pos = PO
  Pos: -- *)
 begin
     writeln('-----------------------------------------------------');
     writeln ('Posicion:', pos);
     writeln('Apellido y Nombre: ', persona.apellido + ', '+ persona.nombre);
     writeln('Direccion: ', persona.direccion);
     writeln('Ciudad: ', persona.ciudad);
     writeln('Provincia: ', persona.provincia);
     writeln('Codigo Postal: ', persona.cod_postal);
     mostrarFecha(persona.fecha_nac);
     writeln('-----------------------------------------------------');
end;

(*----------------------------------------------------------------------------*)
Procedure listarDeArreglo (personas: tPersonas; dim: integer);
(* Lista el contenido de cada registro del arreglo
   Prec: personas = P; dim = D
   Pos: --- *)

Const
	TOPE = 7;
var
   lineas, hoja: integer;
   i: integer;
begin
     hoja := 0;
     i := 0;
	 encabezado (lineas, hoja);
     while i < dim do
     begin
          i := i + 1;
          if lineas > TOPE then
		  begin
				PieDePagina;
				encabezado (lineas, hoja);
		  end;		
		  mostrarDatosPersona (personas[i], i);
		  lineas := lineas + 1;

     end;
end;
(*----------------------------------------------------------------------------*)
Procedure almacenarRegistros(VAR personas: tPersonas; ruta:string; VAR dim: integer; tope:integer);
(* Que hace: guarda los registros de un archivo en un arreglo
Pre: ruta = R el archivo R existe; tope = T
Pos: personas = P y P = V, para todo i en [1...T]*)


Var
   arch: tArchAgenda;
   persona: tRegPersona;
   i: integer;
begin
     i := 0;
     abrirArchivo(arch, ruta);
     while not (eof(arch)) and (i< tope) do
     begin
           i := i + 1;
           read(arch, persona);
           personas[i] := persona;
     end;
     close (arch);
     dim := i;
     writeln ('Se han almacenado los registros a un arreglo.');
end;

(*----------------------------------------------------------------------------*)
 Function buscarMinimo (listaPersonas: tPersonas; p, f: integer):integer;
(* Que hace: busca la posición del elemento más pequeño entre p y f.
Pre: listaPersonas = L, p = P, f = F; [P.. F] está incluido en rango (listaPersonas);
Pos: buscarMinimo: buscarMinimo = N y N pertenece a [P.. F] *)

 Var
    min, i: integer;
    persona1, persona2: string;
 begin
      min := p;
      For i := p TO f DO
      begin
           persona1 := (listaPersonas[min].apellido + listaPersonas[min].nombre);
           persona2 := (listaPersonas[i].apellido + listaPersonas[i].nombre);
                if (persona1 > persona2) then
                      min := i;
      end;

      buscarMinimo := min;
  end;
(*----------------------------------------------------------------------------*)
 Procedure intercambiar (VAR reg1, reg2: tRegPersona);
 (*Que hace: intercambia dos valores
  Pre: reg1 = R1, reg2 = R2
  Pos: reg1= R2 y reg2 = R1*)

 Var
    aux: tRegPersona;
 begin
      aux := reg1;
      reg1 := reg2;
      reg2 := aux;
  end;
(*----------------------------------------------------------------------------*)
 Procedure ordenarElementos (VAR personas: tPersonas; dim: integer);
(* Que hace: Ordena los elementos de un arreglo.
 Pre: personas = P;  dim = D; [1.. F] en rango (personas)
 Pos: P = P', P' está ordenada *)

 Var
    i: integer;
 begin
      FOR i:= 1 TO dim DO
          intercambiar(personas[i],personas[buscarMinimo(personas, i, dim)]);
          writeln ('Se ha ordenado la lista por nombre y apellido.');
 end;

 (*----------------------------------------------------------------------------*)
Procedure generarAgendaOrdenada (personas: tPersonas; tope:integer);
(*Qué hace: crea un archivo con los datos de un arreglo ordenado
 Pre: personas = P, tope = T
 Pos: -- *)

Var
   i: integer;
   arch: tArchAgenda;

begin
     assign (arch, 'C:\micodigo\AGENDA_ORDENADA.DAT');
     rewrite (arch);
     for i:= 1 to tope Do
     begin
          write (arch, personas[i]);
     end;
     close (arch);
     writeln ('Se ha creado un archivo con la agenda ordenada');
end;

(*----------------------------------------------------------------------------*)
function confirma(msg: string): boolean;
(* Realiza una pregunta al usuario
  Prec: msg = M
  Posc: confirma = Verdadero o confirma = Falso*)

Var
   c: char;
begin
     repeat
           writeln(msg);
           readln(c);
     until (c in ['S','s','n','N']);

     confirma := (c in ['S','s']);
end;

(*----------------------------------------------------------------------------*)
function enteroEnRango(msg: string; tope1, tope2: integer): integer;
(* Devuelve un valor entero dentro de un rango dado por par?metro
  Prec: msg = M y tope1=T1 y tope2= T2 y T1 <=T2
  Posc: enteroEnRango = V y V en [T1 , T2] *)

var
   nro: integer;
begin
     repeat
        write(msg);
        readln(nro)
     until (nro >= tope1) and (nro <= tope2);

     enteroEnRango:= nro;
end;


(*----------------------------------------------------------------------------*)
function mostrarMenu(): integer;
(* Muestra un menu de opciones y obtiene una opcion elegida por el usuario
   Prec: -
   Posc: mostrarMenu = M *)

begin
    Clrscr();
    writeln('                 MENU DE OPCIONES');
    writeln('=====================================================');
    writeln('1. Listar contactos de agenda');
    writeln('2. Guardar registros de agenda en un arreglo');
    writeln('3. Ordenar elementos del arreglo por nombre y apellido');
    writeln('4. Listar elementos del arreglo');
    writeln('5. Crear archivo de agenda ordenada');
    writeln('6. Leer archivo de agenda ordenada');
    writeln('7. Salir');
    writeln('=====================================================');
    mostrarMenu:= enteroEnRango('Ingrese una opcion del menu: ', 1,7);
    writeln();
end;



(*---------------------PROGRAMA PRINCIPAL-------------------------------------*)
var
   opcion: integer;
   salir: boolean;
   personas: tPersonas;
   dimension: integer;
Begin
     repeat
           salir:= false;
           opcion:= mostrarMenu();

           case opcion of
                1: ListarAgenda(AGENDA_ORIGINAL); 
                2: almacenarRegistros(personas, AGENDA_ORIGINAL, dimension, MAXLISTA); 
				3: ordenarElementos (personas, dimension);
                4: listarDeArreglo (personas, dimension);
                5: generarAgendaOrdenada (personas,dimension);
                6: ListarAgenda(AGENDA_ORDENADA);
                7: salir := true;


           end;
     until salir or not confirma('Desea Continuar? S/N');
End.
