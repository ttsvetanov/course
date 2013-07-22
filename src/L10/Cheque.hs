{-

Write a function (dollars) that accepts a `String` and returns a `String`.
It will accept a numeric value as input, representing an amount of money, and convert to its transcribed English.

For example, the input "1.11" will result in a return value of "one dollar and eleven cents"

Invalid characters should be ignored, meaning that every input string has an output string.
The empty string produces "zero dollars and zero cents"

There is a `test` function below that lists more examples of input and output. There are also functions and
data structures that may assist you in deriving the result. It is not compulsory that they are used.

-}

module L10.Cheque where

import Data.Char
import Data.List
import Data.Maybe
import Control.Monad
import Control.Monad.Instances

-- The representation of the grouping of each exponent of one thousand. ["thousand", "million", ...]
illion ::
  [String]
illion =
  let preillion ::
        [String -> String]
      preillion =
        [
          const ""
        , const "un"
        , const "do"
        , const "tre"
        , const "quattuor"
        , const "quin"
        , const "sex"
        , const "septen"
        , const "octo"
        , \q -> if "n" `isPrefixOf` q then "novem" else "noven"
        ]
      postillion ::
        [String]
      postillion =
        [
          "vigintillion"
        , "trigintillion"
        , "quadragintillion"
        , "quinquagintillion"
        , "sexagintillion"
        , "septuagintillion"
        , "octogintillion"
        , "nonagintillion"
        , "centillion"
        , "decicentillion"
        , "viginticentillion"
        , "trigintacentillion"
        , "quadragintacentillion"
        , "quinquagintacentillion"
        , "sexagintacentillion"
        , "septuagintacentillion"
        , "octogintacentillion"
        , "nonagintacentillion"
        , "ducentillion"
        , "deciducentillion"
        , "vigintiducentillion"
        , "trigintaducentillion"
        , "quadragintaducentillion"
        , "quinquagintaducentillion"
        , "sexagintaducentillion"
        , "septuagintaducentillion"
        , "octogintaducentillion"
        , "nonagintaducentillion"
        , "trecentillion"
        , "decitrecentillion"
        , "vigintitrecentillion"
        , "trigintatrecentillion"
        , "quadragintatrecentillion"
        , "quinquagintatrecentillion"
        , "sexagintatrecentillion"
        , "septuagintatrecentillion"
        , "octogintatrecentillion"
        , "nonagintatrecentillion"
        , "quadringentillion"
        , "deciquadringentillion"
        , "vigintiquadringentillion"
        , "trigintaquadringentillion"
        , "quadragintaquadringentillion"
        , "quinquagintaquadringentillion"
        , "sexagintaquadringentillion"
        , "septuagintaquadringentillion"
        , "octogintaquadringentillion"
        , "nonagintaquadringentillion"
        , "quingentillion"
        , "deciquingentillion"
        , "vigintiquingentillion"
        , "trigintaquingentillion"
        , "quadragintaquingentillion"
        , "quinquagintaquingentillion"
        , "sexagintaquingentillion"
        , "septuagintaquingentillion"
        , "octogintaquingentillion"
        , "nonagintaquingentillion"
        , "sescentillion"
        , "decisescentillion"
        , "vigintisescentillion"
        , "trigintasescentillion"
        , "quadragintasescentillion"
        , "quinquagintasescentillion"
        , "sexagintasescentillion"
        , "septuagintasescentillion"
        , "octogintasescentillion"
        , "nonagintasescentillion"
        , "septingentillion"
        , "deciseptingentillion"
        , "vigintiseptingentillion"
        , "trigintaseptingentillion"
        , "quadragintaseptingentillion"
        , "quinquagintaseptingentillion"
        , "sexagintaseptingentillion"
        , "septuagintaseptingentillion"
        , "octogintaseptingentillion"
        , "nonagintaseptingentillion"
        , "octingentillion"
        , "decioctingentillion"
        , "vigintioctingentillion"
        , "trigintaoctingentillion"
        , "quadragintaoctingentillion"
        , "quinquagintaoctingentillion"
        , "sexagintaoctingentillion"
        , "septuagintaoctingentillion"
        , "octogintaoctingentillion"
        , "nonagintaoctingentillion"
        , "nongentillion"
        , "decinongentillion"
        , "vigintinongentillion"
        , "trigintanongentillion"
        , "quadragintanongentillion"
        , "quinquagintanongentillion"
        , "sexagintanongentillion"
        , "septuagintanongentillion"
        , "octogintanongentillion"
        , "nonagintanongentillion"
        ]
  in [
       ""
     , "thousand"
     , "million"
     , "billion"
     , "trillion"
     , "quadrillion"
     , "quintillion"
     , "sextillion"
     , "septillion"
     , "octillion"
     , "nonillion"
     , "decillion"
     , "undecillion"
     , "duodecillion"
     , "tredecillion"
     , "quattuordecillion"
     , "quindecillion"
     , "sexdecillion"
     , "septendecillion"
     , "octodecillion"
     , "novemdecillion"
     ] ++ liftM2 ((++) =<<) preillion postillion

