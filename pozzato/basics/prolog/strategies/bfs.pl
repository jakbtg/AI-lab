% Breadth-first search 
% Trova la soluzione ottima

% In questo modo la soluzione è giusta, ma al contrario quindi devo invertirla
prova(Cammino) :- iniziale(S), risolvi([[S, []]], [], CamminoAlContrario), inverti(CamminoAlContrario, Cammino).

% Inverti una lista
inv([], Temp, Temp).
inv([H|T], Temp, R) :- inv(T, [H|Temp], R).
inverti(L, R) :- inv(L, [], R).

% Caso base
% Se S è uno stato finale, ho finito! Il cammino è esattamente quello che si porta dietro la coppia [S, Path_to_S].
risolvi([[S, Path_to_S]|_], _, Path_to_S) :- finale(S), !.

% Se S non è uno stato finale, allora devo continuare a cercare
risolvi([[S, Path_to_S]|Tail], Visitati, Cammino) :-
    % Trovo tutti gli stati figli di S che non sono stati visitati
    findall(Az, applicabile(Az, S), AzioniApplicabili),
    % Genero tutti gli stati figli di S
    genera_stati_figli(S, AzioniApplicabili, Visitati, Path_to_S, ListaNuoviStati),
    % Aggiungo i successori alla lista di stati da visitare
    append(Tail, ListaNuoviStati, NuovaLista),
    risolvi(NuovaLista, [S|Visitati], Cammino).


% Se non ci sono azioni applicabili, allora non posso generare nuovi stati figli e quindi ritorno una lista vuota
genera_stati_figli(_, [], _, _, []) :- !.
genera_stati_figli(S, [Az|AltreAzioni], Visitati, Path_to_S, [[NuovoStato, [Az|Path_to_S]]|ListaStati]) :-
    % applico l'azione in testa
    trasforma(Az, S, NuovoStato),
    % controllo che il nuovo stato non sia già stato visitato
    \+ member(NuovoStato, Visitati), !,
    % chiamata ricorsiva
    genera_stati_figli(S, AltreAzioni, Visitati, Path_to_S, ListaStati).

% Se arrivo qui vuol dire che il nuovo stato è già stato visitato, ma devo proseguire con le altre azioni
genera_stati_figli(S, [_|AltreAzioni], Visitati, Path_to_S, ListaRisultato) :- 
    genera_stati_figli(S, AltreAzioni, Visitati, Path_to_S, ListaRisultato). 
