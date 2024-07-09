app [main] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.12.0/cf_TpThUd4e69C7WzHxCbgsagnDmk3xlb_HmEKXTICw.tar.br",
}

import pf.Task
import pf.File

main =
    bytes = File.readBytes! "files/browser.base64.txt"
    decoded = decode bytes
    File.writeBytes! "files/decoded.png" decoded

decode : List U8 -> List U8
decode = \bytes ->
    # pad missing "="
    list = bytes |> padMissingChars

    # calc final padding chars
    paddingLen = calculatePadding list

    chunks = list |> List.chunksOf 4
    decodedList =
        chunks
        |> List.walk [] \state, element ->
            when element is
                [a, b, c, d] ->
                    b1 = (0u32 |> Num.shiftLeftBy 6) + (decodeChar a)
                    b2 = (b1 |> Num.shiftLeftBy 6) + (decodeChar b)
                    b3 = (b2 |> Num.shiftLeftBy 6) + (decodeChar c)
                    b4 = (b3 |> Num.shiftLeftBy 6) + (decodeChar d)

                    c1 = b4 |> Num.shiftRightBy 16 |> Num.bitwiseAnd 0xff |> Num.toU8
                    c2 = b4 |> Num.shiftRightBy 8 |> Num.bitwiseAnd 0xff |> Num.toU8
                    c3 = b4 |> Num.shiftRightBy 0 |> Num.bitwiseAnd 0xff |> Num.toU8

                    List.concat state [c1, c2, c3]

                _ -> crash "Base64.decode: this error should not be possible"

    decodedList |> List.dropLast paddingLen

#
padMissingChars = \bytes ->
    missing =
        when bytes |> List.len |> Num.rem 4 is
            1 -> 3
            2 -> 2
            3 -> 1
            _ -> 0

    bytes |> List.concat (Str.repeat "=" missing |> Str.toUtf8)

calculatePadding = \bytes ->
    when bytes |> List.takeLast 2 is
        [61, 61] -> 2
        [_, 61] -> 1
        _ -> 0
#

dict =
    Dict.empty {}
    |> Dict.insert 'A' 0
    |> Dict.insert 'B' 1
    |> Dict.insert 'C' 2
    |> Dict.insert 'D' 3
    |> Dict.insert 'E' 4
    |> Dict.insert 'F' 5
    |> Dict.insert 'G' 6
    |> Dict.insert 'H' 7
    |> Dict.insert 'I' 8
    |> Dict.insert 'J' 9
    |> Dict.insert 'K' 10
    |> Dict.insert 'L' 11
    |> Dict.insert 'M' 12
    |> Dict.insert 'N' 13
    |> Dict.insert 'O' 14
    |> Dict.insert 'P' 15
    |> Dict.insert 'Q' 16
    |> Dict.insert 'R' 17
    |> Dict.insert 'S' 18
    |> Dict.insert 'T' 19
    |> Dict.insert 'U' 20
    |> Dict.insert 'V' 21
    |> Dict.insert 'W' 22
    |> Dict.insert 'X' 23
    |> Dict.insert 'Y' 24
    |> Dict.insert 'Z' 25
    |> Dict.insert 'a' 26
    |> Dict.insert 'b' 27
    |> Dict.insert 'c' 28
    |> Dict.insert 'd' 29
    |> Dict.insert 'e' 30
    |> Dict.insert 'f' 31
    |> Dict.insert 'g' 32
    |> Dict.insert 'h' 33
    |> Dict.insert 'i' 34
    |> Dict.insert 'j' 35
    |> Dict.insert 'k' 36
    |> Dict.insert 'l' 37
    |> Dict.insert 'm' 38
    |> Dict.insert 'n' 39
    |> Dict.insert 'o' 40
    |> Dict.insert 'p' 41
    |> Dict.insert 'q' 42
    |> Dict.insert 'r' 43
    |> Dict.insert 's' 44
    |> Dict.insert 't' 45
    |> Dict.insert 'u' 46
    |> Dict.insert 'v' 47
    |> Dict.insert 'w' 48
    |> Dict.insert 'x' 49
    |> Dict.insert 'y' 50
    |> Dict.insert 'z' 51
    |> Dict.insert '0' 52
    |> Dict.insert '1' 53
    |> Dict.insert '2' 54
    |> Dict.insert '3' 55
    |> Dict.insert '4' 56
    |> Dict.insert '5' 57
    |> Dict.insert '6' 58
    |> Dict.insert '7' 59
    |> Dict.insert '8' 60
    |> Dict.insert '9' 61
    |> Dict.insert '+' 62
    |> Dict.insert '/' 63

decodeChar : U8 -> U32
decodeChar = \char ->
    dict |> Dict.get char |> Result.withDefault 0
