% Iterative Deepening Depth First Search
% il grosso problema è che se non c'è soluzione (tipo se gli ostacoli bloccano totalmente il robot) il programma non termina mai.

% inizializzazione: rimuovo tutte le possibili asserzioni di current_depth e ne inizializzo una nuova a 1.
initialize :- retractall(current_depth(_)), assert(current_depth(1)).

% prova a risolvere caso base
prova(Cammino) :- 
    iniziale(S0), 
    current_depth(D), % che sarà la profondità massima per questa esecuzione
    risolvi(S0, Cammino, [], D).

% passo ricorsivo: se non sono riuscito a risolvere con la profondità precedente, incremento la profondità e riprovo
prova(Cammino) :- 
    current_depth(D),
    NewD is D + 1,
    retractall(current_depth(_)), % cancello la profondità precedente
    assert(current_depth(NewD)), % asserisco la nuova profondità
    prova(Cammino). % riprovo ricorsivamente

risolvi(S, [], _, _) :- finale(S), !.
risolvi(S, [Azione|ListaAzioni], Visitati, ProfMax) :-
    ProfMax > 0,
    applicabile(Azione, S),
    trasforma(Azione, S, NuovoS),
    \+ member(NuovoS, Visitati),
    NuovaProfMax is ProfMax - 1,
    risolvi(NuovoS, ListaAzioni, [S|Visitati], NuovaProfMax).