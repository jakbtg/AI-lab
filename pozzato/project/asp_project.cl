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

% Squadre partecipanti
% Regola 1
squadra(napoli; milan; inter; juventus; atalanta; roma; lazio; fiorentina; sassuolo; torino; udinese; bologna; monza; empoli; salernitana; lecce; spezia; hellas_verona; sampdoria; cremonese).

% Città di riferimento delle squadre
% Regola 3
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

% Ogni squadra affronta due volte tutte le altre squadre:
% in questo modo vengono generate 19 partite in casa per ogni squadra
% ma dato che ogni squadra compare poi anche in trasferta esattamente una volta per ogni avversaria,
% ogni squadra compare esaattamente 38 volte in totale, ovvero affronta tutte le altre squadre 2 volte,
% una volta in casa e una volta in trasferta
% Regola 4
19 {partita(S1, S2) : squadra(S2)} 19 :- squadra(S1).
% Elimino i modelli in cui una squadra affronta se stessa
:- partita(S1, S2), S1 = S2.

% Regola 2
% Ogni partita avviene in una giornata
1 {assegna(partita(S1,S2), G) : giornata(G)} 1 :- partita(S1, S2).
% Ogni giornata ha 10 partite
10 {assegna(partita(S1, S2), G) : partita(S1,S2)} 10 :- giornata(G).
% Ogni squadra gioca una sola partita per giornata
% 1 {assegna(partita(S1, S2), G) : partita(S1,S2)} 1 :- squadra(S1), giornata(G).
% prova con count
conta_partite(S1, G, N) :- assegna(partita(S1, _), G), N = #count{S2 : assegna(partita(S1, S2), G)}.
:- squadra(S1), giornata(G), conta_partite(S1, G, N), N > 1.

assegna(partita(napoli, fiorentina), 1).
assegna(partita(milan, lazio), 1).
assegna(partita(inter, sassuolo), 1).
assegna(partita(juventus, torino), 1).



% #show partita/2.
#show assegna/2.