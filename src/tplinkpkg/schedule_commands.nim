import pkg/tplinkpkg/communication

proc queryScheduleRules*(deviceIP: string): Future[string] {.async.} =
  return await send(deviceIP, """{"schedule":{"get_rules":{}}}""")

