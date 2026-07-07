---
title: "sync installer version"
date: 2025-07-20
source_file: "3. Personal\DEV\BMAD-METHOD-main\tools\sync-installer-version.js"
source_type: js
tags: [personal]
area: Areas
status: active
confidence: 0.5
imported: 2026-05-14
---

```js
#!/usr/bin/env node

/**
 * Sync installer package.json version with main package.json
 * Used by semantic-release to keep versions in sync
 */

const fs = require('fs');
const path = require('path');

function syncInstallerVersion() {
  // Read main package.json
  const mainPackagePath = path.join(__dirname, '..', 'package.json');
  const mainPackage = JSON.parse(fs.readFileSync(mainPackagePath, 'utf8'));
  
  // Read installer package.json
  const installerPackagePath = path.join(__dirname, 'installer', 'package.json');
  const installerPackage = JSON.parse(fs.readFileSync(installerPackagePath, 'utf8'));
  
  // Update installer version to match main version
  installerPackage.version = mainPackage.version;
  
  // Write back installer package.json
  fs.writeFileSync(installerPackagePath, JSON.stringify(installerPackage, null, 2) + '\n');
  
  console.log(`Synced installer version to ${mainPackage.version}`);
}

// Run if called directly
if (require.main === module) {
  syncInstallerVersion();
}

module.exports = { syncInstallerVersion };
```
