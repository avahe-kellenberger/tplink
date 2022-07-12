import std/[asyncnet, asyncdispatch, strutils, tables]

import json

export asyncdispatch

const
  initVector: byte = 171
  defaultPort: Port = Port 9999

  commands* = {
    "antitheft": """{"anti_theft":{"get_rules":{}}}""",
    "cloudinfo": """{"cnCloud":{"get_info":{}}}""",
    "countdown": """{"count_down":{"get_rules":{}}}""",
    "energy": """{"emeter":{"get_realtime":{}}}""",
    "info": """{"system":{"get_sysinfo":{}}}""",
    "ledoff": """{"system":{"set_led_off":{"off":1}}}""",
    "ledon": """{"system":{"set_led_off":{"off":0}}}""",
    "off": """{"system":{"set_relay_state":{"state":0}}}""",
    "on": """{"system":{"set_relay_state":{"state":1}}}""",
    "reboot": """{"system":{"reboot":{"delay":1}}}""",
    "reset": """{"system":{"reset":{"delay":1}}}""",
    "schedule": """{"schedule":{"get_rules":{}}}""",
    "time": """{"time":{"get_time":{}}}""",
    "wlanscan": """{"netif":{"get_scaninfo":{"refresh":0}}}""",
    "scanaps": """{"netif":{"get_scaninfo":{"refresh":1}}}"""
  }.toTable()

proc xorPayload(payload: string): seq[byte] =
  var key = initVector
  for c in payload:
    key = key xor byte(ord(c))
    result.add(key)

proc encrypt(request: string): seq[byte] =
  result.add([byte 0, 0, 0])
  result.add(byte len(request))
  result.add(xorPayload(request))

proc decrypt(response: openArray[byte]): string =
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
  var socket = newAsyncSocket(buffered = false)
  await socket.connect(deviceIP, defaultPort)

  let payload = encrypt(json)
  await socket.send(payload[0].addr, len(payload))

  let response = await socket.recv(2048)
  socket.close()

  return decrypt(cast[seq[byte]](response))

# Commands

proc runCommand*(deviceIP: string, command: static string): Future[string] {.async.} =
  ## Runs a given command.
  ## @param {deviceIP} - The IP address of the tp-link smart device.
  ## @param {command} - A key from the `commands` table.
  static:
    assert commands.hasKey(command)

  return await send(deviceIP, commands[command])

proc querySysInfo*(deviceIP: string): Future[string] {.async.} =
  return await runCommand(deviceIP, "info")

proc queryTime*(deviceIP: string): Future[string] {.async.} =
  return await runCommand(deviceIP, "time")

proc queryScheduleInfo*(deviceIP: string): Future[string] {.async.} =
  return await runCommand(deviceIP, "schedule")

proc queryCloudInfo*(deviceIP: string): Future[string] {.async.} =
  return await runCommand(deviceIP, "cloudinfo")

proc queryAntiTheftInfo*(deviceIP: string): Future[string] {.async.} =
  return await runCommand(deviceIP, "antitheft")

proc queryEnegryInfo*(deviceIP: string): Future[string] {.async.} =
  return await runCommand(deviceIP, "energy")

proc turnOn*(deviceIP: string): Future[string] {.async.} =
  return await runCommand(deviceIP, "on")

proc turnOff*(deviceIP: string): Future[string] {.async.} =
  return await runCommand(deviceIP, "off")

proc turnOnLED*(deviceIP: string): Future[string] {.async.} =
  return await runCommand(deviceIP, "ledon")

proc turnOffLED*(deviceIP: string): Future[string] {.async.} =
  return await runCommand(deviceIP, "ledoff")

proc reboot*(deviceIP: string): Future[string] {.async.} =
  return await runCommand(deviceIP, "reboot")

proc reset*(deviceIP: string): Future[string] {.async.} =
  return await runCommand(deviceIP, "reset")

proc scanAvailableAPs*(deviceIP: string): Future[string] {.async.} =
  return await runCommand(deviceIP, "scanaps")


