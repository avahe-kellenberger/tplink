import pkg/tplinkpkg/communication

proc querySysInfo*(deviceIP: string): Future[string] {.async.} =
  return await send(deviceIP, """{"system":{"get_sysinfo":{}}}""")

proc turnOn*(deviceIP: string): Future[string] {.async.} =
  return await send(deviceIP, """{"system":{"set_relay_state":{"state":1}}}""")

proc turnOff*(deviceIP: string): Future[string] {.async.} =
  return await send(deviceIP, """{"system":{"set_relay_state":{"state":0}}}""")

proc turnOnLED*(deviceIP: string): Future[string] {.async.} =
  return await send(deviceIP, """{"system":{"set_led_off":{"off":1}}}""")

proc turnOffLED*(deviceIP: string): Future[string] {.async.} =
  return await send(deviceIP, """{"system":{"set_led_off":{"off":0}}}""")

proc reboot*(deviceIP: string): Future[string] {.async.} =
  return await send(deviceIP, """{"system":{"reboot":{"delay":1}}}""")

proc reset*(deviceIP: string): Future[string] {.async.} =
  return await send(deviceIP, """{"system":{"reset":{"delay":1}}}""")

