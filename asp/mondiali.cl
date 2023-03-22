% programma per sorteggiare i gironi dei mondiali di un qualche sport

team(qatar; olanda; brasile; argentina; inghilterra; germania; corea; arabia; ghana; camerun; giappone; canada; uruguay; australia; francia; spagna).

testa_di_serie(argentina; brasile; spagna; francia).

% per indicare continente di appartenenza
in(qatar, asia).
in(olanda, europa).
in(brasile, sudamerica).
in(argentina, sudamerica).
in(inghilterra, europa).
in(germania, europa).
in(corea, asia).
in(arabia, asia).
in(ghana, africa).
in(camerun, africa).
in(giappone, asia).
in(canada, nordamerica).
in(uruguay, sudamerica).
in(australia, oceania).
in(francia, europa).
in(spagna, europa).

% 4 gironi da 4 squadre, ciascuno con almeno 3 continenti rappresentati
girone(1..4).

% ad ogni squadra assegno un solo girone
1 {assegna(Squadra, G) : girone(G)} 1:- team(Squadra).
% ad ogni girone assegno 4 squadre
4 {assegna(Squadra, G) : team(Squadra)} 4:- girone(G).
% in ogni girone ci sono almeno 3 continenti
quantiCont(G, ContG):- girone(G), ContG = #count{C: assegna(S, G), in(S, C)}.
:- quantiCont(G, ContG), ContG < 3.
% ogni girone ha solo una squadra testa di serie
:- assegna(S1, G), assegna(S2, G), S1 <> S2, testa_di_serie(S1), testa_di_serie(S2).

#show assegna/2.
#show quantiCont/2.