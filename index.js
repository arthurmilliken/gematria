import assert from 'assert';
import fs from 'fs';
import sqlite3 from 'sqlite3';
import { open } from 'sqlite';

import config from './config';

async function main() {
  const db = await open({
    filename: config.dbPath,
    driver: sqlite3.Database
  });
  console.log('db connected.');
}

(async () => {
  await main();
  console.log('done.');
})();
