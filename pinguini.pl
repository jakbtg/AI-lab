uccello(X) :- pinguino(X).
uccello(tux).
pinguino(tweety).
pinguino(tux).

% per dire che X vola se X è un uccello e non è un pinguino uso la negazione per fallimento:
% prova a dimostrare il goal come se non ci fosse la negazione e poi ribalta il risultato.
vola(X) :- uccello(X), \+ pinguino(X).