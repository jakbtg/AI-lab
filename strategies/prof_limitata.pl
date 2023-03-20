% inserendo il limite manualmente si limita la profondità di ricerca:
% se limite = 20, prova tutti i cammini di lunghezza massima 20 e basta
% in questo modo partendo col limite a 1 e incrementandolo di 1 ad ogni iterazione
% si ottiene la soluzione ottima - questo metodo corrisponde all'iterative deepening.

% creo predicato per fare l'invocazione corretta a risolvi
prova(Cammino, Limite) :- iniziale(S0), risolvi(S0, Cammino, [], Limite), write(Cammino).

risolvi(S, [], _, _) :- finale(S), !.
risolvi(S, [Azione|ListaAzioni], Visitati, ProfMax) :-
    ProfMax > 0,
    applicabile(Azione, S),
    trasforma(Azione, S, NuovoS),
    \+ member(NuovoS, Visitati),
    NuovaProfMax is ProfMax - 1,
    risolvi(NuovoS, ListaAzioni, [S|Visitati], NuovaProfMax).