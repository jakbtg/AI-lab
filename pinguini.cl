uccello(X) :- pinguino(X).
uccello(X) :- gallina(X).

-vola(X) :- pinguino(X).
-vola(X) :- gallina(X).
vola(X) :- uccello(X), not -vola(X).

uccello(tweety).
pinguino(tux).
gallina(frankie).