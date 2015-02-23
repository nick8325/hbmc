{-# LANGUAGE DeriveDataTypeable, FlexibleInstances #-}
{-

    Definitions for the properties in Productive Use Of Failure

-}
module Definitions where

import Prelude (Eq,Ord,Show(..),(.),succ,iterate,(!!),fmap,return,Bool(..))
import Tip.DSL

-- Booleans

otherwise = True

True && x = x
_    && _ = False

False || x = x
_     || _ = True

not True = False
not False = True

-- Nats

data Nat = S Nat | Z deriving (Eq,Ord)

instance Show Nat where
    show = show . wosh
      where
        wosh Z = 0
        wosh (S n) = succ (wosh n)


{-
instance Partial Nat where
    unlifted Z     = return Z
    unlifted (S x) = fmap S (lifted x)
-}

(+) :: Nat -> Nat -> Nat
Z + y = y
(S x) + y = S (x + y)

(*) :: Nat -> Nat -> Nat
Z * _ = Z
(S x) * y = y + (x * y)

(===),(/=) :: Nat -> Nat -> Bool
Z   === Z   = True
Z   === _   = False
S _ === Z   = False
S x === S y = x === y

x /= y = not (x === y)

(<) :: Nat -> Nat -> Bool
Z{}   < Z   = False
S{}   < Z   = False
Z   < _   = True
S x < S y = x < y


(<=) :: Nat -> Nat -> Bool
Z   <= _   = True
Z{}   <= Z   = False
S{}   <= Z   = False
S x <= S y = x <= y

one, zero :: Nat
zero = Z
one  = S Z

double :: Nat -> Nat
double Z     = Z
double (S x) = S (S (double x))

even :: Nat -> Bool
even Z         = True
even (S Z)     = False
even (S (S x)) = even x

half :: Nat -> Nat
half Z         = Z
half (S Z)     = Z
half (S (S x)) = S (half x)

mult :: Nat -> Nat -> Nat -> Nat
mult Z     _ acc = acc
mult (S x) y acc = mult x y (y + acc)

fac :: Nat -> Nat
fac Z     = S Z
fac (S x) = S x * fac x

qfac :: Nat -> Nat -> Nat
qfac Z     acc = acc
qfac (S x) acc = qfac x (S x * acc)

exp :: Nat -> Nat -> Nat
exp _ Z     = S Z
exp x (S n) = x * exp x n

qexp :: Nat -> Nat -> Nat -> Nat
qexp x Z     acc = acc
qexp x (S n) acc = qexp x n (x * acc)

-- Lists

length :: [a] -> Nat
length []     = Z
length (_:xs) = S (length xs)

(++) :: [a] -> [a] -> [a]
[]     ++ ys = ys
(x:xs) ++ ys = x : (xs ++ ys)

drop :: Nat -> [a] -> [a]
drop Z     xs     = xs
drop Z{}   []     = []
drop S{}   []     = []
drop (S x) (_:xs) = drop x xs

rev :: [a] -> [a]
rev []     = []
rev (x:xs) = rev xs ++ [x]

qrev :: [a] -> [a] -> [a]
qrev []     acc = acc
qrev (x:xs) acc = qrev xs (x:acc)

revflat :: [[a]] -> [a]
revflat []           = []
revflat (xs:xss)     = revflat xss ++ xs

qrevflat :: [[a]] -> [a] -> [a]
qrevflat []           acc = acc
qrevflat (xs:xss)     acc = qrevflat xss (rev xs ++ acc)

rotate :: Nat -> [a] -> [a]
rotate Z     xs     = xs
rotate Z{}   []     = []
rotate S{}   []     = []
rotate (S n) (x:xs) = rotate n (xs ++ [x])

(====),(=/=) :: [Nat] -> [Nat] -> Bool
[]     ==== []     = True
(x:xs) ==== (y:ys) = (x === y) && (xs ==== ys)
_      ==== _      = False

xs =/= ys = not (xs ==== ys)

elem :: Nat -> [Nat] -> Bool
elem _ []     = False
elem n (x:xs) = n === x || elem n xs

subset :: [Nat] -> [Nat] -> Bool
subset []     ys = True
subset (x:xs) ys = x `elem` ys && subset xs ys

intersect :: [Nat] -> [Nat] -> [Nat]
(x:xs) `intersect` ys | x `elem` ys = x:(xs `intersect` ys)
                      | otherwise = xs `intersect` ys
[] `intersect` ys = []

union :: [Nat] -> [Nat] -> [Nat]
union (x:xs) ys | x `elem` ys = union xs ys
                | otherwise = x:(union xs ys)
union [] ys = ys

isort :: [Nat] -> [Nat]
isort [] = []
isort (x:xs) = insert x (isort xs)

insert :: Nat -> [Nat] -> [Nat]
insert n [] = [n]
insert n (x:xs) =
  case n <= x of
    True -> n : x : xs
    False -> x : (insert n xs)


count :: Nat -> [Nat] -> Nat
count n (x:xs) | n === x = S (count n xs)
               | otherwise = count n xs
count n [] = Z

sorted :: [Nat] -> Bool
sorted (x:y:xs) = x <= y && sorted (y:xs)
sorted _        = True

{-
number = S (S (S (S (S (S (S (S (S (S (S Z))))))))))
prop_inj_sort xs ys = isort xs =:= isort ys ==> (number + number + number) < length xs =:= True ==> xs =:= ys
-}

-- prop_rot_bogus  n xs = xs =:= rotate n (xs :: [Nat])

-- prop_drop_idem   n xs      = drop n (drop n (xs :: [Nat])) =:= drop n xs
-- prop_drop_invol  n xs      = drop n (drop n (xs :: [Nat])) =:= xs

{-
prop_len_bs   xs ys      = length (xs ++ ys) =:= length (xs ::[Nat])
prop_app_inj1 xs ys zs   = xs ++ ys =:= xs ++ zs ==> ys =:= (zs ::[Nat])
prop_app_inj2 xs ys zs   = xs ++ ys =:= zs ++ ys ==> xs =:= (zs ::[Nat])

prop_drop_comm   n m xs    = drop n (drop m (xs :: [Nat])) =:= drop m (drop n xs)
prop_drop_idem   n xs      = drop n (drop n (xs :: [Nat])) =:= drop n xs
prop_drop_invol  n xs      = drop n (drop n (xs :: [Nat])) =:= xs

prop_drop_inj1 n m xs    = drop n xs =:= drop m (xs :: [Nat]) ==> n  =:= m
prop_drop_inj2 n xs ys   = drop n xs =:= drop n (ys :: [Nat]) ==> xs =:= ys

prop_isect_idem xs    = xs `intersect` xs =:= xs

prop_isect_comm xs ys = xs `intersect` ys =:= ys `intersect` xs

prop_union_idem xs    = xs `union` xs =:= xs

prop_union_comm xs ys = xs `union` ys =:= ys `union` xs

prop_subset_refl xs         = xs `subset` xs =:= True

prop_subset_trans xs ys zs  = xs `subset` ys =:= True ==> ys `subset` zs =:= True ==> xs `subset` zs =:= True

prop_subset_trans_not xs ys zs  = xs `subset` ys =:= True ==> ys `subset` zs =:= True ==> xs `subset` zs =:= False

prop_rot        xs   = xs =:= rotate (length xs) (xs :: [Nat])
prop_rot_bogus  n xs = xs =:= rotate n (xs :: [Nat])
prop_rot_inj0'  n m ys xs = n < length xs =:= True ==> m < length ys =:= True ==> xs =:= ys ==> rotate (S Z) xs =/= xs =:= True ==> rotate n (xs :: [Nat]) =:= rotate m ys ==> n =:= m
prop_rot_inj0   n m ys xs = rotate n (xs :: [Nat]) =:= rotate m ys ==> n =:= m
prop_rot_inj1   n   ys xs = rotate n (xs :: [Nat]) =:= rotate n ys ==> xs =:= ys
prop_rot_comm   n m xs    = rotate n (rotate m (xs :: [Nat])) =:= rotate m (rotate n xs)

prop_rot_uhhh   xs ys = length (xs :: [Nat]) =:= length ys ==> rotate (length xs) (xs ++ ys) =:= xs ++ ys ==> (xs,ys) =:= (ys,xs)
prop_rot_uhhhw1 xs ys =                             rotate (length (xs :: [Nat])) (xs ++ ys) =:= xs ++ ys ==> (xs,ys) =:= (ys,xs)
prop_rot_uhhhw2 xs ys = length (xs :: [Nat]) =:= length ys ==>                                                (xs,ys) =:= (ys,xs)
-}
