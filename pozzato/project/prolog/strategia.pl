% Definisco la strategia di ricerca
prova(Cammino) :- iniziale(S), risolvi(S, Cammino, []), write(Cammino).
% prova(Cammino) :- iniziale(S), trovaPercorso(S, Cammino, []), write(Cammino).

risolvi(S, [], _) :- goal(S), !.

risolvi(Stato, [Azione|ListaAzioni], Visitati) :-
    applicabile(Azione, Stato),
    trasforma(Azione, Stato, NuovoStato),
    \+ member(NuovoStato, Visitati),
    write(NuovoStato), nl,
    risolvi(NuovoStato, ListaAzioni, [NuovoStato|Visitati]).


% prova con trovaPercorso
% trovaPercorso(Stato, []) :- goal(Stato), !.
% trovaPercorso(Stato, [Azione|ListaAzioni]).
    


    



