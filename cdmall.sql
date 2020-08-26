-- 가수 생성
insert into artist values(null, '아이유');


-- 장르 생성
insert into genre values(null, 'common', 'cm');


-- 배급사 생성
insert into company values(null, '로엔', null);


-- 앨범 생성
insert into album values(null, '2집 Last Fantasy', 1);


-- 노래 생성
insert into song values(null, '비밀', null, 1, 1);


-- 노래 장르
insert into song_genre values(1, 1);



select sg.title, ar.name, al.title, cp.name, gr.name, gr.abbr_name
from song as sg, artist as ar, album as al, company as cp, song_genre as sggr, genre as gr
where sg.artist_no=ar.no
	and sg.album_no=al.no
    and al.company_no=cp.no
    and sg.no=sggr.song_no
    and gr.no=sggr.genre_no;