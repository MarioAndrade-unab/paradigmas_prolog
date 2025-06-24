% Predicado principal
main :-
    write('Sistema de Gestión de Calorías para el Restaurante "Mi Mejor Comida"'), nl,
    write('======================================================'), nl,
    menu.

% Base de Conocimientos
entrada(paella, 200).
entrada(gazpacho, 150).
entrada(pasta, 300).
entrada(ensalada_cesar, 180).
entrada(sopa_verduras, 120).

principal(filete_cerdo, 400).
principal(pollo_asado, 280).
principal(bistec_pobre, 500).
principal(trucha, 160).
principal(bacalao, 300).
principal(salmon_plancha, 350).
principal(lasagna, 450).

postre(flan, 200).
postre(naranja, 50).
postre(nueces, 500).
postre(yogurt, 100).
postre(helado, 250).


% Menú de opciones
menu :-
    repeat,
    write('BIENVENIDO A "MI MEJOR COMIDA"'), nl,
    write('--------------------------------------'), nl,
    write('1. Calcular calorías de un menú específico'), nl,
    write('2. Mostrar combinaciones bajas en calorías'), nl,
    write('3. Salir'), nl,
    write('Seleccione una opción (1-3): '),
    read(Opcion),
    (
        Opcion == 1 -> calcular_calorias_menu, fail;
        Opcion == 2 -> mostrar_combinaciones_bajas, fail;
        Opcion == 3 -> write('Gracias por usar el sistema. Adiós.'), nl, !;
        write('Opción inválida. Intente de nuevo.'), nl, fail
    ).

% Calcular Calorías del Menú
calcular_calorias_menu :-
    write('--- CÁLCULO DE CALORÍAS DEL MENÚ ---'), nl,
    pedir_entrada(Entrada, CalE),
    pedir_principal(Principal, CalP),
    pedir_postre(Postre, CalPo),
    Total is CalE + CalP + CalPo,
    nl,
    write('Menú seleccionado:'), nl,
    format('* Entrada: ~w (~w cal)~n', [Entrada, CalE]),
    format('* Principal: ~w (~w cal)~n', [Principal, CalP]),
    format('* Postre: ~w (~w cal)~n', [Postre, CalPo]),
    format('TOTAL: ~w calorías~n', [Total]).

pedir_entrada(Entrada, Cal) :-
    repeat,
    write('Ingrese una entrada: '),
    read_line_to_string(user_input, Input),
    normalize_space(atom(E), Input), 
    ( entrada(E, C) ->
        Entrada = E, Cal = C, !
    ; write('Entrada no válida. Intente de nuevo.'), nl, fail
    ).

pedir_principal(Principal, Cal) :-
    repeat,
    write('Ingrese un plato principal: '),
    read_line_to_string(user_input, Input),
    normalize_space(string(Limpio), Input),
    reemplazar_espacios_por_guiones(Limpio, P),
    ( principal(P, C) ->
        Principal = P, Cal = C, !
    ; write('Principal no válido. Intente de nuevo.'), nl, fail
    ).

pedir_postre(Postre, Cal) :-
    repeat,
    write('Ingrese un postre: '),
    read_line_to_string(user_input, Input),
    normalize_space(atom(Po), Input), 
    ( postre(Po, C) ->
        Postre = Po, Cal = C, !
    ; write('Postre no válido. Intente de nuevo.'), nl, fail
    ).

reemplazar_espacios_por_guiones(String, Resultado) :-
    string_chars(String, Chars),
    reemplazar_espacios_en_chars(Chars, CharsConGuion),
    atom_chars(Resultado, CharsConGuion).

reemplazar_espacios_en_chars([], []).
reemplazar_espacios_en_chars([' '|T1], ['_'|T2]) :-
    reemplazar_espacios_en_chars(T1, T2).
reemplazar_espacios_en_chars([C|T1], [C|T2]) :-
    C \= ' ',
    reemplazar_espacios_en_chars(T1, T2).


% Combinaciones Bajas en Calorías
mostrar_combinaciones_bajas :-
    write('--- MENÚS BAJOS EN CALORÍAS ---'), nl,
    pedir_limite_valido(Limite),
    nl,
    write('Combinaciones disponibles con menos de '), write(Limite), write(' calorías:'), nl, nl,
    buscar_combinaciones(Limite),
    !.

buscar_combinaciones(Limite) :-
    entrada(E, CalE),
    principal(P, CalP),
    postre(Po, CalPo),
    Total is CalE + CalP + CalPo,
    Total =< Limite,
    format('* Entrada: ~w (~w cal)~n', [E, CalE]),
    format('  Principal: ~w (~w cal)~n', [P, CalP]),
    format('  Postre: ~w (~w cal)~n', [Po, CalPo]),
    format('  TOTAL: ~w calorías~n~n', [Total]),
    fail.
buscar_combinaciones(_).  % Para terminar tras fail.

% Pedir límite con validación robusta
pedir_limite_valido(Limite) :-
    repeat,
    write('Ingrese el máximo de calorías deseado: '),
    read(Input),
    (
        number(Input),
        integer(Input),
        Input > 0 ->
            Limite = Input, !
        ;
        write('Valor inválido. Debe ser un número entero positivo.'), nl,
        fail
    ).
