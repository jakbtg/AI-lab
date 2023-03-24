impiegato(gigi; edo; nikkaz; tommi).
incarico(apertura; chiusura; pulizia).

% ogni impiegato può avere tra 0 e n incarichi
0 {responsabile(X, I) : incarico(I)} :- impiegato(X).

% ogni incarico deve avere esattamente un responsabile
1 {responsabile(X, I) : impiegato(X)} 1 :- incarico(I).

% l'uso delle variabili in ASP è solo per comodità, ci permette di non dover scrivere
% tutte le possibili istanziazioni tipo:
% 1 {responsabile(gigi, I)} 1 :- incarico(I)
% e così via per tutti i fatti che ho.
% quindi utilizzo le variabili, ma ASP in realtà le istanzia subito (grounding).

#show responsabile/2.