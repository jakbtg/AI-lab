genitore(anna, mario).
genitore(paolo, mario).
genitore(anna, luisa).
genitore(paolo, luisa).
genitore(mario, chiara).
genitore(antonella, chiara).
genitore(chiara, lia).

nonno(X, Y) :- genitore(X, Z), genitore(Z, Y).