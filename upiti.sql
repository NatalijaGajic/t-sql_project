/*1.Pregled izvršenih usluga zahteva od strane određenog zaposlenog, u određenom periodu 
određenom početnim i krajnjim datumom perioda u kom se posmatra poslovanje zaposlenog. */

select naziv_usluge 'Usluga', termin_zak 'Zakazan termin', datum_zahtev 'Datum' 
from Production.Zahteva z 
	inner join Production.Radni_dan r on z.rd_id = r.rd_id 
	inner join Production.Usluga u on u.usluga_id = z.usluga_id
where datediff(day, r.datum, '04-27-2020')<0 
	and datediff(day, r.datum, '05-27-2020')>0
	and zap_mbr = '0708992735052';




/*2.Pregled materijala koji je upotrebljen pri izvršavanju određene usluge određenog zahteva uz informaciju 
da li je utrošena količina usklađena sa propisanim normativom korišćenog materijala za pruženu uslugu.*/
select naziv_usluge 'Usluga', naz_mat 'Materijal', mat_jedinicna_cena 'Jedinična cena', 
kol_potr 'Potrošena kolicina', normativ 'Normativ', 
iif(kol_potr < normativ, 
		concat(N'Utrošeno ', cast((normativ-kol_potr) as varchar),' jedinica manje od normativa'), 
		iif(kol_potr > normativ,
			concat('Utrošeno ', cast((kol_potr-normativ) as varchar),
			N' jedinica više od normativa'),
			N'Količina odgovara propisanom normativu')) 'Utrošen materijal'
from Production.Se_koristi sk 
	left join Production.Materijal m on sk.mat_id = m.mat_id
	left join Production.Usluga u on u.usluga_id = sk.usluga_id
	left join Production.Mat_za mz on (sk.mat_id = mz.mat_id and sk.usluga_id = mz.usluga_id) 
where sk.zahtev_id = 9;

/*3.Pregled podataka o broju podnetih i broju izvršenih zahteva za svaku od usluga uz informaciju
o profitu te usluge uređen po rastućoj vrednosti profita.*/
select naziv_usluge Usluga, count(zahtev_id) 'Broj podnetih zahteva', 
count(termin_zak) 'Broj zakazanih zahteva', count(zahtev_id)* usluga_cena 'Profit'
from Production.Zahteva z 
	inner join Production.Usluga u on z.usluga_id = u.usluga_id
group by z.usluga_id, usluga_cena, naziv_usluge
order by count(zahtev_id)* usluga_cena;

/*4.Pregled podataka o ukupnom broju podnetih zahteva u danu u nedelji,
dana u kojima je ukupan broj zahteva veći od prosečnog broja ukupno podnetih zahteva po danima u nedelji*/
select Production.danUNedelji(datepart(dw, datum_zahtev)) 'Dan u nedelji', count(distinct zahtev_id) 'Broj zahteva' 
from Production.Zahteva
group by  datepart(dw, datum_zahtev)
having count(distinct zahtev_id) > (select avg(cast(hp.broj_zahteva as float)) 
									from (select count(distinct zahtev_id) broj_zahteva
											from Production.Zahteva
											group by  datepart(dw, datum_zahtev)) as hp);

IF object_id('Production.danUNedelji', 'FN') is not null
	drop function Production.danUNedelji
go
create function Production.danUNedelji 
(
	@number int
)
returns varchar(10)
as
begin
	declare @dan varchar(10);
	if @number = 1
		set @dan = 'Nedelja';
	else if @number = 2
		set @dan = 'Ponedeljak'
	else if @number = 3
		set @dan = 'Utorak'
	else if @number = 4
		set @dan = 'Sreda'
	else if @number = 5
		set @dan = 'Cetvrtak'
	else if @number = 6
		set @dan = 'Petak'
	else 
		set @dan = 'Subota'
	return @dan;
end
go

/*5.Pregled ukupnog profita pružene usluge od strane zaposlenog za svakog od zaposlenih.
Ukoliko je zaposleni pružao više različitih usluga, prikaz usluge čiji je profit najveći kod zaposlenog.*/
select zap_ime+' '+zap_prz 'Zaposleni', naziv_usluge 'Usluga', count(termin_zak)*usluga_cena 'Vrednost usluge'
from Production.Zahteva z 
	inner join Production.Usluga u on z.usluga_id = u.usluga_id
	left join Production.Zaposleni zap on zap.zap_mbr = z.zap_mbr
	left join(select zz.zap_mbr, max(count_usluga.vrednost_usluge) max_vrednost 
				from Production.Zahteva zz
					inner join (select zap_mbr, z.usluga_id, count(distinct zahtev_id)*usluga_cena vrednost_usluge
								from Production.Zahteva z 
									inner join Production.Usluga u on z.usluga_id = u.usluga_id
								group by zap_mbr, z.usluga_id, usluga_cena) count_usluga on count_usluga.zap_mbr = zz.zap_mbr
				group by zz.zap_mbr) max_usluga on max_usluga.zap_mbr = z.zap_mbr
group by zap_ime, zap_prz, z.usluga_id, naziv_usluge, usluga_cena, max_usluga.max_vrednost
having count(distinct zahtev_id) * usluga_cena = max_usluga.max_vrednost;

