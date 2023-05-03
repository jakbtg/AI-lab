% Inizializzazione del programma
initialize(Iniziale, Goal) :- 
    retractall(current_depth(_)), assert(current_depth(1)),
    retractall(statoIniziale(_)),
    initialStateAssignment(Iniziale, StatoIniziale),
    assert(statoIniziale(StatoIniziale)),
    retractall(statoFinale(_)),
    goalStateAssignment(Goal, StatoFinale),
    assert(statoFinale(StatoFinale)).

% Definizione dei luoghi di partenza e di arrivo
initialStateAssignment(Iniziale, StatoIniziale) :-
    luogo(Iniziale, X), 
    StatoIniziale = X.
goalStateAssignment(Goal, StatoFinale) :-
    luogo(Goal, X), 
    StatoFinale = X.

% Definisco la strategia di ricerca
prova(Cammino) :-
    statoIniziale(S),
    current_depth(P),
    risolvi(S, Cammino, [], P),
    stampaCammino(Cammino),
    length(Cammino, L),
    write('Lunghezza cammino: '), write(L), !.
% Ho inserito il cut finale per trovare solamente il primo cammino 
% (utile per la ricerca di tutti i cammini tra tutti i luoghi)

% Passo ricorsivo: proseguo incrementando la profondità
prova(Cammino) :-
    current_depth(P),
    P < 100,
    NuovaProfondita is P + 1,
    retractall(current_depth(_)),
    assert(current_depth(NuovaProfondita)),
    prova(Cammino).

% Definisco la strategia di ricerca
% prova(Cammino) :- iniziale(S), risolvi(S, Cammino, [], 25), stampaCammino(Cammino), length(Cammino, L), write('Lunghezza cammino: '), write(L).

% Caso base: se sono arrivato allo stato finale, non devo fare niente
risolvi(S, [], _, _) :- statoFinale(S), !.
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

% Trova tutti i percorsi tra tutti i luogi presenti
trovaTutti(Cammino) :-
    luogo(X, _),
    luogo(Y, _),
    X \= Y,
    nl, write('----------------------------------------------------------------------------------------------'), nl,
    format('Trovo il cammino tra ~w e ~w \n', [X, Y]),
    initialize(X, Y),
    prova(Cammino), nl, nl.