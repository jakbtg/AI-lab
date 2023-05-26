;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  ---------------------------------------------
(defmodule AGENT (import MAIN ?ALL) (import ENV ?ALL) (export ?ALL))


;  ---------------------------------------------
;  -------- Templates utili --------------------
;  ---------------------------------------------
; Template per memorizzare le guess fatte con certezza
; piece lo uso quando sono sicuro che contiene una parte di barca ma non mi interessa
; sapere quale e faccio semplicemente una guess in quella posizione
(deftemplate sure-guess
	(slot x)
	(slot y)
	(slot content (allowed-values water left right middle top bot sub piece))
)

; Template per aggiornare il numero di pezzi per riga
(deftemplate row-pieces
	(slot row)
	(slot num)
)

; Template per aggiornare il numero di pezzi per colonna
(deftemplate col-pieces
	(slot col)
	(slot num)
)

; Template per tenere traccia dei pezzi già contati per l'aggiornamento delle righe e delle colonne
(deftemplate counted-piece
	(slot x)
	(slot y)
)

; Template per tenere traccia celle libere per riga
(deftemplate empty-cells-per-row
	(slot row)
	(slot num (default 10))
)

; Template per tenere traccia celle libere per colonna
(deftemplate empty-cells-per-col
	(slot col)
	(slot num (default 10))
)

; Template per tenere traccia delle celle già contate per l'aggiornamento delle righe e delle colonne
(deftemplate counted-cell
	(slot x)
	(slot y)
)

; Template per tenere traccia delle navi completamente affondate
(deftemplate sunk-boats
	(slot one (default 0) (range 0 4))
	(slot two (default 0) (range 0 3))
	(slot three (default 0) (range 0 2))
	(slot four (default 0) (range 0 1))
)

; Template per tenere traccia delle barche affondate già contate
(deftemplate sunk-check
	(slot x)
	(slot y)
)

; Template per tenere traccia del rapporto tra pezzi e celle libere per riga
(deftemplate row-ratio
	(slot row)
	(slot ratio (default -10))
)

; Template per tenere traccia del rapporto tra pezzi e celle libere per colonna
(deftemplate col-ratio
	(slot col)
	(slot ratio (default -10))
)

; Template per tenere traccia delle celle già contate per l'aggiornamento del ratio
(deftemplate counted-for-ratio
	(slot x)
	(slot y)
)

; Template per memorizzare la migliore colonna o riga su cui fare fire
(deftemplate best-row-or-col
	(slot row (default -1))
	(slot col (default -1))
)

; Template per tenere traccia delle celle vuote
(deftemplate empty-cell
	(slot x)
	(slot y)
)



;  ---------------------------------------------
;  -------- Fatti iniziali utili ---------------
;  ---------------------------------------------
; Inizializzo per ogni riga e colonna il numero di celle libere (inizialmente 10),
; il contenitore delle barche affondate, il rapporto tra pezzi e celle libere per riga e colonna
; e le celle vuote
(deffacts initialize
	(empty-cells-per-row (row 0))
	(empty-cells-per-row (row 1))
	(empty-cells-per-row (row 2))
	(empty-cells-per-row (row 3))
	(empty-cells-per-row (row 4))
	(empty-cells-per-row (row 5))
	(empty-cells-per-row (row 6))
	(empty-cells-per-row (row 7))
	(empty-cells-per-row (row 8))
	(empty-cells-per-row (row 9))
	(empty-cells-per-col (col 0))
	(empty-cells-per-col (col 1))
	(empty-cells-per-col (col 2))
	(empty-cells-per-col (col 3))
	(empty-cells-per-col (col 4))
	(empty-cells-per-col (col 5))
	(empty-cells-per-col (col 6))
	(empty-cells-per-col (col 7))
	(empty-cells-per-col (col 8))
	(empty-cells-per-col (col 9))
	(sunk-boats)
	(row-ratio (row 0))
	(row-ratio (row 1))
	(row-ratio (row 2))
	(row-ratio (row 3))
	(row-ratio (row 4))
	(row-ratio (row 5))
	(row-ratio (row 6))
	(row-ratio (row 7))
	(row-ratio (row 8))
	(row-ratio (row 9))
	(col-ratio (col 0))
	(col-ratio (col 1))
	(col-ratio (col 2))
	(col-ratio (col 3))
	(col-ratio (col 4))
	(col-ratio (col 5))
	(col-ratio (col 6))
	(col-ratio (col 7))
	(col-ratio (col 8))
	(col-ratio (col 9))
	(empty-cell (x 0) (y 0))
	(empty-cell (x 0) (y 1))
	(empty-cell (x 0) (y 2))
	(empty-cell (x 0) (y 3))
	(empty-cell (x 0) (y 4))
	(empty-cell (x 0) (y 5))
	(empty-cell (x 0) (y 6))
	(empty-cell (x 0) (y 7))
	(empty-cell (x 0) (y 8))
	(empty-cell (x 0) (y 9))
	(empty-cell (x 1) (y 0))
	(empty-cell (x 1) (y 1))
	(empty-cell (x 1) (y 2))
	(empty-cell (x 1) (y 3))
	(empty-cell (x 1) (y 4))
	(empty-cell (x 1) (y 5))
	(empty-cell (x 1) (y 6))
	(empty-cell (x 1) (y 7))
	(empty-cell (x 1) (y 8))
	(empty-cell (x 1) (y 9))
	(empty-cell (x 2) (y 0))
	(empty-cell (x 2) (y 1))
	(empty-cell (x 2) (y 2))
	(empty-cell (x 2) (y 3))
	(empty-cell (x 2) (y 4))
	(empty-cell (x 2) (y 5))
	(empty-cell (x 2) (y 6))
	(empty-cell (x 2) (y 7))
	(empty-cell (x 2) (y 8))
	(empty-cell (x 2) (y 9))
	(empty-cell (x 3) (y 0))
	(empty-cell (x 3) (y 1))
	(empty-cell (x 3) (y 2))
	(empty-cell (x 3) (y 3))
	(empty-cell (x 3) (y 4))
	(empty-cell (x 3) (y 5))
	(empty-cell (x 3) (y 6))
	(empty-cell (x 3) (y 7))
	(empty-cell (x 3) (y 8))
	(empty-cell (x 3) (y 9))
	(empty-cell (x 4) (y 0))
	(empty-cell (x 4) (y 1))
	(empty-cell (x 4) (y 2))
	(empty-cell (x 4) (y 3))
	(empty-cell (x 4) (y 4))
	(empty-cell (x 4) (y 5))
	(empty-cell (x 4) (y 6))
	(empty-cell (x 4) (y 7))
	(empty-cell (x 4) (y 8))
	(empty-cell (x 4) (y 9))
	(empty-cell (x 5) (y 0))
	(empty-cell (x 5) (y 1))
	(empty-cell (x 5) (y 2))
	(empty-cell (x 5) (y 3))
	(empty-cell (x 5) (y 4))
	(empty-cell (x 5) (y 5))
	(empty-cell (x 5) (y 6))
	(empty-cell (x 5) (y 7))
	(empty-cell (x 5) (y 8))
	(empty-cell (x 5) (y 9))
	(empty-cell (x 6) (y 0))
	(empty-cell (x 6) (y 1))
	(empty-cell (x 6) (y 2))
	(empty-cell (x 6) (y 3))
	(empty-cell (x 6) (y 4))
	(empty-cell (x 6) (y 5))
	(empty-cell (x 6) (y 6))
	(empty-cell (x 6) (y 7))
	(empty-cell (x 6) (y 8))
	(empty-cell (x 6) (y 9))
	(empty-cell (x 7) (y 0))
	(empty-cell (x 7) (y 1))
	(empty-cell (x 7) (y 2))
	(empty-cell (x 7) (y 3))
	(empty-cell (x 7) (y 4))
	(empty-cell (x 7) (y 5))
	(empty-cell (x 7) (y 6))
	(empty-cell (x 7) (y 7))
	(empty-cell (x 7) (y 8))
	(empty-cell (x 7) (y 9))
	(empty-cell (x 8) (y 0))
	(empty-cell (x 8) (y 1))
	(empty-cell (x 8) (y 2))
	(empty-cell (x 8) (y 3))
	(empty-cell (x 8) (y 4))
	(empty-cell (x 8) (y 5))
	(empty-cell (x 8) (y 6))
	(empty-cell (x 8) (y 7))
	(empty-cell (x 8) (y 8))
	(empty-cell (x 8) (y 9))
	(empty-cell (x 9) (y 0))
	(empty-cell (x 9) (y 1))
	(empty-cell (x 9) (y 2))
	(empty-cell (x 9) (y 3))
	(empty-cell (x 9) (y 4))
	(empty-cell (x 9) (y 5))
	(empty-cell (x 9) (y 6))
	(empty-cell (x 9) (y 7))
	(empty-cell (x 9) (y 8))
	(empty-cell (x 9) (y 9))
)



;  ---------------------------------------------
;  --- Print delle informazioni iniziali -------
;  ---------------------------------------------
(defrule print-what-i-know-since-the-beginning (declare (salience 20))
	(k-cell (x ?x) (y ?y) (content ?t))
=>
	(printout t "I know that cell [" ?x ", " ?y "] contains " ?t "." crlf)
)

(defrule print-rows-since-the-beginning (declare (salience 20))
	(k-per-row (row ?x) (num ?n))
=>
	(printout t "I know that row " ?x " contains " ?n " pieces." crlf)
	(assert (row-pieces (row ?x) (num ?n)))
)

(defrule print-columns-since-the-beginning (declare (salience 20))
	(k-per-col (col ?y) (num ?n))
=>
	(printout t "I know that column " ?y " contains " ?n " pieces." crlf)
	(assert (col-pieces (col ?y) (num ?n)))
)



;  ------------------------------------------------
;  --- Inizialmente fa guess sulle info di base ---
;  ------------------------------------------------
(defrule guess-known-boat-pieces (declare (salience 15))
	(status (step ?s) (currently running))
	(k-cell (x ?x) (y ?y) (content ?t & ~water))
	(not (exec (action guess) (x ?x) (y ?y)))
=>
	(printout t "I guess that cell [" ?x ", " ?y "] contains " ?t "." crlf)
	(assert (sure-guess (x ?x) (y ?y) (content ?t)))
	(assert (exec (step ?s) (action guess) (x ?x) (y ?y)))
	(pop-focus)
)

(defrule fill-known-water-cells (declare (salience 15))
	(k-cell (x ?x) (y ?y) (content water))
	(not (sure-guess (x ?x) (y ?y)))
=>
	(printout t "Fill cell [" ?x ", " ?y "] with water." crlf)
	(assert (sure-guess (x ?x) (y ?y) (content water)))
)



;  ---------------------------------------------------------------------
;  --- Dato un pezzo centrale posizionato su un qualche bordo ----------
;  --- ho la certezza che la barca continui di almeno un altro pezzo ---
;  --- o in verticale o in orizzontale a seconda del bordo su cui è ----
;  ---------------------------------------------------------------------
(defrule guess-up-given-middle-piece-on-left-border (declare (salience 10))
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y 0) (content middle))
	(not (exec (action guess) (x ?x2 &: (eq ?x2 (- ?x 1))) (y 0)))
=>
	(printout t "I guess that cell [" (- ?x 1) ", " 0 "] contains a piece." crlf)
	(assert (sure-guess (x (- ?x 1)) (y 0) (content piece)))
	(assert (exec (step ?s) (action guess) (x (- ?x 1)) (y 0)))
	(pop-focus)
)

(defrule guess-down-given-middle-piece-on-left-border (declare (salience 10))
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y 0) (content middle))
	(not (exec (action guess) (x ?x2 &: (eq ?x2 (+ ?x 1))) (y 0)))
=>
	(printout t "I guess that cell [" (+ ?x 1) ", " 0 "] contains a piece." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y 0) (content piece)))
	(assert (exec (step ?s) (action guess) (x (+ ?x 1)) (y 0)))
	(pop-focus)
)

(defrule guess-left-given-middle-piece-on-top-border (declare (salience 10))
	(status (step ?s) (currently running))
	(sure-guess (x 0) (y ?y) (content middle))
	(not (exec (action guess) (x 0) (y ?y2 &: (eq ?y2 (- ?y 1)))))
=>
	(printout t "I guess that cell [" 0 ", " (- ?y 1) "] contains a piece." crlf)
	(assert (sure-guess (x 0) (y (- ?y 1)) (content piece)))
	(assert (exec (step ?s) (action guess) (x 0) (y (- ?y 1))))
	(pop-focus)
)

(defrule guess-right-given-middle-piece-on-top-border (declare (salience 10))
	(status (step ?s) (currently running))
	(sure-guess (x 0) (y ?y) (content middle))
	(not (exec (action guess) (x 0) (y ?y2 &: (eq ?y2 (+ ?y 1)))))
=>
	(printout t "I guess that cell [" 0 ", " (+ ?y 1) "] contains a piece." crlf)
	(assert (sure-guess (x 0) (y (+ ?y 1)) (content piece)))
	(assert (exec (step ?s) (action guess) (x 0) (y (+ ?y 1))))
	(pop-focus)
)

(defrule guess-up-given-middle-piece-on-right-border (declare (salience 10))
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y 9) (content middle))
	(not (exec (action guess) (x ?x2 &: (eq ?x2 (- ?x 1))) (y 9)))
=>
	(printout t "I guess that cell [" (- ?x 1) ", " 9 "] contains a piece." crlf)
	(assert (sure-guess (x (- ?x 1)) (y 9) (content piece)))
	(assert (exec (step ?s) (action guess) (x (- ?x 1)) (y 9)))
	(pop-focus)
)

(defrule guess-down-given-middle-piece-on-right-border (declare (salience 10))
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y 9) (content middle))
	(not (exec (action guess) (x ?x2 &: (eq ?x2 (+ ?x 1))) (y 9)))
=>
	(printout t "I guess that cell [" (+ ?x 1) ", " 9 "] contains a piece." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y 9) (content piece)))
	(assert (exec (step ?s) (action guess) (x (+ ?x 1)) (y 9)))
	(pop-focus)
)

(defrule guess-left-given-middle-piece-on-bottom-border (declare (salience 10))
	(status (step ?s) (currently running))
	(sure-guess (x 9) (y ?y) (content middle))
	(not (exec (action guess) (x 9) (y ?y2 &: (eq ?y2 (- ?y 1)))))
=>
	(printout t "I guess that cell [" 9 ", " (- ?y 1) "] contains a piece." crlf)
	(assert (sure-guess (x 9) (y (- ?y 1)) (content piece)))
	(assert (exec (step ?s) (action guess) (x 9) (y (- ?y 1))))
	(pop-focus)
)

(defrule guess-right-given-middle-piece-on-bottom-border (declare (salience 10))
	(status (step ?s) (currently running))
	(sure-guess (x 9) (y ?y) (content middle))
	(not (exec (action guess) (x 9) (y ?y2 &: (eq ?y2 (+ ?y 1)))))
=>
	(printout t "I guess that cell [" 9 ", " (+ ?y 1) "] contains a piece." crlf)
	(assert (sure-guess (x 9) (y (+ ?y 1)) (content piece)))
	(assert (exec (step ?s) (action guess) (x 9) (y (+ ?y 1))))
	(pop-focus)
)



;  --------------------------------------------------------------------
;  --- Dato un pezzo left/right/top/bottom so che la barca ------------
;  --- continua di almeno un altro pezzo nella rispettiva direzione ---
;  --------------------------------------------------------------------
(defrule guess-right-given-left-piece (declare (salience 10))
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y ?y) (content left))
	(not (exec (action guess) (x ?x) (y ?y2 &: (eq ?y2 (+ ?y 1)))))
=>
	(printout t "I guess that cell [" ?x ", " (+ ?y 1) "] contains a piece." crlf)
	(assert (sure-guess (x ?x) (y (+ ?y 1)) (content piece)))
	(assert (exec (step ?s) (action guess) (x ?x) (y (+ ?y 1))))
	(pop-focus)
)

(defrule guess-left-given-right-piece (declare (salience 10))
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y ?y) (content right))
	(not (exec (action guess) (x ?x) (y ?y2 &: (eq ?y2 (- ?y 1)))))
=>
	(printout t "I guess that cell [" ?x ", " (- ?y 1) "] contains a piece." crlf)
	(assert (sure-guess (x ?x) (y (- ?y 1)) (content piece)))
	(assert (exec (step ?s) (action guess) (x ?x) (y (- ?y 1))))
	(pop-focus)
)

(defrule guess-down-given-top-piece (declare (salience 10))
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y ?y) (content top))
	(not (exec (action guess) (x ?x2 &: (eq ?x2 (+ ?x 1))) (y ?y)))
=>
	(printout t "I guess that cell [" (+ ?x 1) ", " ?y "] contains a piece." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y ?y) (content piece)))
	(assert (exec (step ?s) (action guess) (x (+ ?x 1)) (y ?y)))
	(pop-focus)
)

(defrule guess-up-given-bottom-piece (declare (salience 10))
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y ?y) (content bot))
	(not (exec (action guess) (x ?x2 &: (eq ?x2 (- ?x 1))) (y ?y)))
=>
	(printout t "I guess that cell [" (- ?x 1) ", " ?y "] contains a piece." crlf)
	(assert (sure-guess (x (- ?x 1)) (y ?y) (content piece)))
	(assert (exec (step ?s) (action guess) (x (- ?x 1)) (y ?y)))
	(pop-focus)
)



;  -------------------------------------------------------------------
;  --- Se ho un middle ma il numero di pezzi presenti nella sua ------
;  --- colonna è minore di 3 (se c'è un middle la barca ha almeno ----
;  --- 3 pezzi) allora posso fare guess nelle due celle adiacenti ----
;  --- sulla stessa riga. O viceversa. -------------------------------
;  -------------------------------------------------------------------
(defrule guess-left-when-col-less-than-3 (declare (salience 10))
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y ?y) (content middle))
	(k-per-col (col ?y) (num ?n &: (< ?n 3)))
	(not (exec (action guess) (x ?x) (y ?y1 &: (eq ?y1 (- ?y 1)))))
=>
	(printout t "I guess that cell [" ?x ", " (- ?y 1) "] contains a piece." crlf)
	(assert (sure-guess (x ?x) (y (- ?y 1)) (content piece)))
	(assert (exec (step ?s) (action guess) (x ?x) (y (- ?y 1))))
	(pop-focus)
)

(defrule guess-right-when-col-less-than-3 (declare (salience 10))
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y ?y) (content middle))
	(k-per-col (col ?y) (num ?n &: (< ?n 3)))
	(not (exec (action guess) (x ?x) (y ?y1 &: (eq ?y1 (+ ?y 1)))))
=>
	(printout t "I guess that cell [" ?x ", " (+ ?y 1) "] contains a piece." crlf)
	(assert (sure-guess (x ?x) (y (+ ?y 1)) (content piece)))
	(assert (exec (step ?s) (action guess) (x ?x) (y (+ ?y 1))))
	(pop-focus)
)

(defrule guess-up-when-row-less-than-3 (declare (salience 10))
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y ?y) (content middle))
	(k-per-row (row ?x) (num ?n &: (< ?n 3)))
	(not (exec (action guess) (x ?x1 &: (eq ?x1 (- ?x 1))) (y ?y)))	
=>
	(printout t "I guess that cell [" (- ?x 1) ", " ?y "] contains a piece." crlf)
	(assert (sure-guess (x (- ?x 1)) (y ?y) (content piece)))
	(assert (exec (step ?s) (action guess) (x (- ?x 1)) (y ?y)))
	(pop-focus)
)

(defrule guess-down-when-row-less-than-3 (declare (salience 10))
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y ?y) (content middle))
	(k-per-row (row ?x) (num ?n &: (< ?n 3)))
	(not (exec (action guess) (x ?x1 &: (eq ?x1 (+ ?x 1))) (y ?y)))
=>
	(printout t "I guess that cell [" (+ ?x 1) ", " ?y "] contains a piece." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y ?y) (content piece)))
	(assert (exec (step ?s) (action guess) (x (+ ?x 1)) (y ?y)))
	(pop-focus)
)



;  -------------------------------------------------------------------
;  --- Riempio con water tutte le celle che circondano delle  --------
;  --- sure-guess che contengono qualsiasi pezzo che non sia acqua ---
;  --- e tutte le celle di righe e colonne il cui numero di pezzi ----
;  --- contenuti è 0 -------------------------------------------------
;  -------------------------------------------------------------------
; Riempio di acqua righe e colonne vuote
(defrule fill-water-row-when-no-pieces
	(row-pieces (row ?x) (num 0))
	(col-pieces (col ?y))
	(not (sure-guess (x ?x) (y ?y)))
=>
	(printout t "Fill cell [" ?x ", " ?y "] with water." crlf)
	(assert (sure-guess (x ?x) (y ?y) (content water)))
)

(defrule fill-water-col-when-no-pieces
	(row-pieces (row ?x))
	(col-pieces (col ?y) (num 0))
	(not (sure-guess (x ?x) (y ?y)))
=>
	(printout t "Fill cell [" ?x ", " ?y "] with water." crlf)
	(assert (sure-guess (x ?x) (y ?y) (content water)))
)

; Riempio di acqua le celle attorno a pezzi right
(defrule fill-water-up-left-around-right-piece
	(sure-guess (x ?x) (y ?y) (content right))
	(not (sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water)))
	(test (>= (- ?x 1) 0))
	(test (>= (- ?y 1) 0))
=>
	(printout t "Fill cell [" (- ?x 1) ", " (- ?y 1) "] with water." crlf)
	(assert (sure-guess (x (- ?x 1)) (y (- ?y 1)) (content water)))
)

(defrule fill-water-up-mid-around-right-piece
	(sure-guess (x ?x) (y ?y) (content right))
	(not (sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y) (content water)))
	(test (>= (- ?x 1) 0))
=>
	(printout t "Fill cell [" (- ?x 1) ", " ?y "] with water." crlf)
	(assert (sure-guess (x (- ?x 1)) (y ?y) (content water)))
)

(defrule fill-water-up-right-around-right-piece
	(sure-guess (x ?x) (y ?y) (content right))
	(not (sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y1 &:(eq ?y1 (+ ?y 1))) (content water)))
	(test (>= (- ?x 1) 0))
	(test (<= (+ ?y 1) 9))
=>
	(printout t "Fill cell [" (- ?x 1) ", " (+ ?y 1) "] with water." crlf)
	(assert (sure-guess (x (- ?x 1)) (y (+ ?y 1)) (content water)))
)

(defrule fill-water-mid-right-around-right-piece
	(sure-guess (x ?x) (y ?y) (content right))
	(not (sure-guess (x ?x) (y ?y1 &:(eq ?y1 (+ ?y 1))) (content water)))
	(test (<= (+ ?y 1) 9))
=>
	(printout t "Fill cell [" ?x ", " (+ ?y 1) "] with water." crlf)
	(assert (sure-guess (x ?x) (y (+ ?y 1)) (content water)))
)

(defrule fill-water-down-right-around-right-piece
	(sure-guess (x ?x) (y ?y) (content right))
	(not (sure-guess (x ?x1 &:(eq ?x1 (+ ?x 1))) (y ?y1 &:(eq ?y1 (+ ?y 1))) (content water)))
	(test (<= (+ ?x 1) 9))
	(test (<= (+ ?y 1) 9))
=>
	(printout t "Fill cell [" (+ ?x 1) ", " (+ ?y 1) "] with water." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y (+ ?y 1)) (content water)))
)

(defrule fill-water-down-mid-around-right-piece
	(sure-guess (x ?x) (y ?y) (content right))
	(not (sure-guess (x ?x1 &:(eq ?x1 (+ ?x 1))) (y ?y) (content water)))
	(test (<= (+ ?x 1) 9))
=>
	(printout t "Fill cell [" (+ ?x 1) ", " ?y "] with water." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y ?y) (content water)))
)

(defrule fill-water-down-left-around-right-piece
	(sure-guess (x ?x) (y ?y) (content right))
	(not (sure-guess (x ?x1 &:(eq ?x1 (+ ?x 1))) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water)))
	(test (<= (+ ?x 1) 9))
	(test (>= (- ?y 1) 0))
=>
	(printout t "Fill cell [" (+ ?x 1) ", " (- ?y 1) "] with water." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y (- ?y 1)) (content water)))
)

; Riempio di acqua le celle attorno a pezzi left
(defrule fill-water-up-left-around-left-piece
	(sure-guess (x ?x) (y ?y) (content left))
	(not (sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water)))
	(test (>= (- ?x 1) 0))
	(test (>= (- ?y 1) 0))
=>
	(printout t "Fill cell [" (- ?x 1) ", " (- ?y 1) "] with water." crlf)
	(assert (sure-guess (x (- ?x 1)) (y (- ?y 1)) (content water)))
)

(defrule fill-water-up-mid-around-left-piece
	(sure-guess (x ?x) (y ?y) (content left))
	(not (sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y) (content water)))
	(test (>= (- ?x 1) 0))
=>
	(printout t "Fill cell [" (- ?x 1) ", " ?y "] with water." crlf)
	(assert (sure-guess (x (- ?x 1)) (y ?y) (content water)))
)

(defrule fill-water-up-right-around-left-piece
	(sure-guess (x ?x) (y ?y) (content left))
	(not (sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y1 &:(eq ?y1 (+ ?y 1))) (content water)))
	(test (>= (- ?x 1) 0))
	(test (<= (+ ?y 1) 9))
=>
	(printout t "Fill cell [" (- ?x 1) ", " (+ ?y 1) "] with water." crlf)
	(assert (sure-guess (x (- ?x 1)) (y (+ ?y 1)) (content water)))
)

(defrule fill-water-mid-left-around-left-piece
	(sure-guess (x ?x) (y ?y) (content left))
	(not (sure-guess (x ?x) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water)))
	(test (>= (- ?y 1) 0))
=>
	(printout t "Fill cell [" ?x ", " (- ?y 1) "] with water." crlf)
	(assert (sure-guess (x ?x) (y (- ?y 1)) (content water)))
)

(defrule fill-water-down-left-around-left-piece
	(sure-guess (x ?x) (y ?y) (content left))
	(not (sure-guess (x ?x1 &:(eq ?x1 (+ ?x 1))) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water)))
	(test (<= (+ ?x 1) 9))
	(test (>= (- ?y 1) 0))
=>
	(printout t "Fill cell [" (+ ?x 1) ", " (- ?y 1) "] with water." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y (- ?y 1)) (content water)))
)

(defrule fill-water-down-mid-around-left-piece
	(sure-guess (x ?x) (y ?y) (content left))
	(not (sure-guess (x ?x1 &:(eq ?x1 (+ ?x 1))) (y ?y) (content water)))
	(test (<= (+ ?x 1) 9))
=>
	(printout t "Fill cell [" (+ ?x 1) ", " ?y "] with water." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y ?y) (content water)))
)

(defrule fill-water-down-right-around-left-piece
	(sure-guess (x ?x) (y ?y) (content left))
	(not (sure-guess (x ?x1 &:(eq ?x1 (+ ?x 1))) (y ?y1 &:(eq ?y1 (+ ?y 1))) (content water)))
	(test (<= (+ ?x 1) 9))
	(test (<= (+ ?y 1) 9))
=>
	(printout t "Fill cell [" (+ ?x 1) ", " (+ ?y 1) "] with water." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y (+ ?y 1)) (content water)))
)

; Riempio di acqua le celle attorno a pezzi top
(defrule fill-water-up-left-around-top-piece
	(sure-guess (x ?x) (y ?y) (content top))
	(not (sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water)))
	(test (>= (- ?x 1) 0))
	(test (>= (- ?y 1) 0))
=>
	(printout t "Fill cell [" (- ?x 1) ", " (- ?y 1) "] with water." crlf)
	(assert (sure-guess (x (- ?x 1)) (y (- ?y 1)) (content water)))
)

(defrule fill-water-up-mid-around-top-piece
	(sure-guess (x ?x) (y ?y) (content top))
	(not (sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y) (content water)))
	(test (>= (- ?x 1) 0))
=>
	(printout t "Fill cell [" (- ?x 1) ", " ?y "] with water." crlf)
	(assert (sure-guess (x (- ?x 1)) (y ?y) (content water)))
)

(defrule fill-water-up-right-around-top-piece
	(sure-guess (x ?x) (y ?y) (content top))
	(not (sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y1 &:(eq ?y1 (+ ?y 1))) (content water)))
	(test (>= (- ?x 1) 0))
	(test (<= (+ ?y 1) 9))
=>
	(printout t "Fill cell [" (- ?x 1) ", " (+ ?y 1) "] with water." crlf)
	(assert (sure-guess (x (- ?x 1)) (y (+ ?y 1)) (content water)))
)

(defrule fill-water-mid-left-around-top-piece
	(sure-guess (x ?x) (y ?y) (content top))
	(not (sure-guess (x ?x) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water)))
	(test (>= (- ?y 1) 0))
=>
	(printout t "Fill cell [" ?x ", " (- ?y 1) "] with water." crlf)
	(assert (sure-guess (x ?x) (y (- ?y 1)) (content water)))
)

(defrule fill-water-mid-right-around-top-piece
	(sure-guess (x ?x) (y ?y) (content top))
	(not (sure-guess (x ?x) (y ?y1 &:(eq ?y1 (+ ?y 1))) (content water)))
	(test (<= (+ ?y 1) 9))
=>
	(printout t "Fill cell [" ?x ", " (+ ?y 1) "] with water." crlf)
	(assert (sure-guess (x ?x) (y (+ ?y 1)) (content water)))
)

(defrule fill-water-down-left-around-top-piece
	(sure-guess (x ?x) (y ?y) (content top))
	(not (sure-guess (x ?x1 &:(eq ?x1 (+ ?x 1))) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water)))
	(test (<= (+ ?x 1) 9))
	(test (>= (- ?y 1) 0))
=>
	(printout t "Fill cell [" (+ ?x 1) ", " (- ?y 1) "] with water." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y (- ?y 1)) (content water)))
)

(defrule fill-water-down-right-around-top-piece
	(sure-guess (x ?x) (y ?y) (content top))
	(not (sure-guess (x ?x1 &:(eq ?x1 (+ ?x 1))) (y ?y1 &:(eq ?y1 (+ ?y 1))) (content water)))
	(test (<= (+ ?x 1) 9))
	(test (<= (+ ?y 1) 9))
=>
	(printout t "Fill cell [" (+ ?x 1) ", " (+ ?y 1) "] with water." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y (+ ?y 1)) (content water)))
)

; Riempio di acqua le celle attorno a pezzi bottom
(defrule fill-water-up-left-around-bot-piece
	(sure-guess (x ?x) (y ?y) (content bot))
	(not (sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water)))
	(test (>= (- ?x 1) 0))
	(test (>= (- ?y 1) 0))
=>
	(printout t "Fill cell [" (- ?x 1) ", " (- ?y 1) "] with water." crlf)
	(assert (sure-guess (x (- ?x 1)) (y (- ?y 1)) (content water)))
)

(defrule fill-water-up-right-around-bot-piece
	(sure-guess (x ?x) (y ?y) (content bot))
	(not (sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y1 &:(eq ?y1 (+ ?y 1))) (content water)))
	(test (>= (- ?x 1) 0))
	(test (<= (+ ?y 1) 9))
=>
	(printout t "Fill cell [" (- ?x 1) ", " (+ ?y 1) "] with water." crlf)
	(assert (sure-guess (x (- ?x 1)) (y (+ ?y 1)) (content water)))
)

(defrule fill-water-mid-left-around-bot-piece
	(sure-guess (x ?x) (y ?y) (content bot))
	(not (sure-guess (x ?x) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water)))
	(test (>= (- ?y 1) 0))
=>
	(printout t "Fill cell [" ?x ", " (- ?y 1) "] with water." crlf)
	(assert (sure-guess (x ?x) (y (- ?y 1)) (content water)))
)

(defrule fill-water-mid-right-around-bot-piece
	(sure-guess (x ?x) (y ?y) (content bot))
	(not (sure-guess (x ?x) (y ?y1 &:(eq ?y1 (+ ?y 1))) (content water)))
	(test (<= (+ ?y 1) 9))
=>
	(printout t "Fill cell [" ?x ", " (+ ?y 1) "] with water." crlf)
	(assert (sure-guess (x ?x) (y (+ ?y 1)) (content water)))
)

(defrule fill-water-down-left-around-bot-piece
	(sure-guess (x ?x) (y ?y) (content bot))
	(not (sure-guess (x ?x1 &:(eq ?x1 (+ ?x 1))) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water)))
	(test (<= (+ ?x 1) 9))
	(test (>= (- ?y 1) 0))
=>
	(printout t "Fill cell [" (+ ?x 1) ", " (- ?y 1) "] with water." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y (- ?y 1)) (content water)))
)

(defrule fill-water-down-mid-around-bot-piece
	(sure-guess (x ?x) (y ?y) (content bot))
	(not (sure-guess (x ?x1 &:(eq ?x1 (+ ?x 1))) (y ?y) (content water)))
	(test (<= (+ ?x 1) 9))
=>
	(printout t "Fill cell [" (+ ?x 1) ", " ?y "] with water." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y ?y) (content water)))
)

(defrule fill-water-down-right-around-bot-piece
	(sure-guess (x ?x) (y ?y) (content bot))
	(not (sure-guess (x ?x1 &:(eq ?x1 (+ ?x 1))) (y ?y1 &:(eq ?y1 (+ ?y 1))) (content water)))
	(test (<= (+ ?x 1) 9))
	(test (<= (+ ?y 1) 9))
=>
	(printout t "Fill cell [" (+ ?x 1) ", " (+ ?y 1) "] with water." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y (+ ?y 1)) (content water)))
)

; Riempio di acqua le celle attorno a pezzi sub
(defrule fill-water-up-left-around-sub-piece
	(sure-guess (x ?x) (y ?y) (content sub))
	(not (sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water)))
	(test (>= (- ?x 1) 0))
	(test (>= (- ?y 1) 0))
=>
	(printout t "Fill cell [" (- ?x 1) ", " (- ?y 1) "] with water." crlf)
	(assert (sure-guess (x (- ?x 1)) (y (- ?y 1)) (content water)))
)

(defrule fill-water-up-mid-around-sub-piece
	(sure-guess (x ?x) (y ?y) (content sub))
	(not (sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y) (content water)))
	(test (>= (- ?x 1) 0))
=>
	(printout t "Fill cell [" (- ?x 1) ", " ?y "] with water." crlf)
	(assert (sure-guess (x (- ?x 1)) (y ?y) (content water)))
)

(defrule fill-water-up-right-around-sub-piece
	(sure-guess (x ?x) (y ?y) (content sub))
	(not (sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y1 &:(eq ?y1 (+ ?y 1))) (content water)))
	(test (>= (- ?x 1) 0))
	(test (<= (+ ?y 1) 9))
=>
	(printout t "Fill cell [" (- ?x 1) ", " (+ ?y 1) "] with water." crlf)
	(assert (sure-guess (x (- ?x 1)) (y (+ ?y 1)) (content water)))
)

(defrule fill-water-mid-left-around-sub-piece
	(sure-guess (x ?x) (y ?y) (content sub))
	(not (sure-guess (x ?x) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water)))
	(test (>= (- ?y 1) 0))
=>
	(printout t "Fill cell [" ?x ", " (- ?y 1) "] with water." crlf)
	(assert (sure-guess (x ?x) (y (- ?y 1)) (content water)))
)

(defrule fill-water-mid-right-around-sub-piece
	(sure-guess (x ?x) (y ?y) (content sub))
	(not (sure-guess (x ?x) (y ?y1 &:(eq ?y1 (+ ?y 1))) (content water)))
	(test (<= (+ ?y 1) 9))
=>
	(printout t "Fill cell [" ?x ", " (+ ?y 1) "] with water." crlf)
	(assert (sure-guess (x ?x) (y (+ ?y 1)) (content water)))
)

(defrule fill-water-down-left-around-sub-piece
	(sure-guess (x ?x) (y ?y) (content sub))
	(not (sure-guess (x ?x1 &:(eq ?x1 (+ ?x 1))) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water)))
	(test (<= (+ ?x 1) 9))
	(test (>= (- ?y 1) 0))
=>
	(printout t "Fill cell [" (+ ?x 1) ", " (- ?y 1) "] with water." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y (- ?y 1)) (content water)))
)

(defrule fill-water-down-mid-around-sub-piece
	(sure-guess (x ?x) (y ?y) (content sub))
	(not (sure-guess (x ?x1 &:(eq ?x1 (+ ?x 1))) (y ?y) (content water)))
	(test (<= (+ ?x 1) 9))
=>
	(printout t "Fill cell [" (+ ?x 1) ", " ?y "] with water." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y ?y) (content water)))
)

(defrule fill-water-down-right-around-sub-piece
	(sure-guess (x ?x) (y ?y) (content sub))
	(not (sure-guess (x ?x1 &:(eq ?x1 (+ ?x 1))) (y ?y1 &:(eq ?y1 (+ ?y 1))) (content water)))
	(test (<= (+ ?x 1) 9))
	(test (<= (+ ?y 1) 9))
=>
	(printout t "Fill cell [" (+ ?x 1) ", " (+ ?y 1) "] with water." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y (+ ?y 1)) (content water)))
)

; Riempio di acqua le celle attorno a pezzi middle
(defrule fill-water-up-left-around-middle-piece
	(sure-guess (x ?x) (y ?y) (content middle))
	(not (sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water)))
	(test (>= (- ?x 1) 0))
	(test (>= (- ?y 1) 0))
=>
	(printout t "Fill cell [" (- ?x 1) ", " (- ?y 1) "] with water." crlf)
	(assert (sure-guess (x (- ?x 1)) (y (- ?y 1)) (content water)))
)

(defrule fill-water-up-mid-around-middle-piece
	(sure-guess (x ?x) (y ?y) (content middle))
	; se non ho già riempito la cella sopra con qualcosa (che potrebbe essere sia acqua che un pezzo di barca)
	(not (sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y)))
	(test (>= (- ?x 1) 0))
=>
	(printout t "Fill cell [" (- ?x 1) ", " ?y "] with water." crlf)
	(assert (sure-guess (x (- ?x 1)) (y ?y) (content water)))
)

(defrule fill-water-up-right-around-middle-piece
	(sure-guess (x ?x) (y ?y) (content middle))
	(not (sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y1 &:(eq ?y1 (+ ?y 1))) (content water)))
	(test (>= (- ?x 1) 0))
	(test (<= (+ ?y 1) 9))
=>
	(printout t "Fill cell [" (- ?x 1) ", " (+ ?y 1) "] with water." crlf)
	(assert (sure-guess (x (- ?x 1)) (y (+ ?y 1)) (content water)))
)

(defrule fill-water-mid-left-around-middle-piece
	(sure-guess (x ?x) (y ?y) (content middle))
	; se non ho già riempito la cella a sinistra con qualcosa (che potrebbe essere sia acqua che un pezzo di barca)
	(not (sure-guess (x ?x) (y ?y1 &:(eq ?y1 (- ?y 1)))))
	(test (>= (- ?y 1) 0))
=>
	(printout t "Fill cell [" ?x ", " (- ?y 1) "] with water." crlf)
	(assert (sure-guess (x ?x) (y (- ?y 1)) (content water)))
)

(defrule fill-water-mid-right-around-middle-piece
	(sure-guess (x ?x) (y ?y) (content middle))
	; se non ho già riempito la cella a destra con qualcosa (che potrebbe essere sia acqua che un pezzo di barca)
	(not (sure-guess (x ?x) (y ?y1 &:(eq ?y1 (+ ?y 1)))))
	(test (<= (+ ?y 1) 9))
=>
	(printout t "Fill cell [" ?x ", " (+ ?y 1) "] with water." crlf)
	(assert (sure-guess (x ?x) (y (+ ?y 1)) (content water)))
)

(defrule fill-water-down-left-around-middle-piece
	(sure-guess (x ?x) (y ?y) (content middle))
	(not (sure-guess (x ?x1 &:(eq ?x1 (+ ?x 1))) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water)))
	(test (<= (+ ?x 1) 9))
	(test (>= (- ?y 1) 0))
=>
	(printout t "Fill cell [" (+ ?x 1) ", " (- ?y 1) "] with water." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y (- ?y 1)) (content water)))
)

(defrule fill-water-down-mid-around-middle-piece
	(sure-guess (x ?x) (y ?y) (content middle))
	; se non ho già riempito la cella sotto con qualcosa (che potrebbe essere sia acqua che un pezzo di barca)
	(not (sure-guess (x ?x1 &:(eq ?x1 (+ ?x 1))) (y ?y)))
	(test (<= (+ ?x 1) 9))
=>
	(printout t "Fill cell [" (+ ?x 1) ", " ?y "] with water." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y ?y) (content water)))
)

(defrule fill-water-down-right-around-middle-piece
	(sure-guess (x ?x) (y ?y) (content middle))
	(not (sure-guess (x ?x1 &:(eq ?x1 (+ ?x 1))) (y ?y1 &:(eq ?y1 (+ ?y 1))) (content water)))
	(test (<= (+ ?x 1) 9))
	(test (<= (+ ?y 1) 9))
=>
	(printout t "Fill cell [" (+ ?x 1) ", " (+ ?y 1) "] with water." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y (+ ?y 1)) (content water)))
)

; Riempio di acqua le celle attorno a pezzi piece
(defrule fill-water-up-left-around-piece
	(sure-guess (x ?x) (y ?y) (content piece))
	(not (sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water)))
	(test (>= (- ?x 1) 0))
	(test (>= (- ?y 1) 0))
=>
	(printout t "Fill cell [" (- ?x 1) ", " (- ?y 1) "] with water." crlf)
	(assert (sure-guess (x (- ?x 1)) (y (- ?y 1)) (content water)))
)

(defrule fill-water-up-right-around-piece
	(sure-guess (x ?x) (y ?y) (content piece))
	(not (sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y1 &:(eq ?y1 (+ ?y 1))) (content water)))
	(test (>= (- ?x 1) 0))
	(test (<= (+ ?y 1) 9))
=>
	(printout t "Fill cell [" (- ?x 1) ", " (+ ?y 1) "] with water." crlf)
	(assert (sure-guess (x (- ?x 1)) (y (+ ?y 1)) (content water)))
)

(defrule fill-water-down-left-around-piece
	(sure-guess (x ?x) (y ?y) (content piece))
	(not (sure-guess (x ?x1 &:(eq ?x1 (+ ?x 1))) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water)))
	(test (<= (+ ?x 1) 9))
	(test (>= (- ?y 1) 0))
=>
	(printout t "Fill cell [" (+ ?x 1) ", " (- ?y 1) "] with water." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y (- ?y 1)) (content water)))
)

(defrule fill-water-down-right-around-piece
	(sure-guess (x ?x) (y ?y) (content piece))
	(not (sure-guess (x ?x1 &:(eq ?x1 (+ ?x 1))) (y ?y1 &:(eq ?y1 (+ ?y 1))) (content water)))
	(test (<= (+ ?x 1) 9))
	(test (<= (+ ?y 1) 9))
=>
	(printout t "Fill cell [" (+ ?x 1) ", " (+ ?y 1) "] with water." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y (+ ?y 1)) (content water)))
)



;  -------------------------------------------------------------------
;  --- Aggiorno il numero di pezzi presenti in ogni riga e -----------
;  --- colonna sottraendoci il numero di sure-guess fatte su ---------
;  --- quelle righe e colonne ----------------------------------------
;  -------------------------------------------------------------------
(defrule update-num-pieces-per-row-and-col
	(sure-guess (x ?x) (y ?y) (content ?p &~water))
	?r <- (row-pieces (row ?x) (num ?numr))
	?c <- (col-pieces (col ?y) (num ?numc))
	(not (counted-piece (x ?x) (y ?y)))
=>
	(modify ?r (num (- ?numr 1)))
	(modify ?c (num (- ?numc 1)))
	(assert (counted-piece (x ?x) (y ?y)))
	(printout t "Update row " ?x " num pieces to " (- ?numr 1) " given " ?p " in cell [" ?x ", " ?y "]." crlf)
	(printout t "Update col " ?y " num pieces to " (- ?numc 1) " given " ?p " in cell [" ?x ", " ?y "]." crlf)
)



;  -------------------------------------------------------------------
;  --- Aggiorno il numero di celle vuote in ogni riga e colonna ------
;  -------------------------------------------------------------------
(defrule update-empty-cells-per-row-and-col
	(sure-guess (x ?x) (y ?y) (content ?p))
	?r <- (empty-cells-per-row (row ?x) (num ?numr))
	?c <- (empty-cells-per-col (col ?y) (num ?numc))
	(not (counted-cell (x ?x) (y ?y)))
=>
	(modify ?r (num (- ?numr 1)))
	(modify ?c (num (- ?numc 1)))
	(assert (counted-cell (x ?x) (y ?y)))
	(printout t "Update row " ?x " num empty cells to " (- ?numr 1) " given " ?p " in cell [" ?x ", " ?y "]." crlf)
	(printout t "Update col " ?y " num empty cells to " (- ?numc 1) " given " ?p " in cell [" ?x ", " ?y "]." crlf)
)



;  -------------------------------------------------------------------
;  --- Aggiorno le celle vuote cancellandone il fatto che le ---------
;  --- rappresenta, se è presente una sure-guess in quella cella -----
;  -------------------------------------------------------------------
(defrule update-empty-cells
	(sure-guess (x ?x) (y ?y))
	?e <- (empty-cell (x ?x) (y ?y))
=>
	(retract ?e)
	(printout t "Cell [" ?x ", " ?y "] is not empty anymore." crlf)
)



;  -------------------------------------------------------------------
;  --- Aggiorno il rapporto tra pezzi rimasti e celle libere ---------
;  --- in ogni riga e colonna. Importante che vengano aggiornati -----
;  --- dopo aver aggiornato il numero di pezzi e celle libere --------
;  -------------------------------------------------------------------
(defrule update-ratio-per-row-and-col (declare (salience -5))
	(sure-guess (x ?x) (y ?y) (content ?p))
	(row-pieces (row ?x) (num ?numr&:(> ?numr 0)))
	(empty-cells-per-row (row ?x) (num ?numer&:(> ?numer 0)))
	(col-pieces (col ?y) (num ?numc&:(> ?numc 0)))
	(empty-cells-per-col (col ?y) (num ?numec&:(> ?numec 0)))
	(not (counted-for-ratio (x ?x) (y ?y)))
	?r <- (row-ratio (row ?x) (ratio ?ratior))
	?c <- (col-ratio (col ?y) (ratio ?ratioc))
=>
	(modify ?r (ratio (/ ?numr ?numer)))
	(modify ?c (ratio (/ ?numc ?numec)))
	(assert (counted-for-ratio (x ?x) (y ?y)))
	(printout t "Update row " ?x " ratio to " (/ ?numr ?numer) crlf)
	(printout t "Update col " ?y " ratio to " (/ ?numc ?numec) crlf)
)

(defrule update-ratio-per-row-when-col-0 (declare (salience -5))
	(sure-guess (x ?x) (y ?y) (content ?p))
	(row-pieces (row ?x) (num ?numr&:(> ?numr 0)))
	(empty-cells-per-row (row ?x) (num ?numer&:(> ?numer 0)))
	(col-pieces (col ?y) (num 0))
	(empty-cells-per-col (col ?y) (num 0))
	(not (counted-for-ratio (x ?x) (y ?y)))
	?r <- (row-ratio (row ?x) (ratio ?ratior))
	?c <- (col-ratio (col ?y) (ratio ?ratioc))
=>
	(modify ?r (ratio (/ ?numr ?numer)))
	(modify ?c (ratio 0))
	(assert (counted-for-ratio (x ?x) (y ?y)))
	(printout t "Update row " ?x " ratio to " (/ ?numr ?numer) crlf)
	(printout t "Update col " ?y " ratio to " 0 crlf)
)

(defrule update-ratio-per-col-when-row-0 (declare (salience -5))
	(sure-guess (x ?x) (y ?y) (content ?p))
	(row-pieces (row ?x) (num 0))
	(empty-cells-per-row (row ?x) (num 0))
	(col-pieces (col ?y) (num ?numc&:(> ?numc 0)))
	(empty-cells-per-col (col ?y) (num ?numec&:(> ?numec 0)))
	(not (counted-for-ratio (x ?x) (y ?y)))
	?r <- (row-ratio (row ?x) (ratio ?ratior))
	?c <- (col-ratio (col ?y) (ratio ?ratioc))
=>
	(modify ?r (ratio 0))
	(modify ?c (ratio (/ ?numc ?numec)))
	(assert (counted-for-ratio (x ?x) (y ?y)))
	(printout t "Update row " ?x " ratio to " 0 crlf)
	(printout t "Update col " ?y " ratio to " (/ ?numc ?numec) crlf)
)

(defrule update-ratio-per-row-and-col-when-all-0 (declare (salience -5))
	(sure-guess (x ?x) (y ?y) (content ?p))
	(row-pieces (row ?x) (num 0))
	(empty-cells-per-row (row ?x) (num 0))
	(col-pieces (col ?y) (num 0))
	(empty-cells-per-col (col ?y) (num 0))
	(not (counted-for-ratio (x ?x) (y ?y)))
	?r <- (row-ratio (row ?x) (ratio ?ratior))
	?c <- (col-ratio (col ?y) (ratio ?ratioc))
=>
	(modify ?r (ratio 0))
	(modify ?c (ratio 0))
	(assert (counted-for-ratio (x ?x) (y ?y)))
	(printout t "Update row " ?x " ratio to " 0 crlf)
	(printout t "Update col " ?y " ratio to " 0 crlf)
)



;  -------------------------------------------------------------------
;  --- Cerco, date le sure-guess che ho fatto le barche --------------
;  --- completamente affondate ---------------------------------------
;  -------------------------------------------------------------------
; Trovo i sub affondati
(defrule sunk-one-given-sub
	?s <- (sunk-boats (one ?n &:(< ?n 4)))
	(sure-guess (x ?x) (y ?y) (content sub))
	(not (sunk-check (x ?x) (y ?y)))
=>
	(printout t "Sink sub in cell [" ?x ", " ?y "]." crlf)
	(modify ?s (one (+ ?n 1)))
	(assert (sunk-check (x ?x) (y ?y)))
)

(defrule sunk-one-given-piece-in-the-middle
	?s <- (sunk-boats (one ?n &:(< ?n 4)))
	(sure-guess (x ?x) (y ?y) (content piece))
	(not (sunk-check (x ?x) (y ?y)))
	(sure-guess (x ?x) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water))
	(sure-guess (x ?x) (y ?y2 &:(eq ?y2 (+ ?y 1))) (content water))
	(sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y) (content water))
	(sure-guess (x ?x2 &:(eq ?x2 (+ ?x 1))) (y ?y) (content water))
=>
	(printout t "Sink sub in cell [" ?x ", " ?y "]." crlf)
	(modify ?s (one (+ ?n 1)))
	(assert (sunk-check (x ?x) (y ?y)))
)

(defrule sunk-one-given-piece-left-border
	?s <- (sunk-boats (one ?n &:(< ?n 4)))
	(sure-guess (x ?x) (y ?y&:(eq ?y 0)) (content piece))
	(not (sunk-check (x ?x) (y ?y)))
	(sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y 0) (content water))
	(sure-guess (x ?x2 &:(eq ?x2 (+ ?x 1))) (y 0) (content water))
	(sure-guess (x ?x) (y ?y1 &:(eq ?y1 (+ ?y 1))) (content water))
=>
	(printout t "Sink sub in cell [" ?x ", " 0 "]." crlf)
	(modify ?s (one (+ ?n 1)))
	(assert (sunk-check (x ?x) (y 0)))
)

(defrule sunk-one-given-piece-right-border
	?s <- (sunk-boats (one ?n &:(< ?n 4)))
	(sure-guess (x ?x) (y ?y&:(eq ?y 9)) (content piece))
	(not (sunk-check (x ?x) (y ?y)))
	(sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y 9) (content water))
	(sure-guess (x ?x2 &:(eq ?x2 (+ ?x 1))) (y 9) (content water))
	(sure-guess (x ?x) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water))
=>
	(printout t "Sink sub in cell [" ?x ", " 9 "]." crlf)
	(modify ?s (one (+ ?n 1)))
	(assert (sunk-check (x ?x) (y 9)))
)

(defrule sunk-one-given-piece-top-border
	?s <- (sunk-boats (one ?n &:(< ?n 4)))
	(sure-guess (x ?x&:(eq ?x 0)) (y ?y) (content piece))
	(not (sunk-check (x ?x) (y ?y)))
	(sure-guess (x 0) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water))
	(sure-guess (x 0) (y ?y2 &:(eq ?y2 (+ ?y 1))) (content water))
	(sure-guess (x ?x1 &:(eq ?x1 (+ ?x 1))) (y ?y) (content water))
=>
	(printout t "Sink sub in cell [" 0 ", " ?y "]." crlf)
	(modify ?s (one (+ ?n 1)))
	(assert (sunk-check (x 0) (y ?y)))
)

(defrule sunk-one-given-piece-bottom-border
	?s <- (sunk-boats (one ?n &:(< ?n 4)))
	(sure-guess (x ?x&:(eq ?x 9)) (y ?y) (content piece))
	(not (sunk-check (x ?x) (y ?y)))
	(sure-guess (x 9) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water))
	(sure-guess (x 9) (y ?y2 &:(eq ?y2 (+ ?y 1))) (content water))
	(sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y) (content water))
=>
	(printout t "Sink sub in cell [" 9 ", " ?y "]." crlf)
	(modify ?s (one (+ ?n 1)))
	(assert (sunk-check (x 9) (y ?y)))
)

(defrule sunk-one-given-piece-top-left-corner
	?s <- (sunk-boats (one ?n &:(< ?n 4)))
	(sure-guess (x 0) (y 0) (content piece))
	(not (sunk-check (x 0) (y 0)))
	(sure-guess (x 0) (y 1) (content water))
	(sure-guess (x 1) (y 0) (content water))
=>
	(printout t "Sink sub in cell [" 0 ", " 0 "]." crlf)
	(modify ?s (one (+ ?n 1)))
	(assert (sunk-check (x 0) (y 0)))
)

(defrule sunk-one-given-piece-top-right-corner
	?s <- (sunk-boats (one ?n &:(< ?n 4)))
	(sure-guess (x 0) (y 9) (content piece))
	(not (sunk-check (x 0) (y 9)))
	(sure-guess (x 0) (y 8) (content water))
	(sure-guess (x 1) (y 9) (content water))
=>
	(printout t "Sink sub in cell [" 0 ", " 9 "]." crlf)
	(modify ?s (one (+ ?n 1)))
	(assert (sunk-check (x 0) (y 9)))
)

(defrule sunk-one-given-piece-bottom-left-corner
	?s <- (sunk-boats (one ?n &:(< ?n 4)))
	(sure-guess (x 9) (y 0) (content piece))
	(not (sunk-check (x 9) (y 0)))
	(sure-guess (x 9) (y 1) (content water))
	(sure-guess (x 8) (y 0) (content water))
=>
	(printout t "Sink sub in cell [" 9 ", " 0 "]." crlf)
	(modify ?s (one (+ ?n 1)))
	(assert (sunk-check (x 9) (y 0)))
)

(defrule sunk-one-given-piece-bottom-right-corner
	?s <- (sunk-boats (one ?n &:(< ?n 4)))
	(sure-guess (x 9) (y 9) (content piece))
	(not (sunk-check (x 9) (y 9)))
	(sure-guess (x 9) (y 8) (content water))
	(sure-guess (x 8) (y 9) (content water))
=>
	(printout t "Sink sub in cell [" 9 ", " 9 "]." crlf)
	(modify ?s (one (+ ?n 1)))
	(assert (sunk-check (x 9) (y 9)))
)

; Trovo le barche da due pezzi affondate
(defrule sunk-two-horizontal
	?s <- (sunk-boats (two ?n &:(< ?n 3)))
	(sure-guess (x ?x) (y ?y) (content ?p1 &~water))
	(sure-guess (x ?x) (y ?y1 &:(eq ?y1 (- ?y 1))) (content ?p2 &~water))
	(or 
		(sure-guess (x ?x) (y ?y2 &:(eq ?y2 (- ?y 2))) (content water))
		(and (sure-guess (x ?x) (y 1) (content ?p3 &~water))
			 (sure-guess (x ?x) (y 0) (content ?p4 &~water))
			 (sure-guess (x ?x) (y 2) (content water))
		)
	)
	(or
		(sure-guess (x ?x) (y ?y3 &:(eq ?y3 (+ ?y 1))) (content water))
		(and (sure-guess (x ?x) (y 9) (content ?p5 &~water))
			 (sure-guess (x ?x) (y 8) (content ?p6 &~water))
			 (sure-guess (x ?x) (y 7) (content water))
		)
	)
	(not (sunk-check (x ?x) (y ?y)))
	(not (sunk-check (x ?x) (y ?y1)))
=>
	(printout t "Sink two-pieces boat in cells [" ?x ", " ?y "] and [" ?x ", " ?y1 "]." crlf)
	(modify ?s (two (+ ?n 1)))
	(assert (sunk-check (x ?x) (y ?y)))
	(assert (sunk-check (x ?x) (y ?y1)))
)

(defrule sunk-two-vertical
	?s <- (sunk-boats (two ?n &:(< ?n 3)))
	(sure-guess (x ?x) (y ?y) (content ?p1 &~water))
	(sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y) (content ?p2 &~water))
	(or 
		(sure-guess (x ?x2 &:(eq ?x2 (- ?x 2))) (y ?y) (content water))
		(and (sure-guess (x 1) (y ?y) (content ?p3 &~water))
			 (sure-guess (x 0) (y ?y) (content ?p4 &~water))
			 (sure-guess (x 2) (y ?y) (content water))
		)
	)
	(or
		(sure-guess (x ?x3 &:(eq ?x3 (+ ?x 1))) (y ?y) (content water))
		(and (sure-guess (x 9) (y ?y) (content ?p5 &~water))
			 (sure-guess (x 8) (y ?y) (content ?p6 &~water))
			 (sure-guess (x 7) (y ?y) (content water))
		)
	)
	(not (sunk-check (x ?x) (y ?y)))
	(not (sunk-check (x ?x1) (y ?y)))
=>
	(printout t "Sink two-pieces boat in cells [" ?x ", " ?y "] and [" ?x1 ", " ?y "]." crlf)
	(modify ?s (two (+ ?n 1)))
	(assert (sunk-check (x ?x) (y ?y)))
	(assert (sunk-check (x ?x1) (y ?y)))
)

; Trovo le barche da tre pezzi affondate
(defrule sunk-three-horizontal
	?s <- (sunk-boats (three ?n &:(< ?n 2)))
	(sure-guess (x ?x) (y ?y) (content ?p1 &~water))
	(sure-guess (x ?x) (y ?y1 &:(eq ?y1 (- ?y 1))) (content ?p2 &~water))
	(sure-guess (x ?x) (y ?y2 &:(eq ?y2 (- ?y 2))) (content ?p3 &~water))
	(or 
		(sure-guess (x ?x) (y ?y3 &:(eq ?y3 (- ?y 3))) (content water))
		(and (sure-guess (x ?x) (y 2) (content ?p4 &~water))
			 (sure-guess (x ?x) (y 1) (content ?p5 &~water))
			 (sure-guess (x ?x) (y 0) (content ?p6 &~water))
			 (sure-guess (x ?x) (y 3) (content water))
		)
	)
	(or
		(sure-guess (x ?x) (y ?y4 &:(eq ?y4 (+ ?y 1))) (content water))
		(and (sure-guess (x ?x) (y 9) (content ?p7 &~water))
			 (sure-guess (x ?x) (y 8) (content ?p8 &~water))
			 (sure-guess (x ?x) (y 7) (content ?p9 &~water))
			 (sure-guess (x ?x) (y 6) (content water))
		)
	)
	(not (sunk-check (x ?x) (y ?y)))
	(not (sunk-check (x ?x) (y ?y1)))
	(not (sunk-check (x ?x) (y ?y2)))
=>
	(printout t "Sink three-pieces boat in cells [" ?x ", " ?y "], [" ?x ", " ?y1 "] and [" ?x ", " ?y2 "]." crlf)
	(modify ?s (three (+ ?n 1)))
	(assert (sunk-check (x ?x) (y ?y)))
	(assert (sunk-check (x ?x) (y ?y1)))
	(assert (sunk-check (x ?x) (y ?y2)))
)

(defrule sunk-three-vertical
	?s <- (sunk-boats (three ?n &:(< ?n 2)))
	(sure-guess (x ?x) (y ?y) (content ?p1 &~water))
	(sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y) (content ?p2 &~water))
	(sure-guess (x ?x2 &:(eq ?x2 (- ?x 2))) (y ?y) (content ?p3 &~water))
	(or 
		(sure-guess (x ?x3 &:(eq ?x3 (- ?x 3))) (y ?y) (content water))
		(and (sure-guess (x 2) (y ?y) (content ?p4 &~water))
			 (sure-guess (x 1) (y ?y) (content ?p5 &~water))
			 (sure-guess (x 0) (y ?y) (content ?p6 &~water))
			 (sure-guess (x 3) (y ?y) (content water))
		)
	)
	(or
		(sure-guess (x ?x4 &:(eq ?x4 (+ ?x 1))) (y ?y) (content water))
		(and (sure-guess (x 9) (y ?y) (content ?p7 &~water))
			 (sure-guess (x 8) (y ?y) (content ?p8 &~water))
			 (sure-guess (x 7) (y ?y) (content ?p9 &~water))
			 (sure-guess (x 6) (y ?y) (content water))
		)
	)
	(not (sunk-check (x ?x) (y ?y)))
	(not (sunk-check (x ?x1) (y ?y)))
	(not (sunk-check (x ?x2) (y ?y)))
=>
	(printout t "Sink three-pieces boat in cells [" ?x ", " ?y "], [" ?x1 ", " ?y "] and [" ?x2 ", " ?y "]." crlf)
	(modify ?s (three (+ ?n 1)))
	(assert (sunk-check (x ?x) (y ?y)))
	(assert (sunk-check (x ?x1) (y ?y)))
	(assert (sunk-check (x ?x2) (y ?y)))
)

; Trovo la barca da quattro pezzi affondata
(defrule sunk-four-horizontal
	?s <- (sunk-boats (four ?n &:(< ?n 1)))
	(sure-guess (x ?x) (y ?y) (content ?p1 &~water))
	(sure-guess (x ?x) (y ?y1 &:(eq ?y1 (- ?y 1))) (content ?p2 &~water))
	(sure-guess (x ?x) (y ?y2 &:(eq ?y2 (- ?y 2))) (content ?p3 &~water))
	(sure-guess (x ?x) (y ?y3 &:(eq ?y3 (- ?y 3))) (content ?p4 &~water))
	(not (sunk-check (x ?x) (y ?y)))
	(not (sunk-check (x ?x) (y ?y1)))
	(not (sunk-check (x ?x) (y ?y2)))
	(not (sunk-check (x ?x) (y ?y3)))
=>
	(printout t "Sink four-pieces boat in cells [" ?x ", " ?y "], [" ?x ", " ?y1 "], [" ?x ", " ?y2 "] and [" ?x ", " ?y3 "]." crlf)
	(modify ?s (four (+ ?n 1)))
	(assert (sunk-check (x ?x) (y ?y)))
	(assert (sunk-check (x ?x) (y ?y1)))
	(assert (sunk-check (x ?x) (y ?y2)))
	(assert (sunk-check (x ?x) (y ?y3)))
)

(defrule sunk-four-vertical
	?s <- (sunk-boats (four ?n &:(< ?n 1)))
	(sure-guess (x ?x) (y ?y) (content ?p1 &~water))
	(sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y) (content ?p2 &~water))
	(sure-guess (x ?x2 &:(eq ?x2 (- ?x 2))) (y ?y) (content ?p3 &~water))
	(sure-guess (x ?x3 &:(eq ?x3 (- ?x 3))) (y ?y) (content ?p4 &~water))
	(not (sunk-check (x ?x) (y ?y)))
	(not (sunk-check (x ?x1) (y ?y)))
	(not (sunk-check (x ?x2) (y ?y)))
	(not (sunk-check (x ?x3) (y ?y)))
=>
	(printout t "Sink four-pieces boat in cells [" ?x ", " ?y "], [" ?x1 ", " ?y "], [" ?x2 ", " ?y "] and [" ?x3 ", " ?y "]." crlf)
	(modify ?s (four (+ ?n 1)))
	(assert (sunk-check (x ?x) (y ?y)))
	(assert (sunk-check (x ?x1) (y ?y)))
	(assert (sunk-check (x ?x2) (y ?y)))
	(assert (sunk-check (x ?x3) (y ?y)))
)



;  -------------------------------------------------------------------
;  --- Se ho già affondato la nave da 4 e ho tre pezzi di fila -------
;  --- posso dedurre che quei tre pezzi rappresentano una barca ------
;  --- da tre pezzi e quindi posso asserire che ho acqua intorno -----
;  --- ecc ecc per gli altri casi ------------------------------------
;  -------------------------------------------------------------------
(defrule deduce-water-left-3-hor-when-4-sunk
	(sunk-boats (four 1))
	(sure-guess (x ?x) (y ?y) (content ?p1 &~water))
	(sure-guess (x ?x) (y ?y1 &:(eq ?y1 (- ?y 1))) (content ?p2 &~water))
	(sure-guess (x ?x) (y ?y2 &:(eq ?y2 (- ?y 2))) (content ?p3 &~water))
	(not (sure-guess (x ?x) (y ?y3 &:(eq ?y3 (- ?y 3)))))
	(test (>= (- ?y 3) 0))
=>
	(printout t "Deduce water in cell [" ?x ", " (- ?y 3) "]." crlf)
	(assert (sure-guess (x ?x) (y (- ?y 3)) (content water)))
)

(defrule deduce-water-right-3-hor-when-4-sunk
	(sunk-boats (four 1))
	(sure-guess (x ?x) (y ?y) (content ?p1 &~water))
	(sure-guess (x ?x) (y ?y1 &:(eq ?y1 (- ?y 1))) (content ?p2 &~water))
	(sure-guess (x ?x) (y ?y2 &:(eq ?y2 (- ?y 2))) (content ?p3 &~water))
	(not (sure-guess (x ?x) (y ?y3 &:(eq ?y3 (+ ?y 1)))))
	(test (< (+ ?y 1) 10))
=>
	(printout t "Deduce water in cell [" ?x ", " (+ ?y 1) "]." crlf)
	(assert (sure-guess (x ?x) (y (+ ?y 1)) (content water)))
)

(defrule deduce-water-up-3-ver-when-4-sunk
	(sunk-boats (four 1))
	(sure-guess (x ?x) (y ?y) (content ?p1 &~water))
	(sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y) (content ?p2 &~water))
	(sure-guess (x ?x2 &:(eq ?x2 (- ?x 2))) (y ?y) (content ?p3 &~water))
	(not (sure-guess (x ?x3 &:(eq ?x3 (- ?x 3))) (y ?y)))
	(test (>= (- ?x 3) 0))
=>
	(printout t "Deduce water in cell [" (- ?x 3) ", " ?y "]." crlf)
	(assert (sure-guess (x (- ?x 3)) (y ?y) (content water)))
)

(defrule deduce-water-down-3-ver-when-4-sunk
	(sunk-boats (four 1))
	(sure-guess (x ?x) (y ?y) (content ?p1 &~water))
	(sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y) (content ?p2 &~water))
	(sure-guess (x ?x2 &:(eq ?x2 (- ?x 2))) (y ?y) (content ?p3 &~water))
	(not (sure-guess (x ?x3 &:(eq ?x3 (+ ?x 1))) (y ?y)))
	(test (< (+ ?x 1) 10))
=>
	(printout t "Deduce water in cell [" (+ ?x 1) ", " ?y "]." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y ?y) (content water)))
)

(defrule deduce-water-left-2-hor-when-3-4-sunk
	(sunk-boats (four 1))
	(sunk-boats (three 2))
	(sure-guess (x ?x) (y ?y) (content ?p1 &~water))
	(sure-guess (x ?x) (y ?y1 &:(eq ?y1 (- ?y 1))) (content ?p2 &~water))
	(not (sure-guess (x ?x) (y ?y2 &:(eq ?y2 (- ?y 2)))))
	(test (>= (- ?y 2) 0))
=>
	(printout t "Deduce water in cell [" ?x ", " (- ?y 2) "]." crlf)
	(assert (sure-guess (x ?x) (y (- ?y 2)) (content water)))
)

(defrule deduce-water-right-2-hor-when-3-4-sunk
	(sunk-boats (four 1))
	(sunk-boats (three 2))
	(sure-guess (x ?x) (y ?y) (content ?p1 &~water))
	(sure-guess (x ?x) (y ?y1 &:(eq ?y1 (- ?y 1))) (content ?p2 &~water))
	(not (sure-guess (x ?x) (y ?y2 &:(eq ?y2 (+ ?y 1)))))
	(test (< (+ ?y 1) 10))
=>
	(printout t "Deduce water in cell [" ?x ", " (+ ?y 1) "]." crlf)
	(assert (sure-guess (x ?x) (y (+ ?y 1)) (content water)))
)

(defrule deduce-water-up-2-ver-when-3-4-sunk
	(sunk-boats (four 1))
	(sunk-boats (three 2))
	(sure-guess (x ?x) (y ?y) (content ?p1 &~water))
	(sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y) (content ?p2 &~water))
	(not (sure-guess (x ?x2 &:(eq ?x2 (- ?x 2))) (y ?y)))
	(test (>= (- ?x 2) 0))
=>
	(printout t "Deduce water in cell [" (- ?x 2) ", " ?y "]." crlf)
	(assert (sure-guess (x (- ?x 2)) (y ?y) (content water)))
)

(defrule deduce-water-down-2-ver-when-3-4-sunk
	(sunk-boats (four 1))
	(sunk-boats (three 2))
	(sure-guess (x ?x) (y ?y) (content ?p1 &~water))
	(sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y) (content ?p2 &~water))
	(not (sure-guess (x ?x2 &:(eq ?x2 (+ ?x 1))) (y ?y)))
	(test (< (+ ?x 1) 10))
=>
	(printout t "Deduce water in cell [" (+ ?x 1) ", " ?y "]." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y ?y) (content water)))
)



;  -------------------------------------------------------------------
;  --- Se ho già affondato tutte le navi da 3 e ho tre pezzi di ------
;  --- fila e acqua sopra o sotto di essi, posso dedurre che ---------
;  --- quei tre pezzi rappresentano una barca da 4 e fare guess ------
;  --- sulla cella adiacente vuota -----------------------------------
;  -------------------------------------------------------------------
(defrule guess-4-piece-up-when-all-3-sunk (declare (salience -10))
	(status (step ?s) (currently running))
	(sunk-boats (three 2))
	(sure-guess (x ?x) (y ?y) (content ?p1 &~water))
	(sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y) (content ?p2 &~water))
	(sure-guess (x ?x2 &:(eq ?x2 (- ?x 2))) (y ?y) (content ?p3 &~water))
	(sure-guess (x ?x3 &:(eq ?x3 (+ ?x 1))) (y ?y) (content water))
	(not (sure-guess (x ?x4 &:(eq ?x4 (- ?x 3))) (y ?y)))
	(not (exec (action guess) (x ?x4 &:(eq ?x4 (- ?x 3))) (y ?y)))
	(test (>= (- ?x 3) 0))
=>
	(printout t "Guess fourth piece in cell [" (- ?x 3) ", " ?y "] because all three-pieces boat sunk." crlf)
	(assert (sure-guess (x (- ?x 3)) (y ?y) (content piece)))
	(assert (exec (step ?s) (action guess) (x (- ?x 3)) (y ?y)))
	(pop-focus)
)

(defrule guess-4-piece-down-when-all-3-sunk (declare (salience -10))
	(status (step ?s) (currently running))
	(sunk-boats (three 2))
	(sure-guess (x ?x) (y ?y) (content ?p1 &~water))
	(sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y) (content ?p2 &~water))
	(sure-guess (x ?x2 &:(eq ?x2 (- ?x 2))) (y ?y) (content ?p3 &~water))
	(sure-guess (x ?x3 &:(eq ?x3 (- ?x 3))) (y ?y) (content water))
	(not (sure-guess (x ?x4 &:(eq ?x4 (+ ?x 1))) (y ?y)))
	(not (exec (action guess) (x ?x4 &:(eq ?x4 (+ ?x 1))) (y ?y)))
	(test (< (+ ?x 1) 10))
=>
	(printout t "Guess piece in cell [" (+ ?x 1) ", " ?y "] because all three-pieces boat sunk." crlf)
	(assert (sure-guess (x (+ ?x 1)) (y ?y) (content piece)))
	(assert (exec (step ?s) (action guess) (x (+ ?x 1)) (y ?y)))
	(pop-focus)
)

(defrule guess-4-piece-left-when-all-3-sunk (declare (salience -10))
	(status (step ?s) (currently running))
	(sunk-boats (three 2))
	(sure-guess (x ?x) (y ?y) (content ?p1 &~water))
	(sure-guess (x ?x) (y ?y1 &:(eq ?y1 (- ?y 1))) (content ?p2 &~water))
	(sure-guess (x ?x) (y ?y2 &:(eq ?y2 (- ?y 2))) (content ?p3 &~water))
	(sure-guess (x ?x) (y ?y3 &:(eq ?y3 (+ ?y 1))) (content water))
	(not (sure-guess (x ?x) (y ?y4 &:(eq ?y4 (- ?y 3)))))
	(not (exec (action guess) (x ?x) (y ?y4 &:(eq ?y4 (- ?y 3)))))
	(test (>= (- ?y 3) 0))
=>
	(printout t "Guess piece in cell [" ?x ", " (- ?y 3) "] because all three-pieces boat sunk." crlf)
	(assert (sure-guess (x ?x) (y (- ?y 3)) (content piece)))
	(assert (exec (step ?s) (action guess) (x ?x) (y (- ?y 3))))
	(pop-focus)
)

(defrule guess-4-piece-right-when-all-3-sunk (declare (salience -10))
	(status (step ?s) (currently running))
	(sunk-boats (three 2))
	(sure-guess (x ?x) (y ?y) (content ?p1 &~water))
	(sure-guess (x ?x) (y ?y1 &:(eq ?y1 (- ?y 1))) (content ?p2 &~water))
	(sure-guess (x ?x) (y ?y2 &:(eq ?y2 (- ?y 2))) (content ?p3 &~water))
	(sure-guess (x ?x) (y ?y3 &:(eq ?y3 (- ?y 3))) (content water))
	(not (sure-guess (x ?x) (y ?y4 &:(eq ?y4 (+ ?y 1)))))
	(not (exec (action guess) (x ?x) (y ?y4 &:(eq ?y4 (+ ?y 1)))))
	(test (< (+ ?y 1) 10))
=>
	(printout t "Guess piece in cell [" ?x ", " (+ ?y 1) "] because all three-pieces boat sunk." crlf)
	(assert (sure-guess (x ?x) (y (+ ?y 1)) (content piece)))
	(assert (exec (step ?s) (action guess) (x ?x) (y (+ ?y 1))))
	(pop-focus)
)



;  -------------------------------------------------------------------
;  --- Se il numero di pezzi rimasti in una riga o colonna è ---------
;  --- uguale al numero di celle vuote, allora posso dedurre ---------
;  --- che ci sono dei pezzi di barca in quelle celle. ---------------
;  --- Importante che vengano eseguite dopo aver aggiornato ----------
;  --- il numero di pezzi e celle vuote per riga e colonna -----------
;  -------------------------------------------------------------------
(defrule deduce-pieces-in-empty-cells-row (declare (salience -10))
	(status (step ?s) (currently running))
	(row-pieces (row ?x) (num ?numr))
	(col-pieces (col ?y) (num ?numc&:(> ?numc 0)))
	(empty-cells-per-row (row ?x) (num ?nume))
	(test (eq ?numr ?nume))
	(not (sure-guess (x ?x) (y ?y)))
	(not (exec (action guess) (x ?x) (y ?y)))
=>
	(printout t "Guess piece in cell [" ?x ", " ?y "] because the number of pieces in row is equal to the number of empty cells." crlf)
	(assert (sure-guess (x ?x) (y ?y) (content piece)))
	(assert (exec (step ?s) (action guess) (x ?x) (y ?y)))
	(pop-focus)
)

(defrule deduce-pieces-in-empty-cells-col (declare (salience -10))
	(status (step ?s) (currently running))
	(row-pieces (row ?x) (num ?numr&:(> ?numr 0)))
	(col-pieces (col ?y) (num ?numc))
	(empty-cells-per-col (col ?y) (num ?nume))
	(test (eq ?numc ?nume))
	(not (sure-guess (x ?x) (y ?y)))
	(not (exec (action guess) (x ?x) (y ?y)))
=>
	(printout t "Guess piece in cell [" ?x ", " ?y "] because the number of pieces in column is equal to the number of empty cells." crlf)
	(assert (sure-guess (x ?x) (y ?y) (content piece)))
	(assert (exec (step ?s) (action guess) (x ?x) (y ?y)))
	(pop-focus)
)



;  -------------------------------------------------------------------
;  --- Fire nella cella più probabile data da: -----------------------
;  --- num pezzi rimasti / num celle vuote, considerando -------------
;  --- sia righe che colonne -----------------------------------------
;  -------------------------------------------------------------------
(defrule fire-most-probable-cell (declare (salience -15))
	(status (step ?s) (currently running))
	(moves (fires ?nf&:(> ?nf 0)))
	(row-ratio (row ?x) (ratio ?rx&:(> ?rx 0)))
	(col-ratio (col ?y) (ratio ?ry&:(> ?ry 0)))
	(not (row-ratio (row ?x2&~?x) (ratio ?rx2&:(> ?rx2 ?rx))))
	(not (col-ratio (col ?y2&~?y) (ratio ?ry2&:(> ?ry2 ?ry))))
	(not (sure-guess (x ?x) (y ?y)))
	(not (exec (action fire) (x ?x) (y ?y)))
=>
	(printout t "Fire in cell [" ?x ", " ?y "]." crlf)
	(assert (exec (step ?s) (action fire) (x ?x) (y ?y)))
	(pop-focus)
)



;  -------------------------------------------------------------------
;  --- Se non trovo la cella più promettente (con sia riga che -------
;  --- colonna con ratio più alta), allora cerco la cella ------------
;  --- con la riga o la colonna con ratio più alta -------------------
;  -------------------------------------------------------------------
(defrule find-best-row-to-fire (declare (salience -20))
	(row-ratio (row ?x) (ratio ?rx&:(> ?rx 0)))
	(col-ratio (col ?y) (ratio ?ry&:(> ?ry 0)))
	(not (row-ratio (row ?x2&~?x) (ratio ?rx2&:(> ?rx2 ?rx))))
	(not (col-ratio (col ?y2&~?y) (ratio ?ry2&:(> ?ry2 ?ry))))
	(test (>= ?rx ?ry))
=>
	(printout t "Best row is " ?x " with ratio " ?rx "." crlf)
	(assert (best-row-or-col (row ?x)))
)

(defrule find-best-col-to-fire (declare (salience -20))
	(row-ratio (row ?x) (ratio ?rx&:(> ?rx 0)))
	(col-ratio (col ?y) (ratio ?ry&:(> ?ry 0)))
	(not (row-ratio (row ?x2&~?x) (ratio ?rx2&:(> ?rx2 ?rx))))
	(not (col-ratio (col ?y2&~?y) (ratio ?ry2&:(> ?ry2 ?ry))))
	(test (> ?ry ?rx))
=>
	(printout t "Best column is " ?y " with ratio " ?ry "." crlf)
	(assert (best-row-or-col (col ?y)))
)

(defrule fire-best-row (declare (salience -20))
	(status (step ?s) (currently running))
	(moves (fires ?nf&:(> ?nf 0)))
	?b <- (best-row-or-col (row ?x) (col -1))
	(empty-cell (x ?x) (y ?y))
	; (col-ratio (col ?y) (ratio ?ry&:(> ?ry 0)))
	; (not (col-ratio (col ?y2&~?y) (ratio ?ry2&:(> ?ry2 ?ry))))
	(not (sure-guess (x ?x) (y ?y)))
	(not (exec (action fire) (x ?x) (y ?y)))
=>
	(printout t "Fire in cell [" ?x ", " ?y "] because it is the best row." crlf)
	(modify ?b (row -1))
	(assert (exec (step ?s) (action fire) (x ?x) (y ?y)))
	(pop-focus)
)

(defrule fire-best-col (declare (salience -20))
	(status (step ?s) (currently running))
	(moves (fires ?nf&:(> ?nf 0)))
	?b <- (best-row-or-col (row -1) (col ?y))
	(empty-cell (x ?x) (y ?y))
	; (row-ratio (row ?x) (ratio ?rx&:(> ?rx 0)))
	; (not (row-ratio (row ?x2&~?x) (ratio ?rx2&:(> ?rx2 ?rx))))
	(not (sure-guess (x ?x) (y ?y)))
	(not (exec (action fire) (x ?x) (y ?y)))
=>
	(printout t "Fire in cell [" ?x ", " ?y "] because it is the best column." crlf)
	(modify ?b (col -1))
	(assert (exec (step ?s) (action fire) (x ?x) (y ?y)))
	(pop-focus)
)



;  -------------------------------------------------------------------
;  --- Se non ho più fire da eseguire allora faccio guess nella ------
;  --- cella più probabile, finchè ho guess a disposizione -----------
;  -------------------------------------------------------------------
(defrule guess-most-probable-cell (declare (salience -25))
	(status (step ?s) (currently running))
	(moves (guesses ?nf&:(> ?nf 0)))
	(row-ratio (row ?x) (ratio ?rx&:(> ?rx 0)))
	(col-ratio (col ?y) (ratio ?ry&:(> ?ry 0)))
	(not (row-ratio (row ?x2&~?x) (ratio ?rx2&:(> ?rx2 ?rx))))
	(not (col-ratio (col ?y2&~?y) (ratio ?ry2&:(> ?ry2 ?ry))))
	(not (sure-guess (x ?x) (y ?y)))
	(not (exec (action guess) (x ?x) (y ?y)))
=>
	(printout t "Try a guess in cell [" ?x ", " ?y "] because it is the most probable cell." crlf)
	(assert (exec (step ?s) (action guess) (x ?x) (y ?y)))
	(assert (sure-guess (x ?x) (y ?y) (content piece)))
	(pop-focus)
)



;  -------------------------------------------------------------------
;  --- Se non trovo la cella più promettente (con sia riga che -------
;  --- colonna con ratio più alta), allora cerco la cella ------------
;  --- con la riga o la colonna con ratio più alta -------------------
;  -------------------------------------------------------------------
(defrule find-best-row-to-guess (declare (salience -20))
	(row-ratio (row ?x) (ratio ?rx&:(> ?rx 0)))
	(col-ratio (col ?y) (ratio ?ry&:(> ?ry 0)))
	(not (row-ratio (row ?x2&~?x) (ratio ?rx2&:(> ?rx2 ?rx))))
	(not (col-ratio (col ?y2&~?y) (ratio ?ry2&:(> ?ry2 ?ry))))
	(test (>= ?rx ?ry))
=>
	(printout t "Best row to guess is " ?x " with ratio " ?rx "." crlf)
	(assert (best-row-or-col (row ?x)))
)

(defrule find-best-col-to-guess (declare (salience -20))
	(row-ratio (row ?x) (ratio ?rx&:(> ?rx 0)))
	(col-ratio (col ?y) (ratio ?ry&:(> ?ry 0)))
	(not (row-ratio (row ?x2&~?x) (ratio ?rx2&:(> ?rx2 ?rx))))
	(not (col-ratio (col ?y2&~?y) (ratio ?ry2&:(> ?ry2 ?ry))))
	(test (> ?ry ?rx))
=>
	(printout t "Best column to guess is " ?y " with ratio " ?ry "." crlf)
	(assert (best-row-or-col (col ?y)))
)

(defrule guess-best-row (declare (salience -20))
	(status (step ?s) (currently running))
	(moves (guesses ?nf&:(> ?nf 0)))
	?b <- (best-row-or-col (row ?x) (col -1))
	(empty-cell (x ?x) (y ?y))
	; (col-ratio (col ?y) (ratio ?ry&:(> ?ry 0)))
	; (not (col-ratio (col ?y2&~?y) (ratio ?ry2&:(> ?ry2 ?ry))))
	(not (sure-guess (x ?x) (y ?y)))
	(not (exec (action guess) (x ?x) (y ?y)))
=>
	(printout t "Guess in cell [" ?x ", " ?y "] because it is the best row." crlf)
	(modify ?b (row -1))
	(assert (exec (step ?s) (action guess) (x ?x) (y ?y)))
	(assert (sure-guess (x ?x) (y ?y) (content piece)))
	(pop-focus)
)

(defrule guess-best-col (declare (salience -20))
	(status (step ?s) (currently running))
	(moves (guesses ?nf&:(> ?nf 0)))
	?b <- (best-row-or-col (row -1) (col ?y))
	(empty-cell (x ?x) (y ?y))
	; (row-ratio (row ?x) (ratio ?rx&:(> ?rx 0)))
	; (not (row-ratio (row ?x2&~?x) (ratio ?rx2&:(> ?rx2 ?rx))))
	(not (sure-guess (x ?x) (y ?y)))
	(not (exec (action guess) (x ?x) (y ?y)))
=>
	(printout t "Guess in cell [" ?x ", " ?y "] because it is the best column." crlf)
	(modify ?b (col -1))
	(assert (exec (step ?s) (action guess) (x ?x) (y ?y)))
	(assert (sure-guess (x ?x) (y ?y) (content piece)))
	(pop-focus)
)



;  ---------------------------------------------
;  --- Quando non ho più azioni da eseguire ----
;  ---------------------------------------------
(defrule finished (declare (salience -30))
	(status (step ?s) (currently running))
=> 
	(printout t "Finished." crlf)
	(assert (exec (step ?s) (action solve)))
	(pop-focus)
)
