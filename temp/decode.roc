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
    paddingCount = 4 - (bytes |> List.len |> Num.rem 4)
    padding = if paddingCount == 4 then [] else Str.repeat "=" paddingCount |> Str.toUtf8
    list = bytes |> List.concat padding

    # calc final padding chars
    last3 = list |> List.takeLast 3
    paddingLen =
        when last3 is
            [61, 61, 61] -> 3
            [_, 61, 61] -> 2
            [_, _, 61] -> 1
            _ -> 0

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
