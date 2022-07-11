# tplink

Nim library for [tp-link smart devices](https://www.tp-link.com),
based on the work from https://www.softscheck.com/en/reverse-engineering-tp-link-hs110

Currently only tested with the HS200 smart light switch,
although it seems multiple devices share the same protocol.

## Usage

```nim
import tplink, std/json

const deviceIP = "192.168.50.95"

let response = waitFor querySysInfo(deviceIP)
echo pretty parseJson(response)
```

