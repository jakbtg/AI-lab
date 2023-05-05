%%%%%%%%%% AZIONI APPLICABILI %%%%%%%%%%
applicabile(sali, stato(_, Posizione, _)) :-
    Posizione == "in_stazione".

applicabile(scendi, stato(Stazione, Posizione, _)) :-
    Posizione == "in_metro",
    \+ statoIniziale(stato(Stazione, _, _)),
    (finale(Stazione); cambio(Stazione); statoFinale(stato(Stazione, _, _))).

% AZIONE CON EURISTICA
% In pratica se non è una stazione di cambio vuol dire che posso proseguire solamente su una linea.
% Se invece è una stazione di cambio provo se proseguendo su questa linea mi avvicino di più alla stazione finale,
% altrimenti la scarto.
applicabile(aspetta, stato(Stazione, Posizione, Linea)) :-
    Posizione == "in_metro",
    (statoIniziale(stato(Stazione, _, _)); \+ finale(Stazione)),
    (\+ cambio(Stazione); euristica(Stazione, Linea)).

% Euristica - se è vera vuol dire che la stazione successiva è più vicina alla stazione finale e quindi posso proseguire
euristica(Stazione, Linea) :-
    trovaStazioneFinale(StazioneFinale),
    successiva(Stazione, Linea, StazioneSuccessiva),
    manhattan(Stazione, StazioneFinale, D1),
    manhattan(StazioneSuccessiva, StazioneFinale, D2),
    D2 =< D1.

% AZIONE SENZA EURISTICA
% applicabile(aspetta, stato(Stazione, Posizione, _)) :-
%     Posizione == "in_metro",
%     (statoIniziale(stato(Stazione, _, _)); \+ finale(Stazione)).
    


%%%%%%%%%% TRASFORMAZIONI DI STATO %%%%%%%%%%
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
% Trova le linee di una stazione
trovaLinea(Stazione, Linea) :- 
    linea(X, Y, Fermate), member(Stazione, Fermate), Linea = (X, Y).

% Trova la fermata successiva
successiva(Stazione, Linea, StazioneSuccessiva) :-
    fermateLinea(Linea, Fermate),
    nth0(Index, Fermate, Stazione),
    Index1 is Index + 1,
    nth0(Index1, Fermate, StazioneSuccessiva).

% Trova la lista di fermate di una linea
fermateLinea(Linea, Fermate) :- 
    linea(X, Y, Fermate), Linea = (X, Y).

% Calcola la distanza di Manhattan tra due fermate
manhattan(Stazione1, Stazione2, Distanza) :-
    posizione(Stazione1, pos(X1, Y1)),
    posizione(Stazione2, pos(X2, Y2)),
    Distanza is abs(X1 - X2) + abs(Y1 - Y2).

% Trova la stazione dello stato finale
trovaStazioneFinale(Stazione) :-
    statoFinale(stato(Stazione, _, _)).