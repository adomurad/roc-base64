module [
    decodeStr,
    decodeUtf8,
    tryDecodeStr,
    tryDecodeUtf8,
    encodeStr,
    encodeStrToStr,
    encodeUtf8,
    encodeUtf8ToStr,
]

import Error
import Internal.DecodeCore
import Internal.EncodeCore

# Decoding

## Decode a `Str` of **Base64** encoded string.
##
## This function will silently ignore any problems with the **Base64** input.
decodeStr : Str -> List U8
decodeStr = \str ->
    str |> Str.toUtf8 |> decodeUtf8

## Try decode a `Str` of **Base64** encoded string.
##
## In case of any non-Base64 characters - returns `Err [MalformedBase64Input]`
tryDecodeStr : Str -> Result (List U8) Error.Base64DecodingError
tryDecodeStr = \str ->
    bytes = str |> Str.toUtf8
    if bytes |> List.all isBase64Char then
        Ok (decodeUtf8 bytes)
    else
        Err MalformedBase64Input

## Try decode a `List U8` of **Base64** encoded string.
##
## In case of any non-Base64 characters - returns `Err [MalformedBase64Input]`
tryDecodeUtf8 : List U8 -> Result (List U8) Error.Base64DecodingError
tryDecodeUtf8 = \bytes ->
    if bytes |> List.all isBase64Char then
        Ok (decodeUtf8 bytes)
    else
        Err MalformedBase64Input

## Decode a `List U8` of **Base64** encoded string.
##
## This function will silently ignore any problems with the **Base64** input.
decodeUtf8 : List U8 -> List U8
decodeUtf8 = \bytes ->
    bytes |> Internal.DecodeCore.decode decodeChar

expect
    input = "dGVz"
    expected = "tes" |> Str.toUtf8
    actual = decodeStr input
    actual == expected

expect
    input = "bG9uZ2VyVGVzdA"
    expected = "longerTest" |> Str.toUtf8
    actual = decodeStr input
    actual == expected

expect
    input = "dGVzdA=="
    expected = "test" |> Str.toUtf8
    actual = decodeStr input
    actual == expected

expect
    input = "Pz8/"
    expected = "???" |> Str.toUtf8 |> Ok
    actual = tryDecodeStr input
    actual == expected

expect
    input = "Pz8_"
    expected = Err MalformedBase64Input
    actual = tryDecodeStr input
    actual == expected

decodeChar : U8 -> U32
decodeChar = \char ->
    when char is
        'A' -> 0
        'B' -> 1
        'C' -> 2
        'D' -> 3
        'E' -> 4
        'F' -> 5
        'G' -> 6
        'H' -> 7
        'I' -> 8
        'J' -> 9
        'K' -> 10
        'L' -> 11
        'M' -> 12
        'N' -> 13
        'O' -> 14
        'P' -> 15
        'Q' -> 16
        'R' -> 17
        'S' -> 18
        'T' -> 19
        'U' -> 20
        'V' -> 21
        'W' -> 22
        'X' -> 23
        'Y' -> 24
        'Z' -> 25
        'a' -> 26
        'b' -> 27
        'c' -> 28
        'd' -> 29
        'e' -> 30
        'f' -> 31
        'g' -> 32
        'h' -> 33
        'i' -> 34
        'j' -> 35
        'k' -> 36
        'l' -> 37
        'm' -> 38
        'n' -> 39
        'o' -> 40
        'p' -> 41
        'q' -> 42
        'r' -> 43
        's' -> 44
        't' -> 45
        'u' -> 46
        'v' -> 47
        'w' -> 48
        'x' -> 49
        'y' -> 50
        'z' -> 51
        '0' -> 52
        '1' -> 53
        '2' -> 54
        '3' -> 55
        '4' -> 56
        '5' -> 57
        '6' -> 58
        '7' -> 59
        '8' -> 60
        '9' -> 61
        '+' -> 62
        '/' -> 63
        _ -> 0 # ignore

isBase64Char : U8 -> Bool
isBase64Char = \char ->
    (char >= 'A' && char <= 'Z') || (char >= 'a' && char <= 'z') || (char >= '0' && char <= '9') || char == '=' || char == '+' || char == '/'

# Encoding

## Encode a `List U8` to **Base64** encoded string.
encodeUtf8 : List U8 -> List U8
encodeUtf8 = \bytes ->
    bytes |> Internal.EncodeCore.encode encodeChar

## Encode a `Str` to **Base64** encoded string.
encodeStr : Str -> List U8
encodeStr = \str ->
    str |> Str.toUtf8 |> encodeUtf8

## Encode a `Str` to **Base64** encoded string.
encodeStrToStr : Str -> Str
encodeStrToStr = \str ->
    str |> Str.toUtf8 |> encodeUtf8 |> utf8ToStrOrCrash

## Encode a `List U8` to **Base64** encoded string.
encodeUtf8ToStr : List U8 -> Str
encodeUtf8ToStr = \bytes ->
    bytes |> Internal.EncodeCore.encode encodeChar |> utf8ToStrOrCrash

utf8ToStrOrCrash = \utf8 ->
    when utf8 |> Str.fromUtf8 is
        Ok val -> val
        Err _ -> crash "Base64.encode: this error should not be possible"

expect
    input = "tes"
    expected = "dGVz" |> Str.toUtf8
    actual = encodeStr input
    actual == expected

expect
    input = "test"
    expected = "dGVzdA==" |> Str.toUtf8
    actual = encodeStr input
    actual == expected

expect
    input = "???"
    expected = "Pz8/" |> Str.toUtf8
    actual = encodeStr input
    actual == expected

encodeChar : U32 -> U8
encodeChar = \char ->
    when char is
        0 -> 'A'
        1 -> 'B'
        2 -> 'C'
        3 -> 'D'
        4 -> 'E'
        5 -> 'F'
        6 -> 'G'
        7 -> 'H'
        8 -> 'I'
        9 -> 'J'
        10 -> 'K'
        11 -> 'L'
        12 -> 'M'
        13 -> 'N'
        14 -> 'O'
        15 -> 'P'
        16 -> 'Q'
        17 -> 'R'
        18 -> 'S'
        19 -> 'T'
        20 -> 'U'
        21 -> 'V'
        22 -> 'W'
        23 -> 'X'
        24 -> 'Y'
        25 -> 'Z'
        26 -> 'a'
        27 -> 'b'
        28 -> 'c'
        29 -> 'd'
        30 -> 'e'
        31 -> 'f'
        32 -> 'g'
        33 -> 'h'
        34 -> 'i'
        35 -> 'j'
        36 -> 'k'
        37 -> 'l'
        38 -> 'm'
        39 -> 'n'
        40 -> 'o'
        41 -> 'p'
        42 -> 'q'
        43 -> 'r'
        44 -> 's'
        45 -> 't'
        46 -> 'u'
        47 -> 'v'
        48 -> 'w'
        49 -> 'x'
        50 -> 'y'
        51 -> 'z'
        52 -> '0'
        53 -> '1'
        54 -> '2'
        55 -> '3'
        56 -> '4'
        57 -> '5'
        58 -> '6'
        59 -> '7'
        60 -> '8'
        61 -> '9'
        62 -> '+'
        63 -> '/'
        _ -> crash "Base64.encode: this error should not be possible"

