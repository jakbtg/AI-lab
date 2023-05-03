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

% Per prova: stato iniziale e goal
luogo(centro, stato(centrale, "in_stazione", "nessuna")).
luogo(casa, stato(porta_venezia, "in_stazione", "nessuna")).
luogo(concerto, stato(assago_milanofiori_forum, "in_stazione", "nessuna")).
luogo(partita, stato(san_siro_stadio, "in_stazione", "nessuna")).
luogo(lavoro, stato(uruguay, "in_stazione", "nessuna")).
luogo(shopping, stato(zara, "in_stazione", "nessuna")).
luogo(universita, stato(assago_milanofiori_nord, "in_stazione", "nessuna")).