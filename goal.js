const pgnStrs = require('./results/pgns-raw');
console.log(pgnStrs.length);
const fs = require('fs');

fs.writeFileSync("results/all.pgn", pgnStrs.join("\n\r\n\r"));