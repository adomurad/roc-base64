# roc-base64

This is a basic implementation of `Base64` encoding and decoding.

`Base64Url` is also available (url safe base64 encoding).

Seems to work fine, but it is not battle tested yet. (and it is slooooooow...)

## Warning

WARNING: Seems to be extremely slow when running outside of optimized builds!

Decoding a PNG file (254 KB) with non-optimized build:

```
./decode  6.43s user 0.00s system 99% cpu 6.426 total
```

Running the same code with optimized build:

```
./decode  0.02s user 0.00s system 99% cpu 0.022 total
```

The same is for encoding.

## Examples

Basic usage:

```elixir
app [main] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.12.0/cf_TpThUd4e69C7WzHxCbgsagnDmk3xlb_HmEKXTICw.tar.br",
    base64: "https://github.com/adomurad/roc-base64/releases/download/v0.1.0/P5lB0rRS0k8OAwktoE8EKCjpLiC0CRILEuiuaoxVbOo.tar.br",
}

import pf.Task
import pf.Stdout
import base64.Base64

main =
    encoded =
        "roc is awesome <3"
            |> Base64.encodeStr
            |> Str.fromUtf8
            |> Task.fromResult!
    decoded =
        encoded
            |> Base64.decodeStr
            |> Str.fromUtf8
            |> Task.fromResult!
    Stdout.line! "encoded: $(encoded)"
    Stdout.line! "decoded: $(decoded)"
```

Output:

```
encoded: cm9jIGlzIGF3ZXNvbWUgPDM=
decoded: roc is awesome <3
```
