#!/usr/bin/node

// Reads the package.json of a Stripes module, and writes out a
// corresponding ModuleDescriptor.md
// e.g. node package2md.js ../../ui-users/package.json

const fs = require('fs');

const argv1 = process.argv[1].replace(/.*\//, '');

let strict = false;
if (process.argv[2] === '--strict') {
  process.argv.shift();
  strict = true;
}

const filename = process.argv[2];
if (!filename) {
  console.log(`Usage: ${argv1} <package-file>`);
  process.exit(1);
}

fs.readFile(filename, 'utf8', (err, data) => {
  if (err) {
    return console.log(`${argv1}: cannot read file '${filename}': ${err}`);
  }

  const json = JSON.parse(data);
  const interfaces = json.stripes.okapiInterfaces || [];
  const md = {
    id: `${json.name.replace(/^@/, '').replace('/', '_')}-${json.version}`,
    name: json.description,
    permissionSets: json.stripes.permissionSets || [],
  };
  if (strict) md.requires = Object.keys(interfaces).map(key => ({ id: key, version: interfaces[key] }));

  console.log(JSON.stringify(md, undefined, 2));
});
