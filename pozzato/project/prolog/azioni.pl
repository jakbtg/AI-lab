%%%%%%%%%% AZIONI APPLICABILI %%%%%%%%%%
applicabile(sali, stato(_, Posizione, _)) :-
    Posizione == "in_stazione".

applicabile(scendi, stato(Stazione, Posizione, _)) :-
    Posizione == "in_metro",
    \+ statoIniziale(stato(Stazione, _, _)),
    (finale(Stazione); cambio(Stazione); statoFinale(stato(Stazione, _, _))).

applicabile(aspetta, stato(Stazione, Posizione, _)) :-
    Posizione == "in_metro",
    (statoIniziale(stato(Stazione, _, _)); \+ finale(Stazione)).



% AZIONE CON EURISTICA --- OLD VERSION
% In pratica se non è una stazione di cambio vuol dire che posso proseguire solamente su una linea.
% Se invece è una stazione di cambio provo se proseguendo su questa linea mi avvicino di più alla stazione finale,
% altrimenti la scarto.
% applicabile(aspetta, stato(Stazione, Posizione, Linea)) :-
%     Posizione == "in_metro",
%     (statoIniziale(stato(Stazione, _, _)); \+ finale(Stazione)),
%     (\+ cambio(Stazione); euristica(Stazione, Linea)).
% Euristica - se è vera vuol dire che la stazione successiva è più vicina alla stazione finale e quindi posso proseguire
% euristica(Stazione, Linea) :-
%     trovaStazioneFinale(StazioneFinale),
%     successiva(Stazione, Linea, StazioneSuccessiva),
%     manhattan(Stazione, StazioneFinale, D1),
%     manhattan(StazioneSuccessiva, StazioneFinale, D2),
%     D2 =< D1.



%%%%%%%%%% TRASFORMAZIONI DI STATO %%%%%%%%%%
trasforma(sali, stato(Stazione, _, _), stato(Stazione, NuovaPosizione, NuovaLinea), Azione) :-
    NuovaPosizione = "in_metro",
    trovaLinea(Stazione, NuovaLinea),
    Azione = ["Sali sulla linea", NuovaLinea, "alla fermata", Stazione].

% trasforma(sali, stato(Stazione, _, _), stato(Stazione, NuovaPosizione, NuovaLinea), Azione) :-
%     NuovaPosizione = "in_metro",
%     euristica(Stazione, Linee),
%     member(NuovaLinea, Linee),
%     Azione = ["Sali sulla linea", NuovaLinea, "alla fermata", Stazione].

trasforma(aspetta, stato(Stazione, Posizione, Linea), stato(NuovaStazione, Posizione, Linea), Azione) :-
    successiva(Stazione, Linea, NuovaStazione),
    Azione = ["Prosegui sulla linea", Linea, "verso la fermata", NuovaStazione].

trasforma(scendi, stato(Stazione, _, Linea), stato(Stazione, NuovaPosizione, NuovaLinea), Azione) :-
    NuovaPosizione = "in_stazione",
    NuovaLinea = "nessuna",
    Azione = ["Scendi dalla linea", Linea, "alla fermata", Stazione].



%%%%%%%%%% EURISTICA %%%%%%%%%%
% Restituisce la lista delle linee disponibili ordinate in base alla distanza di manhattan della ipotetica 
% stazione successiva della linea corrispondente alla stazione finale.
% Viene applicata con l'azione sali, in modo da provare a salire sulla line più promettente.
euristica(Stazione, ListaLinee) :-
    findall(Linea, trovaLinea(Stazione, Linea), Linee),
    generaStazioniSuccessive(Stazione, Linee, StazioniSuccessive),
    trovaStazioneFinale(StazioneFinale),
    generaDistanze(StazioniSuccessive, StazioneFinale, Distanze),
    associaDistanze(Linee, Distanze, Associazioni),
    ordinaLinee(Associazioni, LineeOrdinate),
    ListaLinee = LineeOrdinate.

% Genera le stazioni successive di una lista di linee   
generaStazioniSuccessive(_, [], []).
generaStazioniSuccessive(Stazione, [Linea|AltreLinee], [StazioneSuccessiva|AltreStazioni]) :-
    successiva(Stazione, Linea, StazioneSuccessiva),
    generaStazioniSuccessive(Stazione, AltreLinee, AltreStazioni).

% Calcola la distanza di manhattan tra la lista di stazioni successive e la stazione finale
generaDistanze([], _, []).
generaDistanze([StazioneSuccessiva|AltreStazioni], StazioneFinale, [Distanza|AltreDistanze]) :-
    manhattan(StazioneSuccessiva, StazioneFinale, Distanza),
    generaDistanze(AltreStazioni, StazioneFinale, AltreDistanze).

% Associa le distanze alle linee 
associaDistanze([], [], []).
associaDistanze([Linea|AltreLinee], [Distanza|AltreDistanze], [Associazione|AltreAssociazioni]) :-
    Associazione = (Linea, Distanza),
    associaDistanze(AltreLinee, AltreDistanze, AltreAssociazioni).

% Trova la linea migliore in base alla distanza di manhattan dalla stazione finale
trovaLineaMigliore([(Linea, Distanza)], LineaMigliore, DistanzaMigliore) :-
    LineaMigliore = Linea,
    DistanzaMigliore = Distanza.
trovaLineaMigliore([(Linea, Distanza)|AltreAssociazioni], LineaMigliore, DistanzaMigliore) :-
    trovaLineaMigliore(AltreAssociazioni, AltraLinea, AltraDistanza),
    (Distanza < AltraDistanza -> LineaMigliore = Linea, DistanzaMigliore = Distanza;
    LineaMigliore = AltraLinea, DistanzaMigliore = AltraDistanza).
    
% Ordina le linee in base alla distanza di manhattan dalla stazione finale
ordinaLinee([], []).
ordinaLinee(Associazioni, LineeOrdinate) :-
    length(Associazioni, L),
    L > 0,
    trovaLineaMigliore(Associazioni, LineaMigliore, DistanzaMigliore),
    append([LineaMigliore], LineeOrdinateTemp, LineeOrdinate),
    delete(Associazioni, (LineaMigliore, DistanzaMigliore), AssociazioniRimanenti),
    ordinaLinee(AssociazioniRimanenti, LineeOrdinateTemp).



%%%%%%%%%%% FUNZIONI DI UTILITÀ %%%%%%%%%%%
% Trova le linee di una stazione
trovaLinea(Stazione, Linea) :- 
    linea(X, Y, Fermate), member(Stazione, Fermate), Linea = (X, Y).

% Trova la fermata successiva
successiva(Stazione, Linea, StazioneSuccessiva) :-
    fermateLinea(Linea, Fermate),
    nth0(Index, Fermate, Stazione),
    Index1 is Index + 1,
    length(Fermate, L),
    (Index1 < L, nth0(Index1, Fermate, StazioneSuccessiva); 
    StazioneSuccessiva = Stazione).

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