-- A data type representing the digits zero to nine.
data Digit =
  Zero
  | One
  | Two
  | Three
  | Four
  | Five
  | Six
  | Seven
  | Eight
  | Nine
  deriving (Show, Eq, Enum, Bounded)

-- A data type representing one, two or three digits, which may be useful for grouping.
data Digit3 =
  D1 Digit
  | D2 Digit Digit
  | D3 Digit Digit Digit
  deriving Eq

-- Possibly convert a character to a digit.
fromChar ::
  Char
  -> Maybe Digit
fromChar '0' =
  Just Zero
fromChar '1' =
  Just One
fromChar '2' =
  Just Two
fromChar '3' =
  Just Three
fromChar '4' =
  Just Four
fromChar '5' =
  Just Five
fromChar '6' =
  Just Six
fromChar '7' =
  Just Seven
fromChar '8' =
  Just Eight
fromChar '9' =
  Just Nine
fromChar _ =
  Nothing

instance Show Digit3 where
  show d =
    let showd x = toLower `fmap` show x
        x .++. y = x ++ if y == Zero then [] else '-' : showd y
    in case d of
        D1 a -> showd a
        D2 Zero b -> showd b
        D2 One b -> case b of
                      Zero -> "ten"
                      One -> "eleven"
                      Two -> "twelve"
                      Three -> "thirteen"
                      Four -> "fourteen"
                      Five -> "fifteen"
                      Six -> "sixteen"
                      Seven -> "seventeen"
                      Eight -> "eighteen"
                      Nine -> "nineteen"
        D2 Two b -> "twenty" .++. b
        D2 Three b -> "thirty" .++. b
        D2 Four b -> "forty" .++. b
        D2 Five b -> "fifty" .++. b
        D2 Six b -> "sixty" .++. b
        D2 Seven b -> "seventy" .++. b
        D2 Eight b -> "eighty" .++. b
        D2 Nine b -> "ninety" .++. b
        D3 Zero Zero Zero -> ""
        D3 Zero b c -> show (D2 b c)
        D3 a Zero Zero -> showd a ++ " hundred"
        D3 a b c -> showd a ++ " hundred and " ++ show (D2 b c)

toDot ::
  String
  -> ([Digit], String)
toDot =
  let toDot' x [] =
        (x, [])
      toDot' x (h:t) =
        let move = case fromChar h of
                     Just n -> toDot' . (:) n
                     Nothing -> if h == '.'
                                  then
                                    (,)
                                  else
                                     toDot'
        in move x t
  in toDot' []

illionate ::
  [Digit]
  -> String
