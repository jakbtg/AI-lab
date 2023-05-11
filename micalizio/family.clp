(deftemplate human "un essere umano"
	(slot name)
	(slot gender)
)

(deftemplate parent "x e' padre di y"
	(slot x)
	(slot y)
)


(deftemplate ancestor "x e' antenato di y"
	(slot x)
	(slot y)
)

(deftemplate father "x e' padre di y"
	(slot x)
	(slot y)
)

(deftemplate mother "x e' madre di y"
	(slot x)
	(slot y)
)

(deftemplate hasChild "x ha come figlio y"
	(slot x)
	(slot y)
)

(deftemplate sibling "x e' fratello/sorella di y e viceversa"
	(slot s1)
	(slot s2)
)


(defrule rule-ancestor-1 
	(parent (x ?x) (y ?y))
=> 
	(assert (ancestor (x ?x) (y ?y)))
 )

(defrule rule-ancestor-2
	(parent (x ?x) (y ?z))
	(ancestor (x ?z) (y ?y))
=>
	(assert (ancestor (x ?x) (y ?y)))
)

(defrule rule-mother
	(hasChild (x ?x) (y ?y))
	(human (name ?x) (gender female))
=> 
	(assert (mother (x ?x) (y ?y)))
)


(defrule rule-father
	(hasChild (x ?x) (y ?y))
	(human (name ?x) (gender male))
=> 
	(assert (father (x ?x) (y ?y)))
)

(defrule rule-parent-1
	(or (mother (x ?x) (y ?y))
	     (father (x ?x) (y ?y)) )
=>
	(assert (parent (x ?x) (y ?y)))
)


(defrule siblings
	(parent (x ?x) (y ?y))
;;	(parent (x ?x) (y ?z))
;;	(test (neq ?y ?z))
;; o in alternativa al test
	(parent (x ?x) (y ?z&:(neq ?y ?z)))
	(not (sibling (s1 ?z) (s2 ?y)))
=>
	(assert (sibling (s1 ?y) (s2 ?z)))
)



(defrule goal-sibling (declare (salience 10))
	(goal sibling ?x ?y)
	(or (sibling (s1 ?x) (s2 ?y))
	    (sibling (s1 ?y) (s2 ?x)) )
=>
	(printout t crlf ?x " is sibling of " ?y crlf) 
	;;(halt)
)




(defrule goal-not-sibling (declare (salience -15))
	(goal sibling ?x ?y)
	(not (sibling (s1 ?x) (s2 ?y)))
	(not (sibling (s1 ?y) (s2 ?x)))
=>
	(printout t crlf ?x " is NOT sibling of " ?y crlf) )

(defrule stop (declare (salience -100))
	=>
	(halt) )
		

(deffacts i-facts
	(human (name Luigi) (gender male))
	(human (name Marta) (gender female))
	(human (name Luca) (gender male))
	(human (name Maria) (gender female))
	(human (name Ludovico) (gender male))
	(human (name Mirta) (gender female))
	(human (name Lucrezia) (gender female))
	(hasChild (x Luigi) (y Marta))
	(hasChild (x Luigi) (y Luca))
	(hasChild (x Marta) (y Maria))
	(hasChild (x Marta) (y Lucrezia))
	(hasChild (x Maria) (y Ludovico))
	(hasChild (x Ludovico) (y Mirta))
)

(deffacts goal-facts
	(goal sibling Luca Marta)
	(goal sibling Marta Lucrezia)
	(goal sibling Maria Lucrezia)
)


	
