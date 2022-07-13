import pkg/tplinkpkg/communication

proc queryEnergyUsage*(deviceIP: string): Future[string] {.async.} =
  return await send(deviceIP, """{"emeter":{"get_realtime":{}}}""")

