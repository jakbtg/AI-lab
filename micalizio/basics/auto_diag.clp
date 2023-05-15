(deftemplate question
   (slot name)
   (multislot precursors) ;; name answer  engine YES
   (slot text (type STRING))
   (slot answer (allowed-symbols YES NO BURNED CONTAMINATED UNK))
)

(deftemplate suggestion
   (slot fault) ;;points 
   (slot answer) ;;burned 
   (slot text (type STRING)) ;; "replace the points"
)


(deffacts questions
   (question (name engine) (precursors) (text "Engine Starts?") (answer UNK))
   (question (name engine-runs) (precursors engine YES) (text "Runs normally") (answer UNK))
   (question (name rotate) (precursors engine NO) (text "Rotates") (answer UNK))
   (question (name sluggish) (precursors engine-runs NO) (text "Sluggish?") (answer UNK))
)

(deffacts suggestions
   (suggestion (fault sluggish) (answer YES) (text "Clean the fuel Line")) 
)  


(defrule ask-question
  ?q <- (question (name ?n) (precursors) (text ?t) (answer UNK))
=> 
  (printout t "Q: " ?t crlf)
  (bind ?ans (read))
  (modify ?q (answer ?ans))
)  

(defrule progress-question
    (question (name ?n) (answer ?ans&~UNK))
  ?q <- (question (name ?n2) (precursors $?prima ?n ?ans $?dopo) (answer UNK))
=>
   (modify ?q (precursors $?prima $?dopo))  
)
    
(defrule show-suggestion
   (question (name ?n) (answer ?ans))
   (suggestion (fault ?n) (answer ?ans) (text ?t))
=>
  (printout t "S: " ?t crlf))
        