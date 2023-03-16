% Strategia per muoversi nel labirinto
risolvi(S, []) :- finale(S), !.
risolvi(S, [Azione|ListaAzioni]) :-
    applicabile(Azione, S),
    trasforma(Azione, S, NuovoS),
    risolvi(NuovoS, ListaAzioni).