# Note sulle run del progetto ASP

Queste sono le migliori prestazioni ottenute, ma ogni run impiega tempi diversi. Non capisco perché.

## Run dei vincoli obbligatori

Lanciare con 4 thread e nessun assegnamento.  
Risultati in circa 4 secondi. (Oppure con assegnamenti e 6 thread in circa 2 secondi).

## Run con vincolo di 10 giorni tra stesse partite

2 thread e 10 assegnamenti per la squadra Milan.  
Risultati in circa 12 secondi. (Senza assegnamenti invece circa 210 secondi).

## Run con vincolo di massimo 2 partite consecutive in casa o in trasferta

Per ora provato solo con massimo 3 partite consecutive in casa o in trasferta e togliendo il vincolo di 10 giorni tra stesse partite.  
6 thread, 10 assegnamenti per la squadra Milan e la prima giornata assegnata.  
Risultati in circa 2 secondi.
