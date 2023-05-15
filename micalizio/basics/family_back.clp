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


(defrule goal-ancestor-base-1
       (goal ancestor ?x ?y&:(neq ?x ?y))
       (human (name ?x))
       (human (name ?y))
       (parent (x ?x) (y ?y))
=>
       (assert (ancestor (x ?x) (y ?y)))
)

(defrule goal-ancestor-base-2
       (goal ancestor ?x ?y&:(neq ?x ?y))
       (human (name ?x))
       (human (name ?y))
       (parent (x ?x) (y ?z &:(neq ?x ?z) &:(neq ?y ?z)))
       (ancestor (x ?z) (y ?y))
=>
       (assert (ancestor (x ?x) (y ?y)))
)


(defrule goal-ancestor-parent-subgoal 
       (goal ancestor ?x ?y&:(neq ?x ?y))
       (human (name ?x))
       (human (name ?y))
       (not (parent (x ?x) (y ?y)))
=>
       (assert (goal parent ?x ?y))
)

(defrule goal-ancestor-parent-subgoal-2 
       (goal ancestor ?x ?y&:(neq ?x ?y))
       (human (name ?x))
       (human (name ?y))
       (human (name ?z&:(neq ?y ?z)&:(neq ?x ?z) )   )
       (not (ancestor (x ?z) (y ?y)))
       (not (parent (x ?x) (y ?z)))
=>
       (assert (goal parent ?x ?z))
       (assert (goal ancestor ?z ?y))
)

(defrule goal-ancestor-parent-subgoal-3
       (goal ancestor ?x ?y&:(neq ?x ?y))
       (human (name ?x))
       (human (name ?y))
       (human (name ?z&:(neq ?y ?z)&:(neq ?x ?z) ) )
       (ancestor (x ?z) (y ?y))
       (not(ancestor (x ?x) (y ?z)))

=>
       (assert (goal ancestor ?x ?z))
)




(defrule subgoal-parent
     (goal parent ?x ?y)
     (human (name ?x))
     (human (name ?y))
     (hasChild (x ?x) (y ?y))
=>
     (assert (parent (x ?x) (y ?y))
             (ancestor (x ?x) (y ?y))
    )
)
  

(defrule start (declare (salience 100))
   (maingoal ancestor ?x ?y)
=>
   (assert (goal ancestor ?x ?y)))

(defrule success (declare (salience 100))
	(maingoal ancestor ?x ?y)
	(ancestor (x ?x)  (y ?y))
=>
      (printout t "YES! " ?x " is an ancestor of " ?y crlf)
      (halt)
)

(defrule failure (declare (salience -100))
	(maingoal ancestor ?x ?y)
	=>
        (printout t "NO! " ?x " is NOT an ancestor of " ?y crlf)
	(halt) )
		

(deffacts i-facts
	(human (name Luigi) (gender male))
	(human (name Marta) (gender female))
	(human (name Luca) (gender male))
	(human (name Maria) (gender female))
	(human (name Ludovico) (gender male))
	(human (name Mirta) (gender female))
	(human (name Lucrezia) (gender female))
	(human (name Miriam) (gender female))
	(hasChild (x Luigi) (y Marta))
	(hasChild (x Luigi) (y Luca))
	(hasChild (x Marta) (y Maria))
	(hasChild (x Marta) (y Lucrezia))
	(hasChild (x Maria) (y Ludovico))
	(hasChild (x Ludovico) (y Mirta))
	(hasChild (x Ludovico) (y Miriam))
)

(deffacts goal-facts
	(maingoal ancestor Luigi Miriam)
)


	
