(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Ty (Arr (Arr_0 Ty) (Arr_1 Ty)) (A) (B) (C))))
(declare-datatypes () ((Nat (S (p Nat)) (Z))))
(declare-datatypes (a) ((Maybe (Nothing) (Just (Just_0 a)))))
(declare-datatypes ()
  ((Expr (App (App_0 Expr) (App_1 Expr) (App_2 Ty))
     (Lam (Lam_0 Expr)) (Var (Var_0 Nat)))))
(define-funs-rec
  ((par (a) (index ((x (list a)) (y Nat)) (Maybe a))))
  ((match x
     (case nil (as Nothing (Maybe a)))
     (case (cons z xs)
       (match y
         (case (S n) (index xs n))
         (case Z (Just z)))))))
(define-funs-rec
  ((eqType ((x Ty) (y Ty)) Bool))
  ((match x
     (case (Arr a z)
       (match y
         (case default false)
         (case (Arr b y2) (and (eqType a b) (eqType z y2)))))
     (case A
       (match y
         (case default false)
         (case A true)))
     (case B
       (match y
         (case default false)
         (case B true)))
     (case C
       (match y
         (case default false)
         (case C true))))))
(define-funs-rec
  ((tc1 ((x (list Ty)) (y Expr) (z Ty)) Bool))
  ((match y
     (case (App f x2 tx) (and (tc1 x f (Arr tx z)) (tc1 x x2 tx)))
     (case (Lam e)
       (match z
         (case default false)
         (case (Arr tx2 t) (tc1 (cons tx2 x) e t))))
     (case (Var x3)
       (match (index x x3)
         (case Nothing false)
         (case (Just tx3) (eqType tx3 z)))))))
(assert-not
  (forall ((e Expr)) (not (tc1 (as nil (list Ty)) e (Arr A A)))))
(check-sat)
