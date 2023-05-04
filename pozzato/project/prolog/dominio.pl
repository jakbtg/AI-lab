% In questo file sono presenti tutti i fatti che definiscono il dominio del problema.

% Definizione delle linee della metro:
% linea(nome, direzione, lista di fermate)
% nome = colore della linea
% direzione = stazione di arrivo

% Linea rossa - M1
linea(rossa, sesto_primo_maggio, 
    [rho_fiera, pero, molino_dorino, san_leonardo, bonola, uruguay, lampugnano, qt8, lotto, amendola, buonarroti,
    pagano, conciliazione, cadorna, cairoli, cordusio, duomo, san_babila, palestro, porta_venezia, lima, loreto,
    pasteur, rovereto, turro, gorla, precotto, villa_san_giovanni, sesto_marelli, sesto_rondò, sesto_primo_maggio]).

linea(rossa, rho_fiera, 
    [sesto_primo_maggio, sesto_rondò, sesto_marelli, villa_san_giovanni, precotto, gorla, turro, rovereto, pasteur,
    loreto, lima, porta_venezia, palestro, san_babila, duomo, cordusio, cairoli, cadorna, conciliazione, pagano,
    buonarroti, amendola, lotto, qt8, lampugnano, uruguay, bonola, san_leonardo, molino_dorino, pero, rho_fiera]).

% Linea verde - M2
linea(verde, cologno_nord,
    [assago_milanofiori_forum, assago_milanofiori_nord, famagosta, romolo, porta_genova, sant_agostino, sant_ambrogio,
    cadorna, lanza, moscova, garibaldi, gioia, centrale, caiazzo, loreto, piola, lambrate, udine, cimiano, crescenzago,
    cascina_gobba, cologno_sud, cologno_centro, cologno_nord]).

linea(verde, assago_milanofiori_forum,
    [cologno_nord, cologno_centro, cologno_sud, cascina_gobba, crescenzago, cimiano, udine, lambrate, piola, loreto,
    caiazzo, centrale, gioia, garibaldi, moscova, lanza, cadorna, sant_ambrogio, sant_agostino, porta_genova, romolo,
    famagosta, assago_milanofiori_nord, assago_milanofiori_forum]).

% Linea gialla - M3
linea(gialla, san_donato,
    [comasina, affori, affori_centro, dergano, maciachini, zara, sondrio, centrale, repubblica, turati, montenapoleone,
    duomo, missori, crocetta, porta_romana, lodi_tibb, brenta, corvetto, porto_di_mare, rogoredo, san_donato]).

linea(gialla, comasina,
    [san_donato, rogoredo, porto_di_mare, corvetto, brenta, lodi_tibb, porta_romana, crocetta, missori, duomo,
    montenapoleone, turati, repubblica, centrale, sondrio, zara, maciachini, dergano, affori_centro, affori, comasina]).

% Linea lilla - M5
linea(lilla, bignami,
    [san_siro_stadio, san_siro_ippodromo, segesta, lotto, portello, tre_torri, domodossola, gerusalemme, cenisio,
    monumentale, garibaldi, isola, zara, marche, istria, ca_granda, bicocca, ponale, bignami]).

linea(lilla, san_siro_stadio,
    [bignami, ponale, bicocca, ca_granda, istria, marche, zara, isola, garibaldi, monumentale, cenisio, gerusalemme,
    domodossola, tre_torri, portello, lotto, segesta, san_siro_ippodromo, san_siro_stadio]).


% Definisco le stazioni di cambio
% cambio(nome, lista di linee)
% nome = nome della stazione
cambio(cadorna, [rossa, verde]).
cambio(duomo, [rossa, gialla]).
cambio(loreto, [rossa, verde]).
cambio(lotto, [rossa, lilla]).
cambio(garibaldi, [verde, lilla]).
cambio(centrale, [verde, gialla]).
cambio(zara, [gialla, lilla]).

% Definisco le stazioni finali
finale(sesto_primo_maggio).
finale(rho_fiera).
finale(cologno_nord).
finale(assago_milanofiori_forum).
finale(san_donato).
finale(comasina).
finale(bignami).
finale(san_siro_stadio).

% Luoghi di interesse
luogo(centro, stato(centrale, "in_stazione", "nessuna")).
luogo(casa, stato(porta_venezia, "in_stazione", "nessuna")).
luogo(concerto, stato(assago_milanofiori_forum, "in_stazione", "nessuna")).
luogo(partita, stato(san_siro_stadio, "in_stazione", "nessuna")).
luogo(lavoro, stato(uruguay, "in_stazione", "nessuna")).
luogo(shopping, stato(zara, "in_stazione", "nessuna")).
luogo(universita, stato(lanza, "in_stazione", "nessuna")).


