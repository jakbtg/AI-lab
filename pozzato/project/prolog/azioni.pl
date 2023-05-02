% Definisco le azioni che possono essere applicate in un certo stato
applicabile(sali, stato(_, Posizione, _)) :-
    Posizione == "in_stazione".

applicabile(scendi, stato(Stazione, Posizione, _)) :-
    Posizione == "in_metro",
    (finale(Stazione); cambio(Stazione,_)).

applicabile(aspetta, stato(Stazione, Posizione, _)) :-
    \+ finale(Stazione),
    Posizione == "in_metro".


% Definisco le transizioni
trasforma(sali, stato(Stazione, _, _), stato(Stazione, NuovaPosizione, NuovaLinea), Azione) :-
    NuovaPosizione = "in_metro",
    trovaLinea(Stazione, NuovaLinea),
    Azione = format("Sali sulla linea ~w alla fermata ~w", [NuovaLinea, Stazione]).
    
    

trasforma(aspetta, stato(Stazione, Posizione, Linea), stato(NuovaStazione, Posizione, Linea), Azione) :-
    successiva(Stazione, Linea, NuovaStazione),
    Azione = format("Prosegui sulla linea ~w alla fermata ~w", [Linea, NuovaStazione]).

trasforma(scendi, stato(Stazione, _, _), stato(Stazione, NuovaPosizione, NuovaLinea), Azione) :-
    NuovaPosizione = "in_stazione",
    NuovaLinea = "nessuna",
    Azione = format("Scendi alla fermata ~w", [Stazione]).


% Funzione di utilità per trovare la linea di una stazione
trovaLinea(Stazione, Linea) :- 
    linea(X, Y, Fermate), member(Stazione, Fermate), Linea = (X, Y).

% Funzione di utilità per trovare la fermata successiva
successiva(Stazione, Linea, StazioneSuccessiva) :-
    \+ finale(Stazione),
    fermateLinea(Linea, Fermate),
    nth0(Index, Fermate, Stazione),
    Index1 is Index + 1,
    nth0(Index1, Fermate, StazioneSuccessiva).

% Funzione di utilità per trovare la lista di fermate di una linea
fermateLinea(Linea, Fermate) :- 
    linea(X, Y, Fermate), Linea = (X, Y).

% Funzione di utilità per trovare la stazione dato uno stato
trovaStazione(stato(S, _, _), Stazione) :- Stazione = S.

% Funzione di utilità per trovare la linea dato uno stato se l'azione è sali
trovaLineaStatoAttuale(stato(_, _, L), Azione, Linea) :- 
    Azione == sali, 
    Linea = L.

