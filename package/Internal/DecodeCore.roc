module [decode]

decode : List U8, (U8 -> U32) -> List U8
decode = \bytes, decodeChar ->
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
