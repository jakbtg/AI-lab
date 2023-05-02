% Definisco la strategia di ricerca
prova(Cammino) :- iniziale(S), risolvi(S, Cammino, [], 20), write(Cammino), length(Cammino, L), nl, write(L).
% prova(Cammino) :- iniziale(S), trovaPercorso(S, Cammino, []), write(Cammino).

risolvi(S, [], _, _) :- goal(S), !.

risolvi(Stato, [Azione|ListaAzioni], Visitati, ProfMax) :-
    ProfMax > 0,
    applicabile(Az, Stato),
    trasforma(Az, Stato, NuovoStato, Azione),
    \+ member(NuovoStato, Visitati),
    NuovaProfMax is ProfMax - 1,
    risolvi(NuovoStato, ListaAzioni, [NuovoStato|Visitati], NuovaProfMax).


% prova con trovaPercorso
% trovaPercorso(Stato, []) :- goal(Stato), !.
% trovaPercorso(Stato, [Azione|ListaAzioni]).
    


    



