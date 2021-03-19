if object_id('dbo.promeni_cenu', 'P') is not null
	drop procedure dbo.promeni_cenu;
go
create procedure promeni_cenu
(
	@cena_od as smallmoney,
	@cena_do as smallmoney,
	@povecaj as bit,
	@procenat as int
)
as
begin
	set nocount on;
	if @cena_od > @cena_do or @cena_do < 0 or @cena_od < 0
		begin
		raiserror('Interval vrednosti cena nije ispravno zadat.',10,1);
		return;
		end
	else if @procenat < 0 or @procenat > 100
		begin
		raiserror('Procenat mora biti vrednost između 0 i 100.',10,1);
		return;
		end 
	declare @usluga_id int;
	declare @counter int = 0;
	if(@povecaj=1)
	set @procenat = 100 + @procenat;
	else
	set @procenat = 100 - @procenat;
	declare kursor cursor fast_forward for
	select usluga_id
	from Production.Usluga
	where usluga_cena >= @cena_od and usluga_cena <= @cena_do;
	open kursor;
	fetch next from kursor into @usluga_id;
	while @@FETCH_STATUS = 0
		begin
		set @counter = @counter + 1;
		update Production.Usluga
		set usluga_cena = usluga_cena * (cast(@procenat as float) /100)
		where usluga_id = @usluga_id;
		fetch next from kursor into @usluga_id;
		end
	close kursor;
	deallocate kursor;
	return;
end
go

--testiranje procedure:
select naziv_usluge 'Usluga', usluga_cena 'Cena', valuta 'Valuta' from Production.Usluga;

execute dbo.promeni_cenu 1000, 1000, 0, 10;
select naziv_usluge 'Usluga', usluga_cena 'Cena', valuta 'Valuta' from Production.Usluga;
update Production.Usluga
set usluga_cena = 1000
where usluga_id = 4;

execute dbo.promeni_cenu 1000, 1000, 1, 10;
select naziv_usluge 'Usluga', usluga_cena 'Cena', valuta 'Valuta' from Production.Usluga;
update Production.Usluga
set usluga_cena = 1000
where usluga_id = 4;

/*Poziv procedure kojim se za 10% snižava cena usluga čija je cena između 800 i 1000:*/
execute dbo.promeni_cenu 800, 1000, 0, 10;
select naziv_usluge 'Usluga', usluga_cena 'Cena', valuta 'Valuta' from Production.Usluga;
update Production.Usluga
set usluga_cena = 1000
where usluga_id = 4;
update Production.Usluga
set usluga_cena = 900
where usluga_id = 7;
update Production.Usluga
set usluga_cena = 900
where usluga_id = 3;

/*Poziv procedure kojim se za 20% povišava cena usluga čija je cena između 800 i 1000:*/
execute dbo.promeni_cenu 800, 1000, 1, 20;
select naziv_usluge 'Usluga', usluga_cena 'Cena', valuta 'Valuta' from Production.Usluga;
update Production.Usluga
set usluga_cena = 1000
where usluga_id = 4;
update Production.Usluga
set usluga_cena = 900
where usluga_id = 7;
update Production.Usluga
set usluga_cena = 900
where usluga_id = 3;

/*Poziv procedure sa neispravno prosleđenim parametrima*/
execute dbo.promeni_cenu 1000, 800, 1, 20;
execute dbo.promeni_cenu 800, 1000, 1, 120;

if object_id('dbo.dodaj_radnike', 'P') is not null
	drop procedure dbo.dodaj_radnike;
go
create procedure dodaj_radnike
(
	@stari_datum as date,
	@novi_datum as date
)
as
begin
	set nocount on;
	if @novi_datum < @stari_datum
		begin
		raiserror('Nesipravno uneti parametri. Datum za koji treba uneti radnike ne sme biti stariji.',10,1);
		return;
		end
	declare @zap_mbr varchar(13);
	declare @status_id tinyint;
	declare @rd_id int;
	declare @stari_datum_id int = (select rd_id from Production.Radni_dan where datum = @stari_datum);
	if @stari_datum_id is null 
		begin
		declare @msg as nvarchar(1000)= concat('Datum ',cast(@stari_datum as varchar),' ne postoji u radnom kalendaru.');
		raiserror(@msg,10,1);
		return;
		end
	declare @novi_datum_id int = (select rd_id from Production.Radni_dan where datum = @novi_datum);
	if @novi_datum_id is null
	begin
		insert into Production.Radni_dan (datum, radni_dan_s)
		values (@novi_datum, 1);
		set @novi_datum_id =  (select rd_id from Production.Radni_dan where datum = @novi_datum);
	end
	else 
	begin
		declare @broj_torki_u_zahteva int = (select count(distinct zap_mbr) from Production.Zahteva where rd_id = @novi_datum_id);
		if @broj_torki_u_zahteva > 0 
		return;
		declare kursor cursor fast_forward for
		select zap_mbr, rd_id
		from Production.Radi
		where rd_id = @novi_datum_id;
		open kursor;
		fetch next from kursor into @zap_mbr, @rd_id;

		while @@FETCH_STATUS = 0
			begin
			delete from Production.Radi
			where rd_id = @rd_id and zap_mbr = @zap_mbr;
			fetch next from kursor into @zap_mbr, @status_id;
			end
		close kursor;
		deallocate kursor;
	end

	declare kursor cursor fast_forward for
	select zap_mbr, status_id
	from Production.Radi
	where rd_id = @stari_datum_id;
	open kursor;
	fetch next from kursor into @zap_mbr, @status_id;

	while @@FETCH_STATUS = 0
		begin
		insert into Production.Radi (zap_mbr, rd_id, status_id)
		values(@zap_mbr, @novi_datum_id, @status_id);	
		fetch next from kursor into @zap_mbr, @status_id;
		end
	close kursor;
	deallocate kursor;
	
	return;
