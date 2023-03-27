prova(Cammino) :- iniziale(S), risolvi([[S, []]], [], Cammino).

% risolvi([[S, Path_to_S]|Tail], Visitati, Cammino)

% Caso base
% Se S è uno stato finale, ho finito! Il cammino è esattamente quello che si porta dietro la coppia [S, Path_to_S].
risolvi([[S, Path_to_S]|_], _, Path_to_S) :- finale(S), !.