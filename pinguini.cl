uccello(X) :- pinguino(X).
uccello(X) :- gallina(X).

-vola(X) :- pinguino(X).
-vola(X) :- gallina(X).
% un uccello vola a meno che non possiamo dimostrare che non vola (per negazione a fallimento)
vola(X) :- uccello(X), not -vola(X).

uccello(tweety).
pinguino(tux).
gallina(frankie).