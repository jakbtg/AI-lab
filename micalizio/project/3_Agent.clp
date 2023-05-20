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



(defrule guess-what-is-known (declare (salience 5))
	(status (step ?s) (currently running))
	(k-cell (x ?x) (y ?y) (content ?t & ~water))
	(not (exec (action guess) (x ?x) (y ?y)))
=>
	(printout t "I guess that cell [" ?x ", " ?y "] contains " ?t "." crlf)
	(assert (sure-guess (x ?x) (y ?y)))
	(assert (exec (step ?s) (action guess) (x ?x) (y ?y)))
	(pop-focus)
)

(defrule guess-up-given-middle-piece-on-left-border
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y 0))
	(not (exec (action guess) (x ?x2 &: (eq ?x2 (- ?x 1))) (y 0)))
=>
	(printout t "I guess that cell [" (- ?x 1) ", " 0 "] contains a piece." crlf)
	(assert (exec (step ?s) (action guess) (x (- ?x 1)) (y 0)))
	(pop-focus)
)

(defrule guess-down-given-middle-piece-on-left-border
	(status (step ?s) (currently running))
	(sure-guess (x ?x) (y 0))
	(not (exec (action guess) (x ?x2 &: (eq ?x2 (+ ?x 1))) (y 0)))
=>
	(printout t "I guess that cell [" (+ ?x 1) ", " 0 "] contains a piece." crlf)
	(assert (exec (step ?s) (action guess) (x (+ ?x 1)) (y 0)))
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
