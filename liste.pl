% somma degli elementi di una lista
% Fatto base
somma([],0). % somma di una lista vuota è 0
% Regola induttiva
somma([Head|Tail], R) :- somma(Tail, N), R is Head + N.

% prodotto degli elementi di una lista
prodotto([],0). % prodotto di una lista vuota è 0
prodotto([X],X). % prodotto di una lista con un solo elemento è il valore di quel elemento

prodotto([Head|Tail], Res) :- prodotto(Tail, N), Res is Head * N.

% proviamo a scrivere un nostro predicato "appartiene" = member
% parto cercando dei casi base
% se X è uguale al primo elemento della lista, allora X appartiene alla lista
appartiene(X, [X|_]). 
% se X non è uguale al primo elemento della lista, allora X appartiene alla lista se appartiene alla coda della lista
appartiene(X, [_|Tail]) :- appartiene(X, Tail).