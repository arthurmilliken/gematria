import assert from 'assert';
import fs from 'fs';
import sqlite3 from 'sqlite3';
import { open } from 'sqlite';

const dbPath = '/mnt/d/data/gematria.db';

const main = async () => {
  const db = await open({
    filename: dbPath,
    driver: sqlite3.cached.Database
  });

  console.log('db test passed.');
};

(async () => {
  await main();
})();
