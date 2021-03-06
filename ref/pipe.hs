{-# OPTIONS_GHC -Wall #-}

-- import Control.Applicative ((<**>))
(|>) :: a -> (a -> b) -> b
x |> f = f x

(|.) :: (a -> b) -> (b -> c) -> a -> c
f |. g = g . f -- alternatively: \x -> g (f x)

main :: IO ()
main = do
    let x = 10 :: Int
    let xx = x - 1
    let f = (+ x)
    let g = (xx :) . iterate f
    let h = x * x
    mapM_
        (print . ($ x))
        [ \x' -> x' |> f |> g |> take h |> sum -- |
        , f |. g |. take h |. sum --           -- | equivalent expressions
        , sum . take h . g . f --              -- |
        ]
