genitore(anna, mario).
genitore(paolo, mario).
genitore(anna, luisa).
genitore(paolo, luisa).
genitore(mario, chiara).
genitore(antonella, chiara).
genitore(mario, roberto).
genitore(rita, roberto).
genitore(chiara, lia).

nonno(X, Y) :- genitore(X, Z), genitore(Z, Y).
antenato(X, Y) :- genitore(X, Y).
antenato(X, Y) :- genitore(Z, Y), antenato(X, Z).
fratelloGermano(X, Y) :- 
    genitore(PrimoGenitore, X), 
    genitore(PrimoGenitore, Y),  
    X \== Y,
    genitore(SecondoGenitore, X), 
    PrimoGenitore \== SecondoGenitore,
    genitore(SecondoGenitore, Y).

fratelloUnilaterale(X, Y) :- 
    genitore(GenitoreComune, X),
    genitore(GenitoreComune, Y),
    X \== Y,
    genitore(GenitoreX, X),
    GenitoreX \== GenitoreComune,
    genitore(GenitoreY, Y),
    GenitoreY \== GenitoreComune,
    GenitoreX \== GenitoreY.