% Prova per aggiungere ad ogni fermata una posizione sulla griglia
% Posizioni Linea ROSSA
posizione(rho_fiera, pos(3,1)).
posizione(pero, pos(4,2)).
posizione(molino_dorino, pos(5,3)).
posizione(san_leonardo, pos(6,4)).
posizione(bonola, pos(7,5)).
posizione(uruguay, pos(8,6)).
posizione(lampugnano, pos(9,7)).
posizione(qt8, pos(10,8)).
posizione(lotto, pos(11,9)).
posizione(amendola, pos(12,10)).
posizione(buonarroti, pos(13,11)).
posizione(pagano, pos(14,12)).
posizione(conciliazione, pos(14,13)).
posizione(cadorna, pos(14,14)).
posizione(cairoli, pos(14,15)).
posizione(cordusio, pos(14,16)).
posizione(duomo, pos(14,17)).
posizione(san_babila, pos(14,18)).
posizione(palestro, pos(13,19)).
posizione(porta_venezia, pos(12,20)).
posizione(lima, pos(11,21)).
posizione(loreto, pos(10,21)).
posizione(pasteur, pos(9,21)).
posizione(rovereto, pos(8,21)).
posizione(turro, pos(7,21)).
posizione(gorla, pos(6,21)).
posizione(precotto, pos(5,21)).
posizione(villa_san_giovanni, pos(4,21)).
posizione(sesto_marelli, pos(3,21)).
posizione(sesto_rondò, pos(2,21)).
posizione(sesto_primo_maggio, pos(1,21)).


% Posizioni Linea VERDE
posizione(assago_milanofiori_forum, pos(21,14)).
posizione(assago_milanofiori_nord, pos(20,14)).
posizione(famagosta, pos(19,14)).
posizione(romolo, pos(18,14)).
posizione(porta_genova, pos(17,14)).
posizione(sant_agostino, pos(16,14)).
posizione(sant_ambrogio, pos(15,14)).
% cadorna già definita
posizione(lanza, pos(12,15)).
posizione(moscova, pos(11,16)).
posizione(garibaldi, pos(10,17)).
posizione(gioia, pos(10,18)).
posizione(centrale, pos(10,19)).
posizione(caiazzo, pos(10,20)).
% loreto già definita
posizione(piola, pos(10,22)).
posizione(lambrate, pos(10,23)).
posizione(udine, pos(9,24)).
posizione(cimiano, pos(8,25)).
posizione(crescenzago, pos(7,26)).
posizione(cascina_gobba, pos(6,27)).
posizione(cologno_sud, pos(5,28)).
posizione(cologno_centro, pos(4,29)).
posizione(cologno_nord, pos(3,30)).


% Posizioni Linea GIALLA
posizione(comasina, pos(2,13)).
posizione(affori, pos(3,14)).
posizione(affori_centro, pos(4,15)).
posizione(dergano, pos(5,16)).
posizione(maciachini, pos(6,17)).
posizione(zara, pos(7,18)).
posizione(sondrio, pos(8,19)).
% centrale già definita
posizione(repubblica, pos(11,19)).
posizione(turati, pos(12,18)).
posizione(montenapoleone, pos(13,17)).
% duomo già definita
posizione(missori, pos(15,17)).
posizione(crocetta, pos(16,18)).
posizione(porta_romana, pos(17,19)).
posizione(lodi_tibb, pos(18,20)).
posizione(brenta, pos(19,21)).
posizione(corvetto, pos(20,22)).
posizione(porto_di_mare, pos(21,23)).
posizione(rogoredo, pos(22,24)).
posizione(san_donato, pos(23,25)).


% Posizioni Linea LILLA
posizione(bignami, pos(1,19)).
posizione(ponale, pos(2,19)).
posizione(bicocca, pos(3,19)).
posizione(ca_granda, pos(4,19)).
posizione(istria, pos(5,19)).
posizione(marche, pos(6,19)).
% zara già definita
posizione(isola, pos(8,17)).
% garibaldi già definita
posizione(monumentale, pos(10,15)).
posizione(cenisio, pos(9,14)).
posizione(gerusalemme, pos(8,13)).
posizione(domodossola, pos(8,12)).
posizione(tre_torri, pos(9,11)).
posizione(portello, pos(10,10)).
% lotto già definita
posizione(segesta, pos(11,7)).
posizione(san_siro_ippodromo, pos(11,6)).
posizione(san_siro_stadio, pos(11,5)).