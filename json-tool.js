const FILE_NAME=process.argv[2];
//console.log("Reformat JSON " + FILE_NAME);
const fs = require('fs');

const parsed = JSON.parse(fs.readFileSync(FILE_NAME).toString());
fs.writeFileSync(FILE_NAME, JSON.stringify(parsed, null, 2));