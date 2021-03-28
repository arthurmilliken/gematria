import assert from 'assert';
import fs from 'fs';
import sqlite3 from 'sqlite3';
import { open } from 'sqlite';
import parse from 'csv-parse';

const dbPath = '/mnt/d/data/gematria.db';
const source = '/mnt/d/data/scripture/bibles.txt';

const editions = {
  'King James Bible': 'KJB',
  'American Standard Version': 'ASV',
  'Douay-Rheims Bible': 'DRB',
  'Darby Bible Translation': 'DBT',
  'English Revised Version': 'ERV',
  'Webster Bible Translation': 'WBT',
  'World English Bible': 'WEB',
  "Young's Literal Translation": "YLT",
  'American King James Version': 'AKJV',
  'Weymouth New Testament': 'WNT',
};

function pad(n, width, z) {
  z = z || '0';
  n = n + '';
  return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
}

const main = async () => {
  const db = await open({
    filename: dbPath,
    driver: sqlite3.cached.Database
  });

  // Create books lookup table
  const books = {}
  const q = "SELECT id, name, osis_book FROM books;"
  const rows = await db.all(q);
  for (const i in rows) {
    const row = rows[i];
    books[row.name] = row;
  }

  let recordNum = 14412;
  const parser = parse({
    bom: true,
    columns: true,
    delimiter: '\t',
    from: recordNum,
  })
  .on('error', (err) => {
    console.error(err);
    console.error(`AT recordNum: ${recordNum}`);
    process.exit(1);
  });
 
  const cursor = fs.createReadStream(source, 'utf8').pipe(parser);
  for await (const record of cursor) {
    const ref = record.Verse;
    const delim = ref.lastIndexOf(' ');
    let bookName = ref.substr(0,delim);
    if (bookName == "Psalm") {
      bookName = "Psalms";
    }
    const book = books[bookName];
    assert(book, `${ref} - recordNum: ${recordNum}`);
    const chapterVerse = ref.substr(delim).split(':');
    assert(chapterVerse.length == 2, ref);
    const chapter = parseInt(chapterVerse[0]);
    const verse = parseInt(chapterVerse[1]);
    const verse_id = `${book.id}${pad(chapter, 3)}${pad(verse, 3)}`;
    const osis_id = `${book.osis_book}.${chapter}.${verse}`;

    for (const key in editions) {
      const edition = editions[key];
      assert(edition);
      const text = record[key];
      if (text.trim().length == 0) {
        continue;
      }
      const result = await db.run(`
      INSERT INTO verses (
        edition, 
        verse_id, 
        ref, 
        osis_id, 
        language, 
        book, 
        chapter, 
        verse, 
        text)
      VALUES (
        :edition,
        :verse_id,
        :ref,
        :osis_id,
        'en',
        :book,
        :chapter,
        :verse,
        :text);
      `, {
        ':edition': edition,
        ':verse_id': verse_id,
        ':ref': ref,
        ':osis_id': osis_id,
        ':book': book.id,
        ':chapter': chapter,
        ':verse': verse,
        ':text': text,
      });
      assert(result.changes > 0, `${ref} - ${key}`);
    }
    recordNum++;
    if (recordNum % 1000 == 0) {
      console.log(`recordNum: ${recordNum}`);
    }
  }
};

const populateEditions = async () => {
  const db = await open({
    filename: dbPath,
    driver: sqlite3.cached.Database
  });

  const stmt = await db.prepare(
    "select id, title from editions where id = ?;"
  );
  
  for (const title in editions) {
    const id = editions[title];
    const result = await stmt.get(id);
    console.log(JSON.stringify(result));
  }
  console.log('DONE');
};

(async () => {
  await main();
})();
