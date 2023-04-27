% Definisco le azioni che possono essere applicate in un certo stato
applicabile(scendi, stazione(S)) :- 
    stato(sulla_metro).

applicabile(sali, stazione(S)) :-
    stato(in_stazione).

applicabile(aspetta, stazione(S)) :-
    stato(sulla_metro),
    \+ finale(stazione(S)).


% Definisco le transizioni
trasforma(scendi, Stazione, Stazione) :-
    retract(stato(sulla_metro)),
    assert(stato(in_stazione)).

trasforma(sali, Stazione, Stazione) :-
    retract(stato(in_stazione)),
    assert(stato(sulla_metro)).

trasforma(aspetta, Stazione, Stazione) :-
    true.
