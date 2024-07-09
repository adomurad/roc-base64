module [
    encode,
]

encode : List U8, (U32 -> U8) -> List U8
encode = \bytes, encodeChar ->
    chunks = bytes |> List.chunksOf 3

    chunks
    |> List.walk [] \state, chunk ->
        when chunk is
            [a, b, c] ->
                b1 = a |> Num.toU32
                b2 = b |> Num.toU32
                b3 = c |> Num.toU32

                # create a 24-bit number from the next 3 bytes
                bits = (b1 |> Num.shiftLeftBy 16) |> Num.bitwiseOr (b2 |> Num.shiftLeftBy 8) |> Num.bitwiseOr b3

                # extract four 6-bit groups
                c1 = bits |> Num.shiftRightBy 18 |> Num.bitwiseAnd 0x3f |> encodeChar
                c2 = bits |> Num.shiftRightBy 12 |> Num.bitwiseAnd 0x3f |> encodeChar
                c3 = bits |> Num.shiftRightBy 6 |> Num.bitwiseAnd 0x3f |> encodeChar
                c4 = bits |> Num.bitwiseAnd 0x3f |> encodeChar

                state |> List.concat [c1, c2, c3, c4]

            [a, b] ->
                b1 = a |> Num.toU32
                b2 = b |> Num.toU32
                b3 = 0u32

                # create a 24-bit number from the next 3 bytes
                bits = (b1 |> Num.shiftLeftBy 16) |> Num.bitwiseOr (b2 |> Num.shiftLeftBy 8) |> Num.bitwiseOr b3

                # extract four 6-bit groups
                c1 = bits |> Num.shiftRightBy 18 |> Num.bitwiseAnd 0x3f |> encodeChar
                c2 = bits |> Num.shiftRightBy 12 |> Num.bitwiseAnd 0x3f |> encodeChar
                c3 = bits |> Num.shiftRightBy 6 |> Num.bitwiseAnd 0x3f |> encodeChar
                c4 = '='

                state |> List.concat [c1, c2, c3, c4]

            [a] ->
                b1 = a |> Num.toU32
                b2 = 0u32
                b3 = 0u32

                # create a 24-bit number from the next 3 bytes
                bits = (b1 |> Num.shiftLeftBy 16) |> Num.bitwiseOr (b2 |> Num.shiftLeftBy 8) |> Num.bitwiseOr b3

                # extract four 6-bit groups
                c1 = bits |> Num.shiftRightBy 18 |> Num.bitwiseAnd 0x3f |> encodeChar
                c2 = bits |> Num.shiftRightBy 12 |> Num.bitwiseAnd 0x3f |> encodeChar
                c3 = '='
                c4 = '='

                state |> List.concat [c1, c2, c3, c4]

            _ -> crash "Base64.encode: this error should not be possible"

