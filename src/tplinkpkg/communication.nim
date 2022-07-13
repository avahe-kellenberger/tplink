import std/[asyncnet, asyncdispatch, strutils]

export asyncdispatch

const
  initVector: byte = 171
  defaultPort: Port = Port 9999

proc xorPayload*(payload: string): seq[byte] =
  var key = initVector
  for c in payload:
    key = key xor byte(ord(c))
    result.add(key)

proc encrypt*(request: string): seq[byte] =
  result.add([byte 0, 0, 0])
  result.add(byte len(request))
  result.add(xorPayload(request))

proc decrypt*(response: openArray[byte]): string =
  # First 4 bytes aren't human readable data
  if response.len <= 4:
    return

  var
    key = initVector
    decryptedBytes: seq[byte]

  for i in 4 ..< response.len:
    let a = key xor response[i]
    key = response[i]
    decryptedBytes.add(a)

  return cast[string](decryptedBytes)

proc send*(deviceIP: string, json: string): Future[string] {.async.} =
  ## Sends a string to the given device, and returns the response.
  let socket = newAsyncSocket(buffered = false)
  await socket.connect(deviceIP, defaultPort)

  let payload = encrypt(json)
  await socket.send(payload[0].addr, len(payload))

  let response = await socket.recv(2048)
  socket.close()

  return decrypt(cast[seq[byte]](response))

