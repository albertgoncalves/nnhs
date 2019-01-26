{-# OPTIONS_GHC -Wall #-}

(|>) :: a -> (a -> b) -> b
x |> f = f x

main :: IO ()
main = do
    let x = 10 :: Int
    print $ x |> (+ 10) |> (: [1,2 ..]) |> drop 2 |> head
