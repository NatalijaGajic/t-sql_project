
if object_id('dbo.jmbg_validation', 'FN') is not null
	drop function dbo.jmbg_validation

go
create function jmbg_validation
(
	@jmbg varchar(13)
)
returns bit
as
begin
	
	declare @dd varchar(2);
	set @dd = left(@jmbg,2);
	declare @dd_int int = try_cast(@dd as int);
	if @dd_int is null
	return 0;
	declare @a int = cast(substring(@jmbg,1,1) as int);
	declare @b int = cast(substring(@jmbg,2,1)as int);
	declare @mm varchar(2) = substring(@jmbg,3,2);
	declare @mm_int int = try_cast(@mm as int);
	if @mm_int is null
	return 0;
	declare @v int = cast(substring(@jmbg,3,1) as int);
	declare @g int = cast(substring(@jmbg,4,1) as int);
	declare @ggg char(2) = substring(@jmbg,5,3);
	declare @ggg_int int = try_cast(@ggg as int);
	if @ggg_int is null 
	return 0;
	declare @d int = cast(substring(@jmbg,5,1) as int);
	declare @dj int = cast(substring(@jmbg,6,1) as int);
	declare @e int = cast(substring(@jmbg,7,1) as int);
	declare @rr char(2) = substring(@jmbg, 8,2);
	declare @rr_int int = try_cast(@rr as int);
	if @rr_int is null
	return 0;
	declare @zh int = cast(substring(@jmbg,8,1) as int);
	declare @z int = cast(substring(@jmbg,9,1) as int);
	declare @i int = try_cast(substring(@jmbg, 10,1) as int);
	declare @j int = try_cast(substring(@jmbg, 11,1) as int);
	declare @k int = try_cast(substring(@jmbg, 12,1) as int);
	if(@i is null or @j is null or @k is null)
	return 0;
	declare @kk int = try_cast(substring(@jmbg, 13,1) as int);
	if @kk is null
	return 0;
	--validacija dana
	if @dd_int < 1 or @dd_int >32
	return 0;
	else 
		--validacija meseca
		begin
		if @mm_int < 1 or @mm_int >12
		return 0;
		else
			begin
				--validacija dana u mesecu
				declare @date_for_month date;
				if ((@ggg_int % 4 = 0 and @ggg_int % 100 != 0) or (@ggg_int % 400 = 0) )
				set @date_for_month = concat(@mm, '-','01','-','2020');
				else
				set @date_for_month = concat(@mm, '-','01','-','2019');
				declare @days_in_month int;
				set @days_in_month = datepart(day, eomonth(@date_for_month));
				if @dd_int > @days_in_month
				return 0;
				else 
					begin
					--RR validacija
					if (@rr_int = 20 or @rr_int = 40 or @rr_int = 90 or @rr_int < 1 or @rr_int > 96)
					return 0;
					if (@rr_int>59 and @rr_int<70)
					return 0;
					else
						begin
						--validacija cifre K
						declare @real_kk int;
						set @real_kk = 11 - (( 7*(@a+@e) + 6*(@b+@zh) + 5*(@v+@z) + 4*(@g+@i) + 3*(@d+@j) + 2*(@dj+@k) ) % 11);
						if(@real_kk > 9)
						set @real_kk = 0;
						if (@real_kk = @kk)
						return 1;
						else
						return 0;
					end
				end
			end
		end
return 0;
end
go

--ispravan unos
select iif(dbo.jmbg_validation('0708998735052')=1, concat('valid ','0708998735052'), concat('invalid ','0708998735052')) as 'Ispravan unos',
--validacija meseca
iif(dbo.jmbg_validation('1301998735052')=1, concat('valid ','1301998735052'), concat('invalid ','1301998735052')) as 'Neispravan mesec',
--validacija dana u mesecu 
iif(dbo.jmbg_validation('0631998735052')=1, concat('valid ','0631998735052'), concat('invalid ','0631998735052')) as 'Neispravan dan u mesecu',
--validacija godine
iif(dbo.jmbg_validation('07089g8695052')=1, concat('valid ','07089g8695052'), concat('invalid ','07089g8695052')) as 'Neispravna godina',
--validacija RR cifre
iif(dbo.jmbg_validation('0708998695052')=1, concat('valid ','0708998695052'), concat('invalid ','0708998695052')) as 'Neispravne RR cifre',
--validacija k cifre
iif(dbo.jmbg_validation('0708998735053')=1, concat('valid ','0708998735053'), concat('invalid ','0708998735053')) as 'Neispravan kontrolan broj'


