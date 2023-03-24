% PROGETTO - ASP
% ------------------------------------------------
% Generazione calendario di una competizione sportiva, con le seguenti caratteristiche:
%  - sono iscritte 20 squadre; 
%  - il campionato prevede 38 giornate, 19 di andata e 19 di ritorno NON simmetriche, ossia la giornata 1 di ritorno non coincide 
%    necessariamente con la giornata 1 di andata a campi invertiti;  
%  - ogni squadra fa riferimento ad una città, che offre la struttura in cui la squadra gioca gli incontri in casa; 
%  - ogni squadra affronta due volte tutte le altre squadre, una volta in casa e una volta fuori casa, ossia una volta nella 
%    propria città di riferimento e una volta in quella dell’altra squadra; 
%  - due delle 20 squadre fanno riferimento alla medesima città e condividono la stessa struttura di gioco, quindi non possono 
%    giocare entrambe in casa nella stessa giornata. Ovviamente, fanno eccezione le due giornate in cui giocano l’una 
%    contro l’altra (derby).
% ------------------------------------------------

% Squadre partecipanti
squadra(napoli; milan; inter; juventus; atalanta; roma; lazio; fiorentina; sassuolo; torino; udinese; bologna; monza; empoli; salernitana; lecce; spezia; hellas_verona; sampdoria; cremonese).

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

% Ogni squadra affronta due volte tutte le altre squadre
19 {partita(S1, S2) : squadra(S2)} 19 :- squadra(S1).

% Elimino i modelli in cui una squadra affronta se stessa
:- partita(S1, S2), S1 = S2.

#show partita/2.