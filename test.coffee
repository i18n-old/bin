#!/usr/bin/env coffee

> @3-/yml/Yml.js
  @3-/req/req.js
  path > join

Y = Yml join import.meta.dirname, 'sh'

down = (url)=>
  url = 'https://'+url
  console.log url
  r = await req url+'/-/v'
  console.log r
  console.log await r.text()
  return

for url from Y.down
  await down url
