% Definisco la strategia di ricerca
prova(Cammino) :- iniziale(S), risolvi(S, Cammino, []), write(Cammino).

risolvi(S, [], _) :- goal(S), !.

risolvi(Stato, [Azione|ListaAzioni], Visitati) :-
    applicabile(Azione, Stato),
    trasforma(Azione, Stato, NuovoStato),
    write(NuovoStato), nl,
    \+ member(NuovoStato, Visitati),
    risolvi(NuovoStato, ListaAzioni, [NuovoStato|Visitati]).



