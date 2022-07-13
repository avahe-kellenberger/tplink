import pkg/tplinkpkg/communication

proc scanAPs*(deviceIP: string): Future[string] {.async.} =
  return await send(deviceIP, """{"netif":{"get_scaninfo":{"refresh":1}}}""")

