CREATE TABLE groupings (
	id INTEGER NOT NULL PRIMARY KEY,
	name TEXT                     -- ex: 'Torah'
);
CREATE TABLE editions (
	id TEXT NOT NULL PRIMARY KEY, -- ex: 'KJV'
	title TEXT,                   -- ex: 'King James Version'
	description TEXT,
	publisher TEXT,
	language TEXT,                -- ex: 'en'
	rights TEXT,                  -- ex: 'Public Domain'
	date TEXT
);
CREATE TABLE verses (
	edition TEXT,                 -- ex: 'KJV'
	verse_id INTEGER,
	ref TEXT,                     -- ex: '1 Chronicles 10:2'
	osis_id TEXT,                 -- ex: '1Chr.10.2'
	language TEXT,
	book INTEGER,
	chapter INTEGER,
	verse INTEGER,
	text TEXT,
	PRIMARY KEY (edition, verse_id)
);
CREATE TABLE strongs (
	strongs_id TEXT NOT NULL PRIMARY KEY,
	word TEXT,
	translit TEXT,
	pronounce TEXT,
	derivation TEXT,
	strongs_def TEXT,
	kjv_def TEXT,
	language TEXT
);
CREATE TABLE interlinear (
	word_id INTEGER NOT NULL PRIMARY KEY, -- 1001001001 for bereshith
	                                      -- (add 500 for compound words)
	verse_id INTEGER,                     -- 1002003 for Genesis 2:3
	word_ordinal INTEGER,                 -- last ordinal for compound words
	book INTEGER,
	chapter INTEGER,
	verse INTEGER,
	text_original TEXT,                   -- ex: בְּרֵאשִׁ֖ית
	text_plain TEXT,                      -- ex: בראשית
	text_english TEXT,                    -- ex: in the beginning
	text_slug TEXT,                       -- ex: BRAShITh
	pronounce_sbl TEXT,
	pronounce_dic TEXT,
	pronounce_dic_mod TEXT,
	pronounce_ipa TEXT,
	pronounce_ipa_mod TEXT,
	parashah INTEGER DEFAULT 0,
	parashah_head INTEGER DEFAULT 0,
	connected INTEGER DEFAULT 0,
	verticalbar INTEGER DEFAULT 0,
	eth INTEGER DEFAULT 0,
	ho INTEGER DEFAULT 0,
	is_first INTEGER DEFAULT 0,
	is_last INTEGER DEFAULT 0,
	is_chapter_head INTEGER DEFAULT 0,
	is_chapter_tail INTEGER DEFAULT 0,
	is_book_head INTEGER DEFAULT 0,
	is_book_tail INTEGER DEFAULT 0,
	is_compound INTEGER DEFAULT 0,
	compound_length INTEGER DEFAULT 1,
	language TEXT,
	strongs TEXT,
	morph TEXT,
	gematria INTEGER DEFAULT 0,
	gematria_gadol INTEGER DEFAULT 0,
	gematria_iota INTEGER DEFAULT 0,
	notes TEXT
);
CREATE TABLE weights (
	word_id INTEGER NOT NULL PRIMARY KEY,
	gematria INTEGER DEFAULT 0,
	weight INTEGER DEFAULT 0
);
CREATE TABLE bsb (
	bsort INTEGER NOT NULL PRIMARY KEY,
	heb_sort INTEGER DEFAULT 0,
	greek_sort INTEGER DEFAULT 0,
	verse INTEGER DEFAULT 0,
	strongs TEXT,
	bsb_version TEXT,
	kjv_verse TEXT,
	heading TEXT,
	parsing TEXT,
	bdb_thayers TEXT,
	footnotes TEXT,
	book INTEGER DEFAULT 0,
	chapter INTEGER DEFAULT 0,
	verse_num INTEGER DEFAULT 0,
	verse_id INTEGER DEFAULT 0,
	word_ordinal INTEGER DEFAULT 0,
	word_id INTEGER DEFAULT 0
);
CREATE TABLE books (
	id INTEGER NOT NULL PRIMARY KEY,
	name TEXT,                       -- ex: 'Genesis'
	testament TEXT,                  -- ex: 'nt'
	grouping INT,
	chapters INT,
	osis_book TEXT                   -- ex: 'Gen'
);
CREATE TABLE word_entries (
	text_plain TEXT,                 -- text without diacritics
	strongs TEXT,
	gematria INT,
	text_slug TEXT,                  -- transliteration, ex: 'BRAShITh'
	total_weight,
	PRIMARY KEY (text_plain, strongs, gematria)
);
CREATE INDEX idx_interlinear_word_ordinal
ON interlinear(book, chapter, verse, word_ordinal);
CREATE INDEX idx_interlinear_verse_id_word_ordinal
ON interlinear(verse_id, word_ordinal);
CREATE INDEX idx_interlinear_gematria
ON interlinear(gematria);
CREATE INDEX idx_interlinear_gematria_gadol
ON interlinear(gematria_gadol);
CREATE INDEX idx_interlinear_gematria_iota
ON interlinear(gematria_iota);
CREATE INDEX idx_interlinear_text_slug
ON interlinear(text_slug);
CREATE INDEX idx_interlinear_strongs
ON interlinear(strongs);
CREATE INDEX idx_interlinear_book_verse_id
ON interlinear(book, verse_id);
CREATE INDEX idx_weights_gematria
ON weights(gematria);
CREATE INDEX bsb_heb_sort
ON bsb(heb_sort);
CREATE INDEX bsb_greek_sort
ON bsb(greek_sort);
CREATE INDEX bsb_verse
ON bsb(verse);
CREATE INDEX bsb_book_chapter_verse_num
ON bsb(book,chapter,verse_num,word_ordinal);
CREATE INDEX bsb_verse_id
ON bsb(verse_id, word_ordinal);
CREATE INDEX word_id
ON bsb(word_id);
CREATE INDEX idx_verses_ref
ON verses(ref);
CREATE INDEX bsb_kjv_verse
ON bsb(kjv_verse);
CREATE INDEX idx_books_name
ON books(name);
CREATE INDEX idx_interlinear_text_plain
ON interlinear(text_plain);
CREATE INDEX idx_word_entries_gematria
ON word_entries(gematria);
