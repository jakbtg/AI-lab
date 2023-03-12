% somma degli elementi di una lista
% Fatto base
somma([],0). % somma di una lista vuota è 0
% Regola induttiva
somma([Head|Tail], R) :- somma(Tail, N), R is Head + N. 