illionate =
  let space "" =
        ""
      space x =
        ' ' : x
      todigits acc _ [] =
        acc
      todigits _ [] _ =
        error "unsupported illion"
      todigits acc (_:is) (Zero:Zero:Zero:t) =
        todigits acc is t
      todigits acc (i:is) (q:r:s:t) =
        todigits ((show (D3 s r q) ++ space i) : acc) is t
      todigits acc (_:is) (Zero:Zero:t) =
        todigits acc is t
      todigits acc (i:_) (r:s:_) =
        (show (D2 s r) ++ space i) : acc
      todigits acc (_:is) (Zero:t) =
        todigits acc is t
      todigits acc (i:_) (s:_) =
        (show (D1 s) ++ space i) : acc
  in unwords . todigits [] illion

-- | Take a numeric value and produce its English output.
--
-- >>> dollars "0"
-- "zero dollars and zero cents"
--
-- >>> dollars "1"
-- "one dollar and zero cents"
--
-- >>> dollars "0.1"
-- "zero dollars and ten cents"
--
-- >>> dollars "1."
-- "one dollar and zero cents"
--
-- >>> dollars "0."
-- "zero dollars and zero cents"
--
-- >>> dollars "0.0"
-- "zero dollars and zero cents"
--
-- >>> dollars ".34"
-- "zero dollars and thirty-four cents"
--
-- >>> dollars "0.3456789"
-- "zero dollars and thirty-four cents"
--
-- >>> dollars "1.0"
-- "one dollar and zero cents"
--
-- >>> dollars "1.01"
-- "one dollar and one cent"
--
-- >>> dollars "a1a"
-- "one dollar and zero cents"
--
-- >>> dollars "a1a.a0.7b"
-- "one dollar and seven cents"
--
-- >>> dollars "100"
-- "one hundred dollars and zero cents"
--
-- >>> dollars "100.0"
-- "one hundred dollars and zero cents"
--
-- >>> dollars "100.00"
-- "one hundred dollars and zero cents"
--
-- >>> dollars "100.00000"
-- "one hundred dollars and zero cents"
--
-- >>> dollars "1000456.13"
-- "one million four hundred and fifty-six dollars and thirteen cents"
--
-- >>> dollars "1001456.13"
-- "one million one thousand four hundred and fifty-six dollars and thirteen cents"
--
-- >>> dollars "16000000456.13"
-- "sixteen billion four hundred and fifty-six dollars and thirteen cents"
--
-- >>> dollars "100.45"
-- "one hundred dollars and forty-five cents"
--
-- >>> dollars "100.07"
-- "one hundred dollars and seven cents"
--
-- >>> dollars "9abc9def9ghi.jkl9mno"
-- "nine hundred and ninety-nine dollars and ninety cents"
--
-- >>> dollars "12345.67"
-- "twelve thousand three hundred and forty-five dollars and sixty-seven cents"
--
-- >>> dollars "456789123456789012345678901234567890123456789012345678901234567890.12"
-- "four hundred and fifty-six vigintillion seven hundred and eighty-nine novemdecillion one hundred and twenty-three octodecillion four hundred and fifty-six septendecillion seven hundred and eighty-nine sexdecillion twelve quindecillion three hundred and forty-five quattuordecillion six hundred and seventy-eight tredecillion nine hundred and one duodecillion two hundred and thirty-four undecillion five hundred and sixty-seven decillion eight hundred and ninety nonillion one hundred and twenty-three octillion four hundred and fifty-six septillion seven hundred and eighty-nine sextillion twelve quintillion three hundred and forty-five quadrillion six hundred and seventy-eight trillion nine hundred and one billion two hundred and thirty-four million five hundred and sixty-seven thousand eight hundred and ninety dollars and twelve cents"
dollars ::
  String
  -> String
dollars x =
  let (d, c) = toDot (dropWhile (`notElem` ('.':['1'..'9'])) x)
      c' =
        case mapMaybe fromChar c of
          [] -> "zero cents"
          [Zero, One] -> "one cent"
          (a:b:_) -> show (D2 a b) ++ " cents"
          (a:_) -> show (D2 a Zero) ++ " cents"
      d' =
        case d of
          [] -> "zero dollars"
          [One] -> "one dollar"
          _ -> illionate d ++ " dollars"
  in d' ++ " and " ++ c'
