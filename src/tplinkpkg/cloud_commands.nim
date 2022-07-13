import pkg/tplinkpkg/communication

proc queryCloudInfo*(deviceIP: string): Future[string] {.async.} =
  return await send(deviceIP, """{"cnCloud":{"get_info":{}}}""")

