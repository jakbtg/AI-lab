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
   (question (name engine-runs) (precursors engine YES) (text "Runs normally?") (answer UNK))
   (question (name rotate) (precursors engine NO) (text "Rotates?") (answer UNK))
   (question (name sluggish) (precursors engine-runs NO) (text "Sluggish?") (answer UNK))
   (question (name misfires) (precursors engine-runs NO) (text "Misfires?") (answer UNK))
   (question (name knocks) (precursors engine-runs NO) (text "Knocks?") (answer UNK))
   (question (name output) (precursors engine-runs NO) (text "Output low?") (answer UNK))
   (question (name points) (precursors output YES) (text "Points state?") (answer UNK))
   (question (name gas) (precursors rotate YES) (text "Has gas?") (answer UNK))
   (question (name battery) (precursors rotate NO) (text "Battery has charge?") (answer UNK))
   (question (name coil) (precursors battery YES) (text "Coil conductivity positive?") (answer UNK))

)

(deffacts suggestions
   (suggestion (fault sluggish) (answer YES) (text "Clean the fuel Line"))
   (suggestion (fault misfires) (answer YES) (text "Point gap adjustment"))
   (suggestion (fault knocks) (answer YES) (text "Timing adjustment"))
   (suggestion (fault gas) (answer NO) (text "Add gas"))
   (suggestion (fault battery) (answer NO) (text "Charge the battery"))
   (suggestion (fault points) (answer BURNED) (text "Replace the points"))
   (suggestion (fault points) (answer CONTAMINATED) (text "Clean the points"))
   (suggestion (fault coil) (answer YES) (text "Repair the distributor lead wire"))
   (suggestion (fault coil) (answer NO) (text "Replace the ignition coil"))
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
   (printout t "S: " ?t crlf)
)

; (defrule show-no-suggestion
;    (question (name ?n) (answer ?ans&~UNK))
;    (not (suggestion (fault ?n) (answer ?ans) (text ?t)))
; =>
;    (printout t "S: No suggestion" crlf)
; )
        