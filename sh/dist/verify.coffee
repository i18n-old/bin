#!/usr/bin/env coffee

> @3-/yml/Yml.js
  @3-/req/req.js
  @3-/write
  path > join dirname

ROOT = import.meta.dirname

Y = Yml ROOT

down = (url)=>
  url = 'https://'+url
  console.log url
  await req url

li = []

# now = (new Date()-0).toString(36)

for src from Y.down
  url = src + '_/v'
  # if not url.includes('?')
  #   url += '?'+now
  r = await down url
  alt = r.headers.get('alt-svc')
  if alt
    h3 = true
  else
    h3 = false
  console.log await r.arrayBuffer()
  r = JSON.stringify [ h3, src ]
  r = '('+r.slice(1,-1)+')'
  li.push r

rust = """
pub const MIRROR: [(bool,&'static str); #{li.length}] = [
  #{li.join(',\n  ')}
];
"""

write(
  join(
    dirname dirname ROOT
    'src/mirror.rs'
  )
  rust
)
