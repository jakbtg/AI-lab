;  ---------------------------------------------
;  --- Definizione del modulo e dei template ---
;  ---------------------------------------------
(defmodule AGENT (import MAIN ?ALL) (import ENV ?ALL) (export ?ALL))


;  ---------------------------------------------
;  -------- Templates utili --------------------
;  ---------------------------------------------
; Template per memorizzare le guess fatte con certezza
(deftemplate sure-guess
	(slot x)
	(slot y)
	(slot content (allowed-values water left right middle top bot sub))
)


;  ---------------------------------------------
;  --- Print delle informazioni iniziali -------
;  ---------------------------------------------
(defrule print-what-i-know-since-the-beginning (declare (salience 10))
	(k-cell (x ?x) (y ?y) (content ?t))
=>
	(printout t "I know that cell [" ?x ", " ?y "] contains " ?t "." crlf)
)

(defrule print-rows-since-the-beginning (declare (salience 10))
	(k-per-row (row ?x) (num ?n))
=>
	(printout t "I know that row " ?x " contains " ?n " pieces." crlf)
)

(defrule print-columns-since-the-beginning (declare (salience 10))
	(k-per-col (col ?y) (num ?n))
=>
	(printout t "I know that column " ?y " contains " ?n " pieces." crlf)
)


;  ------------------------------------------------
;  --- Inizialmente fa guess sulle info di base ---
;  ------------------------------------------------
(defrule guess-what-is-known (declare (salience 5))
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
(defrule guess-up-given-middle-piece-on-left-border
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y 0) (content middle))
	(not (exec (action guess) (x ?x2 &: (eq ?x2 (- ?x 1))) (y 0)))
=>
	(printout t "I guess that cell [" (- ?x 1) ", " 0 "] contains a piece." crlf)
	(assert (exec (step ?s) (action guess) (x (- ?x 1)) (y 0)))
	(pop-focus)
)

(defrule guess-down-given-middle-piece-on-left-border
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y 0) (content middle))
	(not (exec (action guess) (x ?x2 &: (eq ?x2 (+ ?x 1))) (y 0)))
=>
	(printout t "I guess that cell [" (+ ?x 1) ", " 0 "] contains a piece." crlf)
	(assert (exec (step ?s) (action guess) (x (+ ?x 1)) (y 0)))
	(pop-focus)
)

(defrule guess-left-given-middle-piece-on-top-border
	(status (step ?s) (currently running))
	(sure-guess (x 0) (y ?y) (content middle))
	(not (exec (action guess) (x 0) (y ?y2 &: (eq ?y2 (- ?y 1)))))
=>
	(printout t "I guess that cell [" 0 ", " (- ?y 1) "] contains a piece." crlf)
	(assert (exec (step ?s) (action guess) (x 0) (y (- ?y 1))))
	(pop-focus)
)

(defrule guess-right-given-middle-piece-on-top-border
	(status (step ?s) (currently running))
	(sure-guess (x 0) (y ?y) (content middle))
	(not (exec (action guess) (x 0) (y ?y2 &: (eq ?y2 (+ ?y 1)))))
=>
	(printout t "I guess that cell [" 0 ", " (+ ?y 1) "] contains a piece." crlf)
	(assert (exec (step ?s) (action guess) (x 0) (y (+ ?y 1))))
	(pop-focus)
)

(defrule guess-up-given-middle-piece-on-right-border
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y 9) (content middle))
	(not (exec (action guess) (x ?x2 &: (eq ?x2 (- ?x 1))) (y 9)))
=>
	(printout t "I guess that cell [" (- ?x 1) ", " 9 "] contains a piece." crlf)
	(assert (exec (step ?s) (action guess) (x (- ?x 1)) (y 9)))
	(pop-focus)
)

(defrule guess-down-given-middle-piece-on-right-border
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y 9) (content middle))
	(not (exec (action guess) (x ?x2 &: (eq ?x2 (+ ?x 1))) (y 9)))
=>
	(printout t "I guess that cell [" (+ ?x 1) ", " 9 "] contains a piece." crlf)
	(assert (exec (step ?s) (action guess) (x (+ ?x 1)) (y 9)))
	(pop-focus)
)

(defrule guess-left-given-middle-piece-on-bottom-border
	(status (step ?s) (currently running))
	(sure-guess (x 9) (y ?y) (content middle))
	(not (exec (action guess) (x 9) (y ?y2 &: (eq ?y2 (- ?y 1)))))
=>
	(printout t "I guess that cell [" 9 ", " (- ?y 1) "] contains a piece." crlf)
	(assert (exec (step ?s) (action guess) (x 9) (y (- ?y 1))))
	(pop-focus)
)

(defrule guess-right-given-middle-piece-on-bottom-border
	(status (step ?s) (currently running))
	(sure-guess (x 9) (y ?y) (content middle))
	(not (exec (action guess) (x 9) (y ?y2 &: (eq ?y2 (+ ?y 1)))))
=>
	(printout t "I guess that cell [" 9 ", " (+ ?y 1) "] contains a piece." crlf)
	(assert (exec (step ?s) (action guess) (x 9) (y (+ ?y 1))))
	(pop-focus)
)


;  --------------------------------------------------------------------
;  --- Dato un pezzo left/right/top/bottom so che la barca ------------
;  --- continua di almeno un altro pezzo nella rispettiva direzione ---
;  --------------------------------------------------------------------
(defrule guess-right-given-left-piece
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y ?y) (content left))
	(not (exec (action guess) (x ?x) (y ?y2 &: (eq ?y2 (+ ?y 1)))))
=>
	(printout t "I guess that cell [" ?x ", " (+ ?y 1) "] contains a piece." crlf)
	(assert (exec (step ?s) (action guess) (x ?x) (y (+ ?y 1))))
	(pop-focus)
)

(defrule guess-left-given-right-piece
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y ?y) (content right))
	(not (exec (action guess) (x ?x) (y ?y2 &: (eq ?y2 (- ?y 1)))))
=>
	(printout t "I guess that cell [" ?x ", " (- ?y 1) "] contains a piece." crlf)
	(assert (exec (step ?s) (action guess) (x ?x) (y (- ?y 1))))
	(pop-focus)
)

(defrule guess-down-given-top-piece
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y ?y) (content top))
	(not (exec (action guess) (x ?x2 &: (eq ?x2 (+ ?x 1))) (y ?y)))
=>
	(printout t "I guess that cell [" (+ ?x 1) ", " ?y "] contains a piece." crlf)
	(assert (exec (step ?s) (action guess) (x (+ ?x 1)) (y ?y)))
	(pop-focus)
)

(defrule guess-up-given-bottom-piece
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y ?y) (content bot))
	(not (exec (action guess) (x ?x2 &: (eq ?x2 (- ?x 1))) (y ?y)))
=>
	(printout t "I guess that cell [" (- ?x 1) ", " ?y "] contains a piece." crlf)
	(assert (exec (step ?s) (action guess) (x (- ?x 1)) (y ?y)))
	(pop-focus)
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
