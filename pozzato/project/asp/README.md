# Note sulle run del progetto ASP

Queste sono le migliori prestazioni ottenute, ma ogni run impiega tempi diversi.

## Run dei vincoli obbligatori

4 thread e nessun assegnamento: circa 5-6 secondi. Oppure con assegnamento prima giornata e 6 thread: circa 2 secondi.

## Run con vincolo di 10 giorni tra stesse partite

2 thread e 10 assegnamenti per la squadra Milan: circa 12 secondi. Senza assegnamenti invece: circa 210 secondi. Mai più ricapitati questi risultati, non ho idea del perché. Tutte le altre prove con 10 giornate tra stesse partite ho dovuto interromperle dopo circa 30 minuti, anche quelle con le stesse condizioni precedenti.    
Vincolo rilassato a 6 giornate tra stesse partite, 6 thread, prima giornata assegnata e 10 assegnamenti per squadra Milan: circa 54 secondi.

## Run con vincolo di massimo 2 partite consecutive in casa o in trasferta

Interrotto dopo circa 45 minuti, varie prove con vari thread e vari assegnamenti.  
Vincolo rilassato a 3 partite consecutive in casa o in trasferta.  
6 thread, prima giornata assegnata: circa 2 secondi.

## Run con 20 squadre, 6 giornate tra stesse partite e massimo 3 partite consecutive in casa o in trasferta

6 thread, prima giornata assegnata e 10 assegnamenti per squadra Milan: circa 340 secondi.

## Run con 12 squadre, 6 giornate tra stesse partite e massimo 2 partite consecutive in casa o in trasferta

6 thread e nessun assegnamento: circa 4 secondi.
