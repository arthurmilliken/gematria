select
	max(i.gematria, i.gematria_iota) gematria,
	w.weight,
	i.text_original,
	i.text_plain,
	i.text_slug,
	i.pronounce_sbl,
	i.pronounce_dic,
	i.strongs,
	i.text_english,
	v.ref as verse,
	v.text,
	v.verse_id
from interlinear i
left join verses v on i.verse_id = v.verse_id and v.edition='KJV'
left join weights w on i.word_id = w.word_id
where text_slug = 'ShTITh' --or text_slug = 'ODVTh|' --or text_slug = 'VOL'
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
where gematria = 719
order by total_weight desc
;
