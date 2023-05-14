(deftemplate memory
	(slot size)
	(slot available)
	(multislot usage)
)

(deftemplate application
	(slot name)
	(slot mem-req)
)

(deftemplate allocate
	(slot name)
)

(deftemplate deallocate
	(slot name)
)

(defrule allocation-ok
	?ph <- (phase allocation)
	?f1 <- (allocate (name ?x))
	(application (name ?x) (mem-req ?y))
	?f <- (memory (available ?z&:(> ?z ?y)) (usage $?u) )
=>	
	(bind ?m (- ?z ?y))
	(modify ?f (available ?m) (usage ?x ?u))
	(retract ?f1 )
)


;;; intuitivamente questa regola dovrebbe scattare quando
;;; non ho richieste di allocazione pendenti, ma perché sarebbe un errore
;;; indicare come pattern dell'antecedente (not (allocate (name ?))) ?
;;; Perchè se avessi ancora delle richieste pendenti ma che non possono essere soddisfatte per
;;; mancanza di memoria, non potrei passare alla fase successiva. In un certo senso è come se le 
;;; richieste di deallocazione fossero prioritarie rispetto a quelle di allocazione.
(defrule move-to-accept-request (declare (salience -10))
	?ph <- (phase allocation)
=>
	(retract ?ph)
	(assert (phase accept-request))
)


;;; Questa regola ha un ERRORE: mischia control knowledge e domain knowledge, MAI FARLO!
;;; Non avrei dovuto rimuovere ?f1 e ?ph e nemmeno passare alla fase successiva con la assert.
;;; Questo passaggio deve essere lasciato in mano ad una regola di controllo specifica (quella sotto)
(defrule deallocation-ok
	?ph <- (phase deallocation)
	?f1 <- (deallocate (name ?x))
	(application (name ?x) (mem-req ?y))
	?f <- (memory (available ?z) (usage $?prima ?x $?dopo))
=>
	(bind ?m (+ ?z ?y))
	(modify ?f (available ?m) (usage $?prima $?dopo))
	(retract ?f1 ?ph)
	(assert (phase allocation))
)

(defrule move-to-allocation
	?ph <- (phase deallocation)
	(not (deallocate (name ?)))
=>
	(retract ?ph)
	(assert (phase allocation))
)


;;; In questo modo dipende dalla strategia di risoluzione delle regole: se la regola di deallocazione
;;; viene risolta prima di quella di allocazione, allora non si potrà mai passare alla fase successiva.
(defrule accept-reqs
	(phase accept-request)
=>
	(printout t "Accepting requests ..." crlf)
	(halt)
)

(defrule move-to-deallocation
	?ph <- (phase accept-request)
=>
	(retract ?ph)
	(assert (phase deallocation))
)




(deffacts facts-domain-knowledge
	(memory (size 15) (available 15) (usage))
)

(deffacts initial-state
	(phase accept-request)
	(application (name word) (mem-req 2))
	(application (name word2) (mem-req 7))
	(application (name word3) (mem-req 6))
	(application (name gnumeric) (mem-req 5))
	(application (name gnumeric2) (mem-req 5))
)


