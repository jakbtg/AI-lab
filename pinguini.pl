uccello(X) :- pinguino(X).
% per dire che X vola se X è un uccello e non è un pinguino uso la negazione per fallimento.
% che in sostanza funziona come segue:
% prova a dimostrare il goal come se non ci fosse la negazione e poi ribalta il risultato.
vola(X) :- uccello(X), \+ pinguino(X).
pinguino(tweety).
