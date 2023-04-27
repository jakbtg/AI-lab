% Definisco la strategia di ricerca
prova(Cammino) :- iniziale(S), risolvi(S, Cammino, []), write(Cammino).

risolvi(S, [], _) :- finale(S), !.

risolvi(S, [Azione|ListaAzioni], Visitati) :-
    applicabile(Azione, S),
    trasforma(Azione, S, SNuovo),
    \+ member(SNuovo, Visitati),
    risolvi(SNuovo, ListaAzioni, [S|Visitati]).



