% Strategia per muoversi nel labirinto
% se sono in uno stato finale, non devo fare nulla
risolvi(S, [], _) :- finale(S), !.
% il passo induttivo invece cerca un'azione applicabile, la applica e chiama nuovamente la strategia sul nuovo stato
risolvi(S, [Azione|ListaAzioni], Visitati) :-
    % qui salva tutte le possibili strade percorribili, ovvero le varie azioni applicabili nello stato S
    % il backtracking è intrinseco a Prolog, non serve esplicitarlo
    applicabile(Azione, S),
    trasforma(Azione, S, NuovoS),
    % se il nuovo stato non è stato già visitato allora procedo
    \+ member(NuovoS, Visitati),
    % passo ricorsivo, in cui aggiungo lo stato di partenza alla lista dei visitati
    risolvi(NuovoS, ListaAzioni, [S|Visitati]).
