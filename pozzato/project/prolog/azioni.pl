% Definisco le azioni che possono essere applicate in un certo stato
applicabile(scendi, Stazione) :- 
    stato(sulla_metro).

applicabile(sali, Stazione) :-
    stato(in_stazione).

applicabile(aspetta, Stazione) :-
    stato(sulla_metro).

% Definisco le transizioni
trasforma(scendi, Stazione, Stazione) :-
    retract(stato(sulla_metro)),
    assert(stato(in_stazione)).

trasforma(sali, Stazione, Stazione) :-
    retract(stato(in_stazione)),
    assert(stato(sulla_metro)).

trasforma(aspetta, Stazione, Stazione) :-
    true.