end
--testiranje procedure:
/*Poziv procedure kojim se radnici i njihovi statusi dana 30.04.2020. prepisuju 
u tabelu Radi za dan 03.05.2020, gde nisu prethodno postojali zapisi za ovaj dan: */
execute dbo.dodaj_radnike '04-30-2020', '05-03-2020';
select datum 'Datum', zap_ime+' '+ zap_prz 'Zaposleni', naziv_stat 'Status'  
from Production.Radi r 
inner join Production.Radni_dan rd on r.rd_id = rd.rd_id
left join Production.Zaposleni z on z.zap_mbr = r.zap_mbr
inner join Production.Status s on s.status_id = r.status_id
where datum = '04-30-2020' or datum = '05-03-2020';

/*Poziv procedure kojim se radnici i njihovi statusi dana 29.04.2020. prepisuju u tabelu Radi za dan 30.04.2020, 
gde su prethodno postojali zapisi za dan 30.04.2020., 
ali zaposleni nisu dodeljeni zahtevima za ovaj dan u tabeli Zahteva*/
select datum 'Datum', zap_ime+' '+ zap_prz 'Zaposleni', naziv_stat 'Status'  
from Production.Radi r 
inner join Production.Radni_dan rd on r.rd_id = rd.rd_id
left join Production.Zaposleni z on z.zap_mbr = r.zap_mbr
inner join Production.Status s on s.status_id = r.status_id
where datum = '04-30-2020';
execute dbo.dodaj_radnike '04-29-2020', '04-30-2020';
select datum 'Datum', zap_ime+' '+ zap_prz 'Zaposleni', naziv_stat 'Status'  
from Production.Radi r 
inner join Production.Radni_dan rd on r.rd_id = rd.rd_id
left join Production.Zaposleni z on z.zap_mbr = r.zap_mbr
inner join Production.Status s on s.status_id = r.status_id
where datum = '04-29-2020' or datum = '04-30-2020';

update Production.Radi
set status_id = 4
where rd_id = 6 and zap_mbr = '070498745052';

update Production.Radi
set status_id = 2
where rd_id = 6 and zap_mbr = '0708992735052';

select * from Production.Radi r
inner join Production.Radni_dan rd on r.rd_id = rd.rd_id
where datum = '04-30-2020';

/*Procedura dozvoljava samo prepisivanje od starijih datuma, 
odnosno prvi parametar procedure mora biti stariji datum od drugog datuma*/
execute dbo.dodaj_radnike  '03-30-2020', '04-29-2020';
select datum 'Datum', zap_ime+' '+ zap_prz 'Zaposleni', naziv_stat 'Status'  
from Production.Radi r 
inner join Production.Radni_dan rd on r.rd_id = rd.rd_id
left join Production.Zaposleni z on z.zap_mbr = r.zap_mbr
inner join Production.Status s on s.status_id = r.status_id
where datum = '04-29-2020' or datum = '04-30-2020';

/*Poziv procedure kojim se radnici i njihovi statusi dana 29.04.2020. prepisuju u tabelu Radi 
za dan 29.04.2021, gde u radni kalendar nije prethodno unet datum 29.04.2021: */
execute dbo.dodaj_radnike  '04-29-2020', '04-29-2021';
select datum 'Datum', zap_ime+' '+ zap_prz 'Zaposleni', naziv_stat 'Status'  
from Production.Radi r 
inner join Production.Radni_dan rd on r.rd_id = rd.rd_id
left join Production.Zaposleni z on z.zap_mbr = r.zap_mbr
inner join Production.Status s on s.status_id = r.status_id
where datum = '04-29-2020' or datum = '04-29-2021';

delete from Production.Radi
where rd_id = (select rd_id from Production.Radni_dan where datum = '04-29-2021');

delete from Production.Radni_dan 
where datum = '04-29-2021';

/*Poziv procedure kojim se radnici i njihovi statusi dana 28.04.2020. prepisuju u tabelu Radi za dan 29.04.2020, 
gde su prethodno postojali zapisi za dan 29.04.2020. 
i zaposleni su dodeljeni zahtevima za ovaj dan u tabeli Zahteva: */
select datum 'Datum', zap_ime+' '+ zap_prz 'Zaposleni', naziv_stat 'Status'  
from Production.Radi r 
inner join Production.Radni_dan rd on r.rd_id = rd.rd_id
left join Production.Zaposleni z on z.zap_mbr = r.zap_mbr
inner join Production.Status s on s.status_id = r.status_id
where datum = '04-29-2020'
execute dbo.dodaj_radnike '04-28-2020', '04-29-2020';
select datum 'Datum', zap_ime+' '+ zap_prz 'Zaposleni', naziv_stat 'Status'  
from Production.Radi r 
inner join Production.Radni_dan rd on r.rd_id = rd.rd_id
left join Production.Zaposleni z on z.zap_mbr = r.zap_mbr
inner join Production.Status s on s.status_id = r.status_id
where datum = '04-28-2020' or datum = '04-29-2020'

/*Poziv procedure sa neispravno prosleđenim parametrima*/
execute dbo.dodaj_radnike '04-29-2020', '04-28-2020';
execute dbo.dodaj_radnike '04-28-2019', '04-28-2020';