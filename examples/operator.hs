{-# OPTIONS_GHC -Wall #-}

(|>) :: a -> (a -> b) -> b
x |> f = f x

(|.) :: (a -> b) -> (b -> c) -> a -> c
f |. g = g . f -- alternatively: \x -> g (f x)

main :: IO ()
main = do
    let x = 10 :: Int
    let f = (+ x)
    let g = (: [x,x ..])
    let h = take x
    mapM_
        print
        [ x |> f |> g |> h |> sum --   |
        , x |> (f |. g |. h |. sum) -- | equivalent expressions
        , (sum . h . g . f) x --       |
        ]
