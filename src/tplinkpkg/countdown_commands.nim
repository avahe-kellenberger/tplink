import pkg/tplinkpkg/communication

proc queryCountdownRules*(deviceIP: string): Future[string] {.async.} =
  return await send(deviceIP, """{"count_down":{"get_rules":{}}}""")

