(deftemplate person "commento opzionale"
    (slot name)
    (slot age)
    (slot eye-color)
    (slot hair-color)
)

(deffacts famiglia-verdi "alcuni membri della famiglia Verdi"
    (person (name "Luigi") (age 46) (eye-color brown) (hair-color brown))
    (person (name "Maria") (age 40) (eye-color blue) (hair-color brown))
    (person (name "Marco") (age 25) (eye-color brown) (hair-color brown))
    (person (name "Lisa") (age 20) (eye-color blue) (hair-color blonde))
)

(defrule birthday-FLV
    (person (name "Luigi") (age 46) (eye-color brown) (hair-color brown))
    (date-today April-13-02)
    =>
    (printout t "Buon compleanno, Luigi!" crlf)
    (assert (there-s-a-party))
)

(defrule birthday-FLV-2
    ?person <- (person (name "Luigi") (age 46) (eye-color brown) (hair-color brown))
    (date-today April-13-02)
    =>
    (printout t "Buon compleanno, Luigi!" crlf)
    (modify ?person (age 47))
)

(defrule find-blue-eyes
    (person (name ?name) (eye-color blue))
    =>
    (printout t ?name " ha gli occhi azzurri" crlf)
)