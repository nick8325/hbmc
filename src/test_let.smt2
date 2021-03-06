
(declare-datatypes () ((AB (A) (B))))
(declare-datatypes () ((CD (C) (D))))

(declare-sort U 0)
(declare-fun f (U) U)
(declare-fun g (U) CD)
(declare-fun h (U) U)

(define-fun-rec
  test_match ((s AB) (t CD) (a U) (b U)) CD
  (match s
    (case A (g a))
    (case B
      (match (g b)
        (case C C)
        (case D D)))))

(check-sat)
