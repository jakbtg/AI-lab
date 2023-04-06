% PROGETTO - ASP
% ------------------------------------------------
% Generazione calendario di una competizione sportiva, con le seguenti caratteristiche:
%  1. sono iscritte 20 squadre; 
%  2. il campionato prevede 38 giornate, 19 di andata e 19 di ritorno NON simmetriche, ossia la giornata 1 di ritorno non coincide 
%     necessariamente con la giornata 1 di andata a campi invertiti;  
%  3. ogni squadra fa riferimento ad una città, che offre la struttura in cui la squadra gioca gli incontri in casa; 
%  4. ogni squadra affronta due volte tutte le altre squadre, una volta in casa e una volta fuori casa, ossia una volta nella 
%     propria città di riferimento e una volta in quella dell’altra squadra; 
%  5. due delle 20 squadre fanno riferimento alla medesima città e condividono la stessa struttura di gioco, quindi non possono 
%     giocare entrambe in casa nella stessa giornata. Ovviamente, fanno eccezione le due giornate in cui giocano l’una 
%     contro l’altra (derby).
%
% Vincoli facoltativi:
%  6. ciascuna squadra non deve giocare mai più di due partite consecutive in casa o fuori casa;
%  7. la distanza tra una coppia di gare di andata e ritorno è di almeno 10 giornate, ossia se SquadraA vs SquadraB è programmata 
%     per la giornata 12, il ritorno SquadraB vs SquadraA verrà schedulato non prima dalla giornata 22. 
% ------------------------------------------------

% Regola 1
% Squadre partecipanti
% squadra(napoli; milan; inter; juventus; atalanta; roma; lazio; fiorentina; sassuolo; torino; udinese; bologna; monza; empoli; salernitana; lecce; spezia; hellas_verona; sampdoria; cremonese).

% % Regola 3
% % Città di riferimento delle squadre
% in(napoli, napoli).
% in(milan, milano).
% in(inter, milano).
% % Dato che solo due squadre fanno riferimento alla stessa città inserirò per juventus la città juventus
% in(juventus, juventus).
% in(atalanta, bergamo).
% in(roma, roma).
% % Dato che solo due squadre fanno riferimento alla stessa città inserirò per lazio la città lazio
% in(lazio, lazio).
% in(fiorentina, firenze).
% in(sassuolo, sassuolo).
% in(torino, torino).
% in(udinese, udine).
% in(bologna, bologna).
% in(monza, monza).
% in(empoli, empoli).
% in(salernitana, salerno).
% in(lecce, lecce).
% in(spezia, spezia).
% in(hellas_verona, verona).
% in(sampdoria, genova).
% in(cremonese, cremona).

% % Ci sono 38 giornate
% giornata(1..38).

% % Regola 4
% % Ogni squadra affronta due volte tutte le altre squadre:
% % in questo modo vengono generate 19 partite in casa per ogni squadra
% % ma dato che ogni squadra compare poi anche in trasferta esattamente una volta per ogni avversaria,
% % ogni squadra compare esattamente 38 volte in totale, ovvero affronta tutte le altre squadre 2 volte,
% % una volta in casa e una volta in trasferta. Con la condizione S1 <> S2 elimino i modelli in cui una squadra affronta se stessa
% 19 {partita(S1, S2) : squadra(S2), S1 <> S2} 19 :- squadra(S1).


% % Regola 2
% % Ogni partita avviene in una giornata
% 1 {assegna(partita(S1, S2), G) : giornata(G)} 1 :- partita(S1, S2).
% % Ogni giornata ha 10 partite
% 10 {assegna(partita(S1, S2), G) : partita(S1,S2)} 10 :- giornata(G).
% % Ogni squadra gioca una sola partita per giornata
% % Ogni squadra gioca una sola partita in casa per giornata
% :- assegna(partita(S1, S2), G), assegna(partita(S1, S3), G), S2 <> S3.
% % Ogni squadra gioca una sola partita in trasferta per giornata
% :- assegna(partita(S2, S1), G), assegna(partita(S3, S1), G), S2 <> S3.
% % Se una squadra gioca in casa in una giornata, non può giocare in trasferta in quella stessa giornata
% :- assegna(partita(S1, _), G), assegna(partita(_, S1), G).
% % Conto le partite in casa ed elimino modelli in cui una squadra gioca più di una partita in casa nella stessa giornata
% % conta_partite_casa(S1, G, N) :- assegna(partita(S1, _), G), N = #count{S2 : assegna(partita(S1, S2), G)}.
% % :- squadra(S1), giornata(G), conta_partite_casa(S1, G, N), N > 1.
% % Conto le partite in trasferta ed elimino modelli in cui una squadra gioca più di una partita in trasferta nella stessa giornata
% % conta_partite_trasferta(S1, G, N) :- assegna(partita(_, S1), G), N = #count{S2 : assegna(partita(S2, S1), G)}.
% % :- squadra(S1), giornata(G), conta_partite_trasferta(S1, G, N), N > 1.

% % Regola 5
% % Squadre della stessa città non possono giocare entrambe in casa nella stessa giornata a meno che non giochino l'una contro l'altra
% :- assegna(partita(S1, _), G), assegna(partita(S2, _), G), in(S1, C), in(S2, C), S1 <> S2.
% % conta_partite_stessa_citta(S1, G, N) :- assegna(partita(S1, _), G), in(S1, C), N = #count{S2 : assegna(partita(S2, _), G), in(S2, C)}.
% % :- squadra(S1), giornata(G), in(S1, C), conta_partite_stessa_citta(S1, G, N), N > 1.


% % ---------------------------------------------------------------------------------------------
% % Vincoli facoltativi
% % ---------------------------------------------------------------------------------------------

% % Regola 7
% % La distanza tra una coppia di gare di andata e ritorno è di almeno 10 giornate
% % :- assegna(partita(S1, S2), G1), assegna(partita(S2, S1), G2), G1 < G2, G2 - G1 < 5.

% % Regola 6
% % Ciascuna squadra non gioca più di due partite consecutive in casa o fuori casa
% % :- G > 2, assegna(partita(S1, _), G), assegna(partita(S1, _), G-1), assegna(partita(S1, _), G-2).
% % :- G > 2, assegna(partita(_, S1), G), assegna(partita(_, S1), G-1), assegna(partita(_, S1), G-2).
% % Prova con 3 partite consecutive per rilassare il vincolo
% % :- G > 3, assegna(partita(S1, _), G), assegna(partita(S1, _), G-1), assegna(partita(S1, _), G-2), assegna(partita(S1, _), G-3).
% % :- G > 3, assegna(partita(_, S1), G), assegna(partita(_, S1), G-1), assegna(partita(_, S1), G-2), assegna(partita(_, S1), G-3).
% % Prova con 4 partite consecutive per rilassare il vincolo
% % :- G > 4, assegna(partita(S1, _), G), assegna(partita(S1, _), G-1), assegna(partita(S1, _), G-2), assegna(partita(S1, _), G-3), assegna(partita(S1, _), G-4).
% % :- G > 4, assegna(partita(_, S1), G), assegna(partita(_, S1), G-1), assegna(partita(_, S1), G-2), assegna(partita(_, S1), G-3), assegna(partita(_, S1), G-4).


% ---------------------------------------------------------------------------------------------
% Prove per velocizzare il calcolo
% ---------------------------------------------------------------------------------------------

% Prova con 16 squadre
squadra(napoli; milan; inter; juventus; atalanta; roma; lazio; fiorentina; sassuolo; torino; udinese; bologna; monza; empoli; salernitana; lecce).
in(napoli, napoli).
in(milan, milano).
in(inter, milano).
in(juventus, juventus).
in(atalanta, bergamo).
in(roma, roma).
in(lazio, lazio).
in(fiorentina, firenze).
in(sassuolo, sassuolo).
in(torino, torino).
in(udinese, udine).
in(bologna, bologna).
in(monza, monza).
in(empoli, empoli).
in(salernitana, salerno).
in(lecce, lecce).
giornata(1..30).

1 {assegna(partita(S1, S2), G) : giornata(G)} 1 :- partita(S1, S2).
15 {partita(S1, S2) : squadra(S2), S1 <> S2} 15 :- squadra(S1).
8 {assegna(partita(S1, S2), G) : partita(S1,S2)} 8 :- giornata(G).
:- assegna(partita(S1, S2), G), assegna(partita(S1, S3), G), S2 <> S3.
:- assegna(partita(S2, S1), G), assegna(partita(S3, S1), G), S2 <> S3.
:- assegna(partita(S1, _), G), assegna(partita(_, S1), G).
:- assegna(partita(S1, _), G), assegna(partita(S2, _), G), in(S1, C), in(S2, C), S1 <> S2.


% :- assegna(partita(S1, S2), G1), assegna(partita(S2, S1), G2), G1 < G2, G2 - G1 < 10.
% :- G > 2, assegna(partita(S1, _), G), assegna(partita(S1, _), G-1), assegna(partita(S1, _), G-2).
% :- G > 2, assegna(partita(_, S1), G), assegna(partita(_, S1), G-1), assegna(partita(_, S1), G-2).


% prove con qualche assegnamento per velocizzare un po'
% assegna(partita(milan,napoli),1).
% assegna(partita(fiorentina,inter),1).
% assegna(partita(atalanta,roma),1).
% assegna(partita(lazio,juventus),1).
% assegna(partita(sassuolo,empoli),1).
% assegna(partita(torino,spezia),1).
% assegna(partita(udinese,hellas_verona),1).
% assegna(partita(bologna,sampdoria),1).
% assegna(partita(salernitana,monza),1).
% assegna(partita(lecce,cremonese),1).

% % assegna(partita(milan,napoli),17).
% assegna(partita(milan,inter),4).
% assegna(partita(milan,juventus),5).
% assegna(partita(milan,atalanta),7).
% assegna(partita(milan,roma),26).
% assegna(partita(milan,lazio),2).
% assegna(partita(milan,fiorentina),35).
% assegna(partita(milan,sassuolo),31).
% assegna(partita(milan,torino),29).
% assegna(partita(milan,udinese),22).


#show assegna/2.