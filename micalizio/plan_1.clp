;;; Qui c'è invece un controllo degli stati visitati, però è una situazione fortunata.
;;; Infatti B può tornare indietro sui suoi passi per poi raggiungere la sua destinazione
;;; finale solamente perché A nel mentre si è spostato e lo stato traccia la posizione di entrambi,
;;; per cui è come se fosse uno stato diverso.
;;; Però in altre situazioni dovremmo poter tornare indietro ad uno stato già visitato (backtracking).
;;; Questo algoritmo quindi non permette backtracking, ma dato che per questo problema non è richiesta
;;; una strategia di ricerca allora funziona anche così.
;;; Ma se ad esempio cambiassi la conflict resolution strategy in breadth, allora andrebbe in loop.


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

  (or 

      (and 
          (visitato (id ?x) (agent ?agent) (pos ?pos & ~?moveto))
          (visitato (id ?x) (agent ?other) (pos ?pOth & ~ ?cOther))
        )
      (and 
           (visitato (id ?x) (agent ?agent) (pos ?moveto))
           (visitato (id ?x) (agent ?other) (pos ?pos & ~?cOther))
      )
      (and 
          (visitato (id ?x) (agent ?other) (pos ?cOther))
          (visitato (id ?x) (agent ?agent) (pos ?pos & ~?moveto))
        )
    
  )


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


  (or 

      (and 
          (visitato (id ?x) (agent ?agent) (pos ?pos & ~?moveto))
          (visitato (id ?x) (agent ?other) (pos ?pOth & ~ ?cOther))
        )
      (and 
           (visitato (id ?x) (agent ?agent) (pos ?moveto))
           (visitato (id ?x) (agent ?other) (pos ?pos & ~?cOther))
      )
      (and 
          (visitato (id ?x) (agent ?other) (pos ?cOther))
          (visitato (id ?x) (agent ?agent) (pos ?pos & ~?moveto))
        )
    
  )


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

  (or 

      (and 
          (visitato (id ?x) (agent ?agent) (pos ?pos & ~?moveto))
          (visitato (id ?x) (agent ?other) (pos ?pOth & ~ ?cOther))
        )
      (and 
           (visitato (id ?x) (agent ?agent) (pos ?moveto))
           (visitato (id ?x) (agent ?other) (pos ?pos & ~?cOther))
      )
      (and 
          (visitato (id ?x) (agent ?other) (pos ?cOther))
          (visitato (id ?x) (agent ?agent) (pos ?pos & ~?moveto))
        )
    
  )
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

  (or 

      (and 
          (visitato (id ?x) (agent ?agent) (pos ?pos & ~?moveto))
          (visitato (id ?x) (agent ?other) (pos ?pOth & ~ ?cOther))
        )
      (and 
           (visitato (id ?x) (agent ?agent) (pos ?moveto))
           (visitato (id ?x) (agent ?other) (pos ?pos & ~?cOther))
      )
      (and 
          (visitato (id ?x) (agent ?other) (pos ?cOther))
          (visitato (id ?x) (agent ?agent) (pos ?pos & ~?moveto))
        )
    
  )
=> 
  (printout t crlf "moving " ?agent " to " ?moveto crlf)
  (modify ?initial (content empty))
  (modify ?final (content ?agent ))

 (bind ?new (gensym))
  (assert (visitato (id ?new) (agent ?agent) (pos ?current)))
  (assert (visitato (id ?new) (agent ?other) (pos ?cOther)))
)