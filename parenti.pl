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

% è importante considerare l'ordine con cui sono scritte le regole.
% ad esempio se le due regole seguenti fossero invertite, si entrerebbe in un loop infinito.
% questo perché prolog cerca di soddisfare le regole secondo l'ordine in cui sono scritte.
% è quindi importante scrivere prima i casi base e poi quelli ricorsivi.
% è inoltre importante l'ordine dei sottogoal all'interno di una regola: 
% prima i predicati instanziabili e poi il passo ricorsivo.
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
