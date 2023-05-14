;;; Questa è la versione senza controllo degli stati, che infatti va in loop.

(deftemplate cell 
	(slot name (allowed-values 0 1 2 3 4 5 6 7 8))
	(slot content (allowed-symbols A B empty blocked))
)

(deftemplate neighbors
	(slot name (allowed-values 0 1 2 3 4 5 6 7 8))
	(slot left (allowed-values 0 1 2 3 4 5 6 7 8 NONE))
	(slot right (allowed-values 0 1 2 3 4 5 6 7 8 NONE))
	(slot up (allowed-values 0 1 2 3 4 5 6 7 8 NONE))
	(slot down (allowed-values 0 1 2 3 4 5 6 7 8 NONE))
)

(deftemplate visitato
      (slot id)
      (slot agent (allowed-symbols A B))
      (slot pos (allowed-values 0 1 2 3 4 5 6 7 8))
)


(deffacts layout

   (neighbors (name 2) (left NONE) (right NONE) (up NONE) (down 5))
   (neighbors (name 4) (left NONE) (right 5) (up NONE) (down NONE))
   (neighbors (name 5) (left 4) (right NONE) (up 2) (down 8))
   (neighbors (name 8) (left NONE) (right NONE) (up 5) (down NONE))
)

(deffacts initial_state
  (cell (name 0) (content blocked))
  (cell (name 1) (content blocked))
  (cell (name 2) (content empty))
  (cell (name 3) (content blocked))
  (cell (name 4) (content A))
  (cell (name 5) (content empty))
  (cell (name 6) (content blocked))
  (cell (name 7) (content blocked))
  (cell (name 8) (content B))

  (visitato (id gen0) (agent A) (pos 4))
  (visitato (id gen0) (agent B) (pos 8))

 
)


(defrule check-goal-state (declare (salience 100))
  (cell (name 4) (content B))
  (cell (name 8) (content A))
=>
  (printout t crlf "goal reached!" crlf)
  (halt)
)


(defrule move-left-block
  ?initial <- (cell (name ?current) (content ?agent & ~empty  & ~blocked))
  (neighbors (name ?current) (left ?moveto))
  ?final <- (cell (name ?moveto) (content empty))

  (cell (name ?cOther) (content ?other & ~empty  & ~blocked & ~?agent))
=> 
  (printout t crlf "moving " ?agent " to " ?moveto crlf)
  (modify ?initial (content empty))
  (modify ?final (content ?agent))
  (bind ?new (gensym))
  (assert (visitato (id ?new) (agent ?agent) (pos ?current)))
  (assert (visitato (id ?new) (agent ?other) (pos ?cOther)))
)


(defrule move-right-block
  ?initial <- (cell (name ?current) (content ?agent & ~empty & ~blocked))
  (neighbors (name ?current) (right ?moveto))
  ?final <- (cell (name ?moveto) (content empty))

  (cell (name ?cOther) (content ?other & ~empty  & ~blocked & ~?agent))
=> 
  (printout t crlf "moving " ?agent " to " ?moveto crlf)
  (modify ?initial (content empty))
  (modify ?final (content ?agent))

  (bind ?new (gensym))
  (assert (visitato (id ?new) (agent ?agent) (pos ?current)))
  (assert (visitato (id ?new) (agent ?other) (pos ?cOther)))
)


(defrule move-up-block
  ?initial <- (cell (name ?current) (content ?agent & ~empty & ~blocked))
  (neighbors (name ?current) (up ?moveto))
  ?final <- (cell (name ?moveto) (content empty))

 (cell (name ?cOther) (content ?other & ~empty  & ~blocked & ~?agent))
=> 
  (printout t crlf "moving " ?agent " to " ?moveto crlf)
  (modify ?initial (content empty))
  (modify ?final (content ?agent))

 (bind ?new (gensym))
  (assert (visitato (id ?new) (agent ?agent) (pos ?current)))
  (assert (visitato (id ?new) (agent ?other) (pos ?cOther)))
)


(defrule move-down-block
  ?initial <- (cell (name ?current) (content ?agent & ~empty & ~blocked))
  (neighbors (name ?current) (down ?moveto))
  ?final <- (cell (name ?moveto) (content empty))

 (cell (name ?cOther) (content ?other & ~empty  & ~blocked & ~?agent))
=> 
  (printout t crlf "moving " ?agent " to " ?moveto crlf)
  (modify ?initial (content empty))
  (modify ?final (content ?agent ))

 (bind ?new (gensym))
  (assert (visitato (id ?new) (agent ?agent) (pos ?current)))
  (assert (visitato (id ?new) (agent ?other) (pos ?cOther)))
)