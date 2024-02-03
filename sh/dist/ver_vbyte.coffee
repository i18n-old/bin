#!/usr/bin/env coffee

> @3-/vb/vbE.js
  @3-/write

{
  env
  argv
} = process

li = env.VER.split('.').map (i)=>+i

write(
  argv[2]
  vbE li
)
