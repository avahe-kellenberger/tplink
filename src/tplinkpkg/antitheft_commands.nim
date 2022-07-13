import pkg/tplinkpkg/communication

proc queryAntitheftRules*(deviceIP: string): Future[string] {.async.} =
  return await send(deviceIP, """{"anti_theft":{"get_rules":{}}}""")

proc deleteAllAntitheftRules*(deviceIP: string): Future[string] {.async.} =
  return await send(deviceIP, """{"anti_theft":{"delete_all_rules":{}}""")

