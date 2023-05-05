% Definisco le azioni che possono essere applicate in un certo stato
applicabile(sali, stato(_, Posizione, _)) :-
    Posizione == "in_stazione".

applicabile(scendi, stato(Stazione, Posizione, _)) :-
    Posizione == "in_metro",
    \+ statoIniziale(stato(Stazione, _, _)),
    (finale(Stazione); cambio(Stazione,_); statoFinale(stato(Stazione, _, _))).

% AZIONE CON EURISTICA
applicabile(aspetta, stato(Stazione, Posizione, Linea)) :-
    Posizione == "in_metro",
    (statoIniziale(stato(Stazione, _, _)); \+ finale(Stazione)),
    trovaStazioneFinale(StazioneFinale),
    successiva(Stazione, Linea, StazioneSuccessiva),
    manhattan(Stazione, StazioneFinale, D1),
    manhattan(StazioneSuccessiva, StazioneFinale, D2),
    (D2 =< D1; numeroLinee(Stazione, N), N == 2).

% AZIONE SENZA EURISTICA
% applicabile(aspetta, stato(Stazione, Posizione, _)) :-
%     Posizione == "in_metro",
%     (statoIniziale(stato(Stazione, _, _)); \+ finale(Stazione)).
    


% Definisco le transizioni
trasforma(sali, stato(Stazione, _, _), stato(Stazione, NuovaPosizione, NuovaLinea), Azione) :-
    NuovaPosizione = "in_metro",
    trovaLinea(Stazione, NuovaLinea),
    Azione = ["Sali sulla linea", NuovaLinea, "alla fermata", Stazione].

trasforma(aspetta, stato(Stazione, Posizione, Linea), stato(NuovaStazione, Posizione, Linea), Azione) :-
    successiva(Stazione, Linea, NuovaStazione),
    Azione = ["Prosegui sulla linea", Linea, "verso la fermata", NuovaStazione].

trasforma(scendi, stato(Stazione, _, Linea), stato(Stazione, NuovaPosizione, NuovaLinea), Azione) :-
    NuovaPosizione = "in_stazione",
    NuovaLinea = "nessuna",
    Azione = ["Scendi dalla linea", Linea, "alla fermata", Stazione].



%%%%%%%%%%% FUNZIONI DI UTILITÀ %%%%%%%%%%%
% Funzione di utilità per trovare la linea di una stazione
trovaLinea(Stazione, Linea) :- 
    linea(X, Y, Fermate), member(Stazione, Fermate), Linea = (X, Y).

% Funzione di utilità per trovare la fermata successiva
successiva(Stazione, Linea, StazioneSuccessiva) :-
    fermateLinea(Linea, Fermate),
    nth0(Index, Fermate, Stazione),
    Index1 is Index + 1,
    nth0(Index1, Fermate, StazioneSuccessiva).

% Funzione di utilità per trovare la lista di fermate di una linea
fermateLinea(Linea, Fermate) :- 
    linea(X, Y, Fermate), Linea = (X, Y).

% Calcola la distanza di Manhattan tra due fermate
manhattan(Stazione1, Stazione2, Distanza) :-
    posizione(Stazione1, pos(X1, Y1)),
    posizione(Stazione2, pos(X2, Y2)),
    Distanza is abs(X1 - X2) + abs(Y1 - Y2).

% Trova stazione dello stato finale
trovaStazioneFinale(Stazione) :-
    statoFinale(stato(Stazione, _, _)).

% Trova numero linee disponibili per una stazione
numeroLinee(Stazione, NumeroLinee) :-
    findall(Linea, trovaLinea(Stazione, Linea), LineeStazione),
    length(LineeStazione, NumeroLinee).