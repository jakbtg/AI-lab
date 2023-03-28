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
% ------------------------------------------------

% Regola 1
% Squadre partecipanti
squadra(napoli; milan; inter; juventus; atalanta; roma; lazio; fiorentina; sassuolo; torino; udinese; bologna; monza; empoli; salernitana; lecce; spezia; hellas_verona; sampdoria; cremonese).

% Regola 3
% Città di riferimento delle squadre
in(napoli, napoli).
in(milan, milano).
in(inter, milano).
% Dato che solo due squadre fanno riferimento alla stessa città inserirò per juventus la città juventus
in(juventus, juventus).
in(atalanta, bergamo).
in(roma, roma).
% Dato che solo due squadre fanno riferimento alla stessa città inserirò per lazio la città lazio
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
in(spezia, spezia).
in(hellas_verona, verona).
in(sampdoria, genova).
in(cremonese, cremona).

% Ci sono 38 giornate
giornata(1..38).

% Regola 4
% Ogni squadra affronta due volte tutte le altre squadre:
% in questo modo vengono generate 19 partite in casa per ogni squadra
% ma dato che ogni squadra compare poi anche in trasferta esattamente una volta per ogni avversaria,
% ogni squadra compare esaattamente 38 volte in totale, ovvero affronta tutte le altre squadre 2 volte,
% una volta in casa e una volta in trasferta
19 {partita(S1, S2) : squadra(S2)} 19 :- squadra(S1).
% Elimino i modelli in cui una squadra affronta se stessa
:- partita(S1, S2), S1 = S2.

% Regola 2
% Ogni partita avviene in una giornata
1 {assegna(partita(S1,S2), G) : giornata(G)} 1 :- partita(S1, S2).
% Ogni giornata ha 10 partite
10 {assegna(partita(S1, S2), G) : partita(S1,S2)} 10 :- giornata(G).
% Ogni squadra gioca una sola partita per giornata
% Conto le partite in casa ed elimino modelli in cui una squadra gioca più di una partita in casa nella stessa giornata
conta_partite_casa(S1, G, N) :- assegna(partita(S1, _), G), N = #count{S2 : assegna(partita(S1, S2), G)}.
:- squadra(S1), giornata(G), conta_partite_casa(S1, G, N), N > 1.
% Conto le partite in trasferta ed elimino modelli in cui una squadra gioca più di una partita in trasferta nella stessa giornata
conta_partite_trasferta(S1, G, N) :- assegna(partita(_, S1), G), N = #count{S2 : assegna(partita(S2, S1), G)}.
:- squadra(S1), giornata(G), conta_partite_trasferta(S1, G, N), N > 1.
% Se una squadra gioca in casa in una giornata, non può giocare in trasferta in quella stessa giornata
:- assegna(partita(S1, _), G), assegna(partita(_, S1), G).

% Regola 5
% Squadre della stessa città non possono giocare entrambe in casa nella stessa giornata a meno che non giochino l'una contro l'altra
% usando il count
conta_partite_stessa_citta(S1, G, N) :- assegna(partita(S1, _), G), in(S1, C), N = #count{S2 : assegna(partita(S2, _), G), in(S2, C)}.
:- squadra(S1), giornata(G), in(S1, C), conta_partite_stessa_citta(S1, G, N), N > 1.

#show assegna/2.