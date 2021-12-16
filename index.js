import sqlite3 from 'sqlite3';
import { open } from 'sqlite';

import { DB_PATH } from './config';

async function main() {
  console.log({ DB_PATH });
  const db = await open({
    filename: DB_PATH,
    driver: sqlite3.Database
  });
  console.log('db connected.');
  const books = {};
  const q = "SELECT * FROM books;";
  const rows = await db.all(q);
  console.log(JSON.stringify({ books: rows }, null, 2));
}

(async () => {
  await main();
  console.log('done.');
})();