if object_id('dbo.vrednost_zahteva', 'FN') is not null
	drop function dbo.vrednost_zahteva
go
create function vrednost_zahteva 
(
	@zahtev_id int
)
returns smallmoney
as
begin
	declare @cena smallmoney = 0;
	declare @return_cena smallmoney = 0;
	declare kursor cursor fast_forward for
			select usluga_cena
			from Production.Zahteva z left join Production.Usluga u on (z.usluga_id = u.usluga_id)
			where zahtev_id=@zahtev_id and termin_zak is not null;
	open kursor;
	fetch next from kursor into @cena;
	while @@FETCH_STATUS = 0
		begin
		set @return_cena = @return_cena + @cena;
		fetch next from kursor into @cena;
		end
	close kursor;
	deallocate kursor;

	declare kursor_materijal cursor fast_forward for
			select mat_jedinicna_cena
			from Production.Se_koristi sk left join Production.Materijal m on (sk.mat_id = m.mat_id)
			where zahtev_id=@zahtev_id;
	open kursor_materijal;
	fetch next from kursor_materijal into @cena;
	while @@FETCH_STATUS = 0
		begin
		set @return_cena = @return_cena + @cena;
		fetch next from kursor_materijal into @cena;
		end
	close kursor_materijal;
	deallocate kursor_materijal;

return @return_cena;
end
go



select dbo.vrednost_zahteva(3) as 'Ukupna cena zahteva';
select dbo.vrednost_zahteva(9) as 'Ukupna cena zahteva';
--ispis za proveru:
select z.zahtev_id 'ID zahteva', naziv_usluge 'Usluga', z.usluga_id 'ID usluge', usluga_cena 'Cena usluge', 
iif(mat_jedinicna_cena is null, 0, mat_jedinicna_cena) 'Potrošen materijal', 
iif(naz_mat is null, 'Nije utrošen materijal', naz_mat) 'Materijal', valuta 'Valuta'
from Production.Zahteva z 
left join Production.Usluga u on z.usluga_id = u.usluga_id
left join Production.Se_koristi sk on (sk.zahtev_id = z.zahtev_id and sk.usluga_id = z.usluga_id) 
left join Production.Materijal m on (m.mat_id = sk.mat_id)
where z.zahtev_id = 3;
select z.zahtev_id 'ID zahteva', naziv_usluge 'Usluga', z.usluga_id 'ID usluge', usluga_cena 'Cena usluge', 
iif(mat_jedinicna_cena is null, 0, mat_jedinicna_cena) 'Potrošen materijal', 
iif(naz_mat is null, 'Nije utrošen materijal', naz_mat) 'Materijal', valuta 'Valuta'
from Production.Zahteva z 
left join Production.Usluga u on z.usluga_id = u.usluga_id
left join Production.Se_koristi sk on (sk.zahtev_id = z.zahtev_id and sk.usluga_id = z.usluga_id) 
left join Production.Materijal m on (m.mat_id = sk.mat_id)
where z.zahtev_id = 9;
/*select z.zahtev_id, z.usluga_id, naziv_usluge, naz_mat
from Production.Zahteva z 
left join Production.Usluga u on z.usluga_id = u.usluga_id
left join Production.Se_koristi sk on (sk.zahtev_id = z.zahtev_id and sk.usluga_id = z.usluga_id) 
left join Production.Materijal m on (m.mat_id = sk.mat_id);*/


