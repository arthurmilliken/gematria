 select
	max(i.gematria, i.gematria_iota) as gematria,
	w.weight,
	v.ref as verse,
	v.text,
	i.pronounce_sbl,
	i.pronounce_dic,
	i.text_original,
	i.text_plain,
	i.text_slug,
	i.text_english as word,
	i.strongs,
	v.verse_id
from interlinear i
left join verses v on i.verse_id = v.verse_id and v.edition='ASV'
left join weights w on i.word_id = w.word_id
where text_slug = 'VATh-HNORIMf' --or text_slug = 'AChR|' --or text_slug = 'VOL'
order by weight desc, i.word_id
;

select
	e.gematria,
	e.total_weight weight,
	e.text_plain,
	e.text_slug,
	e.strongs,
	s.translit,
	s.pronounce,
	s.strongs_def,
	s.kjv_def,
	s.derivation
from word_entries e
left join strongs s on e.strongs = s.strongs_id
where gematria = 209
order by total_weight desc
;

select * from verses where edition='ASV' and book=1 and chapter=15
