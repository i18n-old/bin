#!/usr/bin/env coffee

> @3-/yml/Yml.js
  @3-/req/req.js
  @3-/write
  path > join


url = 'github.com/i18n-site/bin/releases/download/_/v'

r = await req 'https://'+url
console.log r.headers
console.log await r.text()

# ROOT = import.meta.dirname
#
# {down} = Yml join ROOT, 'sh'
#
# # down = (url)=>
# #   url = 'https://'+url
# #   console.log url
# #   r = await req url+'/-/v'
# #   console.log r
# #   console.log await r.text()
# #   return
#
#
# h2_li = []
# h3_li = []
#
#
# for url from down
#   console.log url
#   # await down url
#
# rust = """
# pub const H2: [&'static str; #{h2_li.length}] = #{JSON.stringify(h2_li)} ;
# pub const H3: [&'static str; #{h3_li.length}] = #{JSON.stringify(h3_li)} ;
# """
#
# console.log rust
#
# write(
#   join ROOT,'src/mirror.rs'
# )
