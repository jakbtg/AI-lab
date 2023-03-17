% creo predicato per fare l'invocazione corretta a risolvi
prova(Cammino) :- iniziale(S0), risolvi(S0, Cammino, [], 30), write(Cammino).

risolvi(S, [], _, _) :- finale(S), !.
risolvi(S, [Azione|ListaAzioni], Visitati, ProfMax) :-
    ProfMax > 0,
    applicabile(Azione, S),
    trasforma(Azione, S, NuovoS),
    \+ member(NuovoS, Visitati),
    NuovaProfMax is ProfMax - 1,
    risolvi(NuovoS, ListaAzioni, [S|Visitati], NuovaProfMax).