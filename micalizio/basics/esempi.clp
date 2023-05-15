;;; REGOLE DI ESEMPIO PER SLIDE 40 - 42 ;;;


(deftemplate person "commento opzionale"
	(slot name)
	(slot age)
	(slot eye-color)
	(slot hair-color))



(deffacts famiglia-verdi "alcuni membri della famiglia Verdi"
	(person (name "Luigi") (age 46) (eye-color brown) ( hair-color brown))
	(person (name "Maria") (age 40) (eye-color blue) ( hair-color brown))
	(person (name "Marco") (age 25) (eye-color brown) ( hair-color brown))
	(person (name "Lisa") (age 20) (eye-color blue) ( hair-color blonde))
)

(defrule silly-eye-hair-match-2
     (person (name ?name1)
     (eye-color blue|green)
     (hair-color ?hair1 & ~black))
     (person (name ?name2 & ~?name1)
     (eye-color ?eyes2)
     (hair-color ?hair2 & red|?hair1))
=>
     (printout t ?name1 " has " " eyes and "  ?hair1 " hair." crlf)
     (printout t ?name2 " has "?eyes2 " eyes  and " ?hair2 " hair." crlf))

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
    (printout t ?name " ha gli occhi azzurri." crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; ALTRE REGOLE DI ESEMPIO PER PATTERN MATCHING ;;;

(deftemplate studente  (slot matr) (slot nome) (slot cl) (slot univ))


(deffacts listastud 
        (studente (matr 22009) (nome Luisa) (univ UniTo))
        (studente (matr 22012) (nome Elena) (cl FIL) (univ UniTo))
        (studente (matr 22010) (nome Luca) (cl MED) (univ UniTo))
        (studente (matr 22011) (nome Liliana) (cl ECO) (univ UniTo))
        (studente (matr 22000) (nome Giorgio)  (cl INF) (univ UniTo))
        (studente (matr 21000) (nome Anna) (cl BIO) (univ UniTo))
        (studente (matr 22004) (nome Davide) (cl MAT) (univ UniTo))
        (studente (matr 22005) (nome Sara) (cl BIO) (univ UniTo))
        (studente (matr 22003) (nome Marco) (cl ING) (univ PoliTo))
        (studente (matr 22008) (nome Paolo) (cl INF) (univ UniTo))
)
 

(defrule r1
       (studente (cl INF|MAT|FIS|ING) (nome ?x))
         =>  (assert (ERC-code ?x PE)))
 

(defrule r2
        (studente (cl BIO|MED) (nome ?x))
         => (assert (ERC-code ?x LS)))

(defrule r3
        (studente (cl ECO) (nome ?x))
         => (assert (ERC-code ?x SH)))

(defrule r4
       (studente (cl ~ING&~INF&~BIO&~MED&~MAT&~FIS) (nome ?x))
         => (assert (ERC-code ?x SH)))

(defrule r5
       (studente (cl ?y&~ING&~INF&~BIO&~MED&~MAT&~FIS) (nome ?x))
         => (assert (ERC-code ?x SH  laurea ?y)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(deftemplate person "definisco una persona"
	(slot name
		(type STRING)  ;;; oppure INTEGER|FLOAT|SYMBOL
		(default ?NONE) ;;; name mandatorio
	)
	(slot age
		(type INTEGER)
		(range 18 99)
        )
	(slot eyes
		(type SYMBOL)
		(allowed-symbols blue, green, brown, black)
	)
	(slot hair) 
	(multislot friends) 
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;REGOLE DI ESEMPIO PER SLIDE 43 - 47
(deffacts data-facts  
        (data 1.0 blue "red")  
        (data 1 blue)  
        (data 1 blue red)  
        (data 1 blue RED)  
        (data 1 blue red 6.9)
        (pippo)
        (data 2 red))
        
(defrule find-data1
  (data ? blue red $?)
  =>  (assert (r1)))
  
  
(defrule find-data2
  (data ?x blue red $?)
  => (assert (result ?x)))

(defrule find-data-3
  (data ?x ?y ?z)
  =>
  (assert (primo ?x) (secondo ?y) (terzo ?z)))
  
 
 
 (defrule find-data-4
  (data ?x $?y ?z)
  =>
  (printout t "?x = " ?x crlf
              "?y = " ?y crlf
              "?z = " ?z crlf
              "------" crlf))
 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; REGOLE DI ESEMPIO PER SLIDE 48 - 56 ;;;


(deftemplate box (slot id) (multislot cont))

(deffacts init 
        (box (id A) (cont a1 a1 a3))
        (box (id B) (cont b1 b2))
        (box (id C))
        (removable b1)
        (removable b2)
        (loadable-first p1)
        (loadable-first p2)
        (loadable-second s1)
        (loadable-last l1)
        (loadable-last l2)) 

(defrule check_void
        (declare (salience 100))
        (box (id ?id) (cont $?x))
        (test (eq (length$ $?x) 0))
=> (printout t "the box " ?id  " is void " crlf))

(defrule remove
     ?f1<- (removable ?r)
     ?f <-  (box (id B) (cont $?x))
              (test (member$ ?r $?x))
=> (modify ?f (cont (delete-member$ $?x ?r))))


(defrule add-first
(declare (salience 12))
?f2<-    (box (id A) (cont $?x))
?f1 <-   (loadable-first ?ll)
=> (modify ?f2 (cont (insert$ $?x 1 ?ll)))
   (retract ?f1))   

(defrule add-second
(declare (salience 11))
?f2<-    (box (id A) (cont $?x))
?f1 <-   (loadable-second ?ll)
=> (modify ?f2 (cont (insert$ $?x 2 ?ll)))
   (retract ?f1))   

(defrule add-last
(declare (salience 10))
?f2<-    (box (id C) (cont $?x))
?f1 <-   (loadable-last ?ll)
=> (modify ?f2 (cont (insert$ $?x (+ (length $?x) 1) ?ll)))
   (retract ?f1))  



(defrule test-nth
(declare (salience 100))
?f2<-    (box (id ?id) (cont $?x))
         (test (eq (nth$ 2 $?x) a1))
=> (printout t " " ?id " position 2 a1" crlf)
)  



(defrule put
=>
(assert (box (cont (create$ hammer drill saw screw pliers wrench))))
)


(defrule put-2
 (obj ?x)
 (obj ?y&:(neq ?x ?y))
=>
(assert (box (cont (create$ ?x ?y))))
)


(defrule put-3
 (obj ?x)
 (obj ?y&:(neq ?x ?y))
 (not (box (cont $?cont &:(member$ ?x $?cont) ) ) )
=>
(assert (box (cont (create$ ?x ?y))))
)



