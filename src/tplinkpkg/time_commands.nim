import pkg/tplinkpkg/communication

proc getDeviceTime*(deviceIP: string): Future[string] {.async.} =
  return await send(deviceIP, """{"time":{"get_time":{}}}""")

