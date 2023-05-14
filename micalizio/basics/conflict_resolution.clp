(defrule regola-1
    (fatto-a)
=>
    (printout t "fire regola-1" crlf)
)

(defrule regola-2
    (fatto-a)
=>
    (printout t "fire regola-2" crlf)
)

(defrule regola-3
    (fatto-b)
=>
    (printout t "fire regola-3" crlf)
)

(defrule regola-4
    (fatto-b)
=>
    (printout t "fire regola-4" crlf)
)
