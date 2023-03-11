% Fatti
gatto(tom).
gatto(fred).
tigre(mike).

% Regole
felino(X) :- gatto(X).
felino(X) :- tigre(X).