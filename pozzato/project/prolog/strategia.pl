% Definisco la strategia di ricerca
prova(Cammino) :- iniziale(S), risolvi(S, Cammino, [], 25), stampaCammino(Cammino), length(Cammino, L), write('Lunghezza cammino: '), write(L).

% Definisco la strategia di ricerca
% Caso base: se sono arrivato allo stato finale, non devo fare niente
risolvi(S, [], _, _) :- goal(S), !.
% Caso ricorsivo: se non sono arrivato allo stato finale, continuo a cercare
risolvi(Stato, [Azione|ListaAzioni], Visitati, ProfMax) :-
    ProfMax > 0,
    applicabile(Az, Stato),
    trasforma(Az, Stato, NuovoStato, Azione),
    \+ member(NuovoStato, Visitati),
    NuovaProfMax is ProfMax - 1,
    risolvi(NuovoStato, ListaAzioni, [NuovoStato|Visitati], NuovaProfMax).

% Stampa il cammino formattato
stampaCammino([]).
stampaCammino([Azione|ListaAzioni]) :-
    format('~w ~w ~w ~w \n', Azione),
    stampaCammino(ListaAzioni).
    
    

    
    
    


    



