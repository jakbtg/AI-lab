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
)

(defrule print-columns-since-the-beginning (declare (salience 20))
	(k-per-col (col ?y) (num ?n))
=>
	(printout t "I know that column " ?y " contains " ?n " pieces." crlf)
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
	(k-per-row (row ?x) (num 0))
	(k-per-col (col ?y))
	(not (sure-guess (x ?x) (y ?y) (content water)))
=>
	(printout t "Fill cell [" ?x ", " ?y "] with water." crlf)
	(assert (sure-guess (x ?x) (y ?y) (content water)))
)

(defrule fill-water-col-when-no-pieces
	(k-per-row (row ?x))
	(k-per-col (col ?y) (num 0))
	(not (sure-guess (x ?x) (y ?y) (content water)))
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




;  ---------------------------------------------
;  --- Quando non ho più azioni da eseguire ----
;  ---------------------------------------------
(defrule finished (declare (salience -10))
	(status (step ?s) (currently running))
=> 
	(printout t "Finished." crlf)
	(assert (exec (step ?s) (action solve)))
	(pop-focus)
)
