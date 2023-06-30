# Istruzioni per l'esecuzione degli agenti

Basta spostarsi nella cartella `run` ed eseguire il comando `./clips -f run_map1_0obs.bat`. Il comando esegue il file batch `run_map1_0obs.bat` che in particolare lancerà l'agente 1 sulla mappa 1 senza osservazioni iniziali.  
È presente un file batch per ogni agente, per ogni mappa e per ogni numero di osservazioni iniziali.  
Dopodichè se si vuole analizzare i risultati ottenuti, basta copiare tutto ciò che l'agente ha stampato in console e incollarlo nel file `results.txt` presente nella cartella `results` (sovrascrivendo il contenuto precedente).  
A quel punto basta eseguire il file [analyze.py](/micalizio/project/results/analyze.py) presente nella cartella `results` e verranno stampati i risultati in un file di output relativo ai risultati di quell'agente, in quella mappa e con quel particolare numero di osservazioni iniziali: in questo caso sarebbe `1_map1_0obs_results.txt`.  
Per le dipendenze necessarie per l'esecuzione del file python, basta eseguire il comando `pip install -r requirements.txt`.