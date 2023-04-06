tipo(integer).
tipo(float).
tipo(char).
variabile(a).
variabile(b).

1 {assegna(X, T) : tipo(T)} 1 :- variabile(X).

% stampa solo ciò che voglio vedere, ignorando ad esempio fatti sempre veri come tipo(integer), tipo(float) ecc.
#show assegna/2.