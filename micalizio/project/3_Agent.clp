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



;  ---------------------------------------------
;  -------- Fatti iniziali utili ---------------
;  ---------------------------------------------
; Inizializzo per ogni riga e colonna il numero di celle libere (inizialmente 10)
; e il contenitore delle barche affondate
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
(defrule guess-what-is-known (declare (salience 15))
	(status (step ?s) (currently running))
	(k-cell (x ?x) (y ?y) (content ?t & ~water))
	(not (exec (action guess) (x ?x) (y ?y)))
=>
	(printout t "I guess that cell [" ?x ", " ?y "] contains " ?t "." crlf)
	(assert (sure-guess (x ?x) (y ?y) (content ?t)))
	(assert (exec (step ?s) (action guess) (x ?x) (y ?y)))
	(pop-focus)
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
;  --- Cerco, date le sure-guess che ho fatto le barche --------------
;  --- completamente affondate ---------------------------------------
;  -------------------------------------------------------------------
; Trovo i sub affondati
(defrule sunk-one
	?s <- (sunk-boats (one ?n &:(< ?n 4)))
	(sure-guess (x ?x) (y ?y) (content ?p &~water))
	(or 
		(sure-guess (x ?x) (y ?y1 &:(eq ?y1 (- ?y 1))) (content water))
		(eq ?y 0)
	)
	(or
		(sure-guess (x ?x) (y ?y2 &:(eq ?y2 (+ ?y 1))) (content water))
		(eq ?y 9)
	)
	(or
		(sure-guess (x ?x1 &:(eq ?x1 (- ?x 1))) (y ?y) (content water))
		(eq ?x 0)
	)
	(or
		(sure-guess (x ?x2 &:(eq ?x2 (+ ?x 1))) (y ?y) (content water))
		(eq ?x 9)
	)
	(not (sunk-check (x ?x) (y ?y)))
=>
	(printout t "Sunk sub in cell [" ?x ", " ?y "]." crlf)
	(modify ?s (one (+ ?n 1)))
	(assert (sunk-check (x ?x) (y ?y)))
)

; Trovo le barche da due pezzi affondate
(defrule sunk-two-horizontal
	?s <- (sunk-boats (two ?n &:(< ?n 3)))
	(sure-guess (x ?x) (y ?y) (content ?p1 &~water))
	(sure-guess (x ?x) (y ?y1 &:(eq ?y1 (- ?y 1))) (content ?p2 &~water))
	(or 
		(sure-guess (x ?x) (y ?y2 &:(eq ?y2 (- ?y 2))) (content water))
		(eq ?y 1)
	)
	(or
		(sure-guess (x ?x) (y ?y3 &:(eq ?y3 (+ ?y 1))) (content water))
		(eq ?y 9)
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
		(eq ?x 1)
	)
	(or
		(sure-guess (x ?x3 &:(eq ?x3 (+ ?x 1))) (y ?y) (content water))
		(eq ?x 9)
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
		(eq ?y 2)
	)
	(or
		(sure-guess (x ?x) (y ?y4 &:(eq ?y4 (+ ?y 1))) (content water))
		(eq ?y 9)
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
		(eq ?x 2)
	)
	(or
		(sure-guess (x ?x4 &:(eq ?x4 (+ ?x 1))) (y ?y) (content water))
		(eq ?x 9)
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
	(or 
		(sure-guess (x ?x) (y ?y4 &:(eq ?y4 (- ?y 4))) (content water))
		(eq ?y 3)
	)
	(or
		(sure-guess (x ?x) (y ?y5 &:(eq ?y5 (+ ?y 1))) (content water))
		(eq ?y 9)
	)
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
	(or 
		(sure-guess (x ?x4 &:(eq ?x4 (- ?x 4))) (y ?y) (content water))
		(eq ?x 3)
	)
	(or
		(sure-guess (x ?x5 &:(eq ?x5 (+ ?x 1))) (y ?y) (content water))
		(eq ?x 9)
	)
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
	(printout t "Guess piece in cell [" ?x ", " ?y "]." crlf)
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
	(printout t "Guess piece in cell [" ?x ", " ?y "]." crlf)
	(assert (sure-guess (x ?x) (y ?y) (content piece)))
	(assert (exec (step ?s) (action guess) (x ?x) (y ?y)))
	(pop-focus)
)







;  -------------------------------------------------------------------
;  --- Tengo traccia dei vari tipi di barca affondati e --------------
;  --- di quelle che restano da affondare ----------------------------
;  -------------------------------------------------------------------






;  ---------------------------------------------
;  --- Quando non ho più azioni da eseguire ----
;  ---------------------------------------------
(defrule finished (declare (salience -20))
	(status (step ?s) (currently running))
=> 
	(printout t "Finished." crlf)
	(assert (exec (step ?s) (action solve)))
	(pop-focus)
)
