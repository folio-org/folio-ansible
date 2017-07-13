const fs = require('fs');
const childProcess = require('child_process');

const argv0 = process.argv[1];
const indir = 'node_modules/@folio';
const outdir = 'ModuleDescriptors';
let strict = false;
if (process.argv[2] === '--strict') {
  strict = true;
}

console.log('* build-module-descriptors');
if (!fs.existsSync(outdir)) {
  fs.mkdirSync(outdir);
}

fs.readdir(indir, (err, filenames) => {
  if (err) {
    console.log(`${argv0}: cannot scan '${err.path}': ${err.message}`);
    process.exit(1);
  }

  const sortedFilenames = filenames.sort();
  for (let i = 0; i < sortedFilenames.length; i++) {
    const filename = sortedFilenames[i];
    if (filename.startsWith('stripes-') && filename !== 'stripes-core') continue;
    console.log(`processing '${filename}'`);
    const cmd = `node ${indir}/stripes-core/util/package2md.js${strict ? ' --strict' : ''} ${indir}/${filename}/package.json > ${outdir}/${filename}.json`;
    try {
      const buffer = childProcess.execSync(cmd);
      const output = buffer.toString();
      if (output) console.log(`'${cmd}' produced unexpected output: '${output}'`);
    } catch (exception) {
      console.log(`${argv0}: cannot run '${cmd}':`, exception);
      process.exit(2);
    }
  }
});
