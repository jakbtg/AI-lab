genitore(anna, mario).
genitore(paolo, mario).
genitore(anna, luisa).
genitore(paolo, luisa).
genitore(mario, chiara).
genitore(antonella, chiara).
genitore(chiara, lia).

nonno(X, Y) :- genitore(X, Z), genitore(Z, Y).
antenato(X, Y) :- genitore(X, Y).
antenato(X, Y) :- genitore(Z, Y), antenato(X, Z).
fratelloGermano(X, Y) :- genitore(PrimoGenitore, X), genitore(PrimoGenitore, Y), genitore(SecondoGenitore, X), genitore(SecondoGenitore, Y).