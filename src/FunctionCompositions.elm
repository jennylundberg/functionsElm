module FunctionComposition exposing (main)

import Html exposing (Html)
import Json.Encode as Json


{--
Hur har det gått för er alla? Har ni funderat något på "hemläxan"? Temat är ju "tänka i typer"
Om ni inte redan har flera exempel, här är några funktioner ni kan implementera:

Vi tar typen Result som exempel
type Result err ok
    = Err err
    | Ok ok

Implementera någon av dessa

* onlyOk : Result err ok -> Maybe ok
onlyErr : Result err ok -> Maybe err
swap : Result err ok -> Result ok err
fromMaybe : err -> Maybe ok -> Result err ok
* map : (a -> b) -> Result x a -> Result x b
* mapErr : (a -> b) -> Result a x -> Result b x
* andThen : (a -> Result x b) -> Result x a -> Result x b
extract : Result a a -> a
combine : List (Result err ok) -> Result err (List ok)

typ signaturer är lite som algebra

1. upgiften implementera typernas funktioner använd först cases och sedan istället för cases använd typernas funktioner

2. uppgiften skriv typerna utan implementation för en miniräknare
--}


type Result error value
    = Ok value
    | Err error


withDefault : a -> Result x a -> a
withDefault result =
    case result of
        Ok ->
            a (Ok value)


Result.withDefault 0 (Ok 123)   == 123
Result.withDefault 0 (Err "no") == 0


onlyOk : Result err ok -> (Maybe ok)
onlyOK :
    Result.map
        Just >> Result.withDefault
            Nothing


onlyOk : Result err ok -> Maybe ok
onlyOK result :
    case result of
        Ok ->
            value

        Err ->
            error


onlyErr : Result err ok -> Maybe err
onlyErr result =
    case result of


andThen : (a -> Result x b) -> Result x a -> Result x b
andThen callback result =
    case result of
        Ok value -> callback value

        Err msg -> Err msg


toValidMonth : Int -> Result String Int
toValidMonth month =
    if month >= 1 && month <= 12
        then Ok month
        else Err "months must be between 1 and 12"


toMonth : String -> Result String Int
toMonth rawString =
    toInt rawString
      |> andThen toValidMonth


map : (a -> b) -> Result x a -> Result x b
map f result =
    case result of
        Ok value -> f value

        Err msg -> Err msg


mapErr : (a -> b) -> Result a x -> Result b x
mapErr =


parseInt : String -> Result ParseError Int

type alias ParseError =
    { message : String
    , code : Int
    , position : (Int,Int)
    }

mapError .message (parseInt "123") == Ok 123
mapError .message (parseInt "abc") == Err "char 'a' is not a number"


{-| For printing a list of integers in a more readable format.
-}
stringify : List Int -> String
stringify =
    Json.list Json.int
        >> Json.encode 0


main : Html msg
main =
    let
        {- This is the list of integers we will use in all examples. 0-9 -}
        numbers = List.range 0 9
    in
    Html.div
        [
        ]
        ( List.map
            ( Html.text
                >> List.singleton
                >> Html.div []
            )
            [ "Input:"
            , stringify numbers
            , "Output:"
            , "0: " ++ stringify (example0 numbers)
            , "1: " ++ stringify (example1 numbers)
            , "2: " ++ stringify (example2 numbers)
            , "3: " ++ stringify (example3 numbers)
            , "4: " ++ stringify (example4 numbers)
            , "5: " ++ stringify (example5 numbers)
            , "6: " ++ stringify (example6 numbers)
            ]
        )


{-| Iterate over a list of numbers and do a simple mathematical operation.
In javascript, it would be something like this:
    numbers.map(function(n) {
        return (n + 1) * 2 - 1;
    });
or using arrow functions:
    numbers.map(n => (n + 1) * 2 - 1);
-}
example0 : List Int -> List Int
example0 numbers =
    List.map (\n -> (n + 1) * 2 - 1) numbers


{-| Forward function application with lambdas.
Let's split the calculation into discrete operations.
    numbers.map(n => n + 1)
           .map(n => n * 2)
           .map(n => n - 1);
-}
example1 : List Int -> List Int
example1 numbers =
    numbers
        |> List.map (\n -> n + 1)
        |> List.map (\n -> n * 2)
        |> List.map (\n -> n - 1)
        {- The |> (pipe operator) lets you write code that reads top-down.
            with numbers
                |> Add 1 to each element
                |> Multiply each element by 2
                |> Subtract one from each element
        -}


{-| Forward function composition with lambdas
-}
example2 : List Int -> List Int
example2 =
    List.map (\n -> n + 1)
        >> List.map (\n -> n * 2)
        >> List.map (\n -> n - 1)


{-| Forward function composition with named functions
using partial application (currying)
    numbers.map(addTo.bind(null, 1))
           .map(multiplyBy.bind(null, 2))
           .map(addTo.bind(null, -1));
    numbers.map(n => addTo(1, n))
           .map(n => multiplyBy(2, n))
           .map(n => addTo(-1, n));
-}
example3 : List Int -> List Int
example3 =
    List.map (addTo 1)
        >> List.map (multiplyBy 2)
        >> List.map (addTo -1)


{-| Forward function composition of inner functions
Instead of iterating three times and performing one operation,
we can iterate one time and compose the three oprations.
-}
example4 : List Int -> List Int
example4 =
    List.map
        ( addTo 1
            >> multiplyBy 2
            >> addTo -1
        )
       {- You can also use function application instead of composition:
            (\n ->
                n
                |> addTo 1
                |> multiplyBy 2
                |> addTo -1
            )
      -}


{-| Backwards function composition of inner functions
This resembles the order functions would be composed in imperative languages.
    numbers.map(n => addTo(-1, multiplyBy(2, addTo(1, n))));
-}
example5 : List Int -> List Int
example5 =
    List.map
        ( addTo -1 << multiplyBy 2 << addTo 1 )

        -- (\n -> addTo -1 <| multiplyBy 2 <| addTo 1 n)


{-| Using infix functions.
An infix function (operator) can be converted to a
prefix function (how it normally works) by wrapping it in parenthesis.
-}
example6 : List Int -> List Int
example6 =
    List.map
        ( (+) 1
            >> (*) 2
            >> (+) -1
        )


addTo : Int -> Int -> Int
addTo n1 n2 =
    n1 + n2


multiplyBy : Int -> Int -> Int
multiplyBy n1 n2 =
    n1 * n2