# roc-base64

This is a basic implementation of `Base64` encoding and decoding.

`Base64Url` is also available (url safe base64 encoding).

Seems to work fine, but it is not battle tested yet.

## Examples

Basic usage:

```elixir
app [main] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.11.0/SY4WWMhWQ9NvQgvIthcv15AUeA7rAIJHAHgiaSHGhdY.tar.br",
    base64: "https://github.com/adomurad/roc-base64/releases/download/v0.2.0/hdowh25hurV_dACKR6IMJs-Up3hgAiokhYtRRNSn88k.tar.br",
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
