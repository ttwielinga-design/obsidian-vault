---
title: "package"
date: 2025-07-20
source_file: "3. Personal\DEV\BMAD-METHOD-main\tools\installer\package.json"
source_type: json
tags: [personal]
area: Areas
status: active
confidence: 0.5
imported: 2026-05-14
---

```json
{
  "name": "bmad-method",
  "version": "4.31.0",
  "description": "BMad Method installer - AI-powered Agile development framework",
  "main": "lib/installer.js",
  "bin": {
    "bmad": "./bin/bmad.js",
    "bmad-method": "./bin/bmad.js"
  },
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [
    "bmad",
    "agile",
    "ai",
    "development",
    "framework",
    "installer",
    "agents"
  ],
  "author": "BMad Team",
  "license": "MIT",
  "dependencies": {
    "chalk": "^5.4.1",
    "commander": "^14.0.0",
    "fs-extra": "^11.3.0",
    "inquirer": "^12.6.3",
    "js-yaml": "^4.1.0",
    "ora": "^8.2.0"
  },
  "engines": {
    "node": ">=20.0.0"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/bmad-team/bmad-method.git"
  },
  "bugs": {
    "url": "https://github.com/bmad-team/bmad-method/issues"
  },
  "homepage": "https://github.com/bmad-team/bmad-method#readme"
}

```
