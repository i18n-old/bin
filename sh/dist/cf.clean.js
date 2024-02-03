#!/usr/bin/env node

import { CF_ID, CF_HOST } from "./conf/CF.js";
import purgeCache from "@3-/cf/purgeCache.js";
console.log(await purgeCache(CF_ID, CF_HOST, ["i18n.site/bin/_/v"]));
process.exit();
