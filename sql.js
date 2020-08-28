// require('dotenv').config();
const Promise = require('bluebird');
const sqlite3 = require('sqlite3').verbose();
const Gun = require('gun');

const mode = 'sql';

const start = Date.now();
const dbPath = 'data/gematria.db';
const db = new sqlite3.Database(dbPath);
Promise.promisifyAll(db);

const gun = Gun({
	axe: false,
	peers: [
		'https://masterpattern.herokuapp.com/gun',
	],
});
// const gun = Gun();

const gdb = gun.get('gun.biblecurious.org');

// const table = gdb.get('books');
// const sql = "select * from books limit ? offset ?";
// const pkey = null;

const table = gdb.get('editions').get('kjv').get('verses');
const sql = "select * from verses where edition = 'kjv' limit ? offset ?";
const pkey = 'verse_id';

const putBatch = (sql, params, pkey) => {
	if (!params) params = [];
	if (!pkey) pkey = 'id';
	return new Promise((resolve, reject) => {
		let rows = 0;
		let acks = 0;
		db.each(
			sql,
			params,
			(err, row) => {
				if (err) throw err;
				const key = row[pkey];
				// console.log(key, row);
				table.get(key).put(row, ack => {
					if (ack.ok) {
						acks++;
						console.log(`ok: (${acks}/${rows}): ${(Date.now() - start)/1000} s`);
						if (rows > 0 && acks >= rows) resolve(acks);
					} else {
						if (ack.err) reject(ack.err);
						reject(ack);
					}
				});
			},
			(err, count) => {
				if (err) return reject(err);
				console.log('----------------------');
				console.log(' db:done:', count);
				if (count === 0) return resolve(0);
				rows = count;
			}
		);
	});
};

//Gun.node.soul(data)

if (mode === 'sql') {
	(async () => {
		const limit = 100;
		let offset = 0;
		let total = 0;
		try {
			count = await putBatch(sql, [limit, offset], pkey);
			while (count > 0) {
				total += count;
				console.log('----------------------');
				console.log(` batch complete. total loaded: ${total}`);
				console.log('----------------------');
				offset += limit;
				count = await putBatch(sql, [limit, offset], pkey);
			}
		} catch (err) {
			console.log(err);
		}
	})();
} else if (mode === 'gun') {
	let count = 0;
	// table.get('66022009').once(console.log);
	table.once().map().once((data, key) => {
		count++;
		console.log('----------------------')
		console.log(count, key, data);
	});
} else {
	console.log(`unknown mode: ${mode}`);
	process.exit();
}



