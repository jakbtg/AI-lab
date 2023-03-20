% Condizioni di applicabilità delle azioni
% applicabile(Azione, Stato)
applicabile(su, pos(Riga, Colonna)) :-
    Riga > 1,
    RigaSopra is Riga-1,
    \+ occupata(pos(RigaSopra, Colonna)).

applicabile(giu, pos(Riga, Colonna)) :-
    num_righe(NR),
    Riga < NR,
    RigaSotto is Riga+1,
    \+ occupata(pos(RigaSotto, Colonna)).

applicabile(dx, pos(Riga, Colonna)) :-
    num_colonne(NC),
    Colonna < NC,
    ColonnaDx is Colonna+1,
    \+ occupata(pos(Riga, ColonnaDx)).

applicabile(sx, pos(Riga, Colonna)) :-
    Colonna > 1,
    ColonnaSx is Colonna-1,
    \+ occupata(pos(Riga, ColonnaSx)).

% Trasformazione di uno stato in un altro per una data azione
% trasforma(Azione, Stato, NuovoStato)
trasforma(su, pos(Riga, Colonna), pos(RigaSopra, Colonna)) :- RigaSopra is Riga-1.
trasforma(giu, pos(Riga, Colonna), pos(RigaSotto, Colonna)) :- RigaSotto is Riga+1.
trasforma(dx, pos(Riga, Colonna), pos(Riga, ColonnaDx)) :- ColonnaDx is Colonna+1.
trasforma(sx, pos(Riga, Colonna), pos(Riga, ColonnaSx)) :- ColonnaSx is Colonna-1.