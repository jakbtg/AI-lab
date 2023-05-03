% Inizializzazione del programma
initialize :- retractall(current_depth(_)), assert(current_depth(1)).

% Definisco la strategia di ricerca
prova(Cammino) :-
    iniziale(S),
    current_depth(P),
    risolvi(S, Cammino, [], P),
    stampaCammino(Cammino),
    length(Cammino, L),
    write('Lunghezza cammino: '), write(L).

% Passo ricorsivo: proseguo incrementando la profondità
prova(Cammino) :-
    current_depth(P),
    P < 50,
    NuovaProfondita is P + 1,
    retractall(current_depth(_)),
    assert(current_depth(NuovaProfondita)),
    prova(Cammino).

% Definisco la strategia di ricerca
% prova(Cammino) :- iniziale(S), risolvi(S, Cammino, [], 25), stampaCammino(Cammino), length(Cammino, L), write('Lunghezza cammino: '), write(L).

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