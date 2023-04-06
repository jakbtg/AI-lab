% Fatti
gatto(tom).
gatto(fred).
tigre(mike).
graffia(fred).

% Regole
felino(X) :- gatto(X).
felino(X) :- tigre(X).
miagola(X) :- gatto(X), sveglio(X).
sveglio(X) :- graffia(X).