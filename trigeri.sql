
if object_id('Production.tr_radni_dan', 'TR') is not null
	drop trigger Production.tr_radni_dan;
go
create trigger Production.tr_radni_dan
on Production.Radni_dan
after insert, update
as
begin

	declare @radni_dan_s_deleted bit; 
	declare @rd_id_deleted int;
	declare @datum_deleted date;
	declare @rd_id int;
	declare @datum date;
	declare @radni_dan_s bit;
	declare @schema_id smallint = 2;
	declare @zap_mbr_cursor varchar;
	declare @if_update bit = 1;
	declare @ispravka_modifikacije int = 0;

	declare kursor_for_deleted cursor fast_forward for
	select rd_id, datum, radni_dan_s
	from deleted;
	open kursor_for_deleted;
	fetch next from kursor_for_deleted into @rd_id_deleted, @datum_deleted, @radni_dan_s_deleted;
	if @rd_id_deleted is null
		begin
		set @if_update = 0;
		close kursor_for_deleted;
		deallocate kursor_for_deleted;
		end

	declare kursor_for_inserted cursor fast_forward for
	select rd_id, datum, radni_dan_s
	from inserted;
	open kursor_for_inserted;
	fetch next from kursor_for_inserted into @rd_id, @datum, @radni_dan_s;

	while @@fetch_status = 0
		begin
		if @if_update = 1
			begin
			--update
			if update(radni_dan_s) and @radni_dan_s_deleted = 1
				begin
				--updejtuje se sa jedinice na nulu
				declare @broj_torki_u_zahteva int = (select count(rd_id) from Production.Zahteva where rd_id = @rd_id_deleted);
				if @broj_torki_u_zahteva > 0
					begin
					update Production.Radni_dan
					set rd_id = @rd_id_deleted,
					datum = @datum_deleted,
					radni_dan_s = @radni_dan_s_deleted
					where rd_id = @rd_id;
					RAISERROR (N'Nije moguć update jer za radni dan postoje zapisi u tabeli Zahteva.' ,10,1);
					end
				else 
					begin
					--brisanje torki iz tabele Radi
					delete from Production.Radi
					where rd_id = @rd_id_deleted;
					end
					--brisanje torki iz tabele Ima_schemu
					delete from Production.Ima_schemu
					where rd_id = @rd_id_deleted;
					print 'Uspešno modifikovana torka tabele Radni dan. Izbrisani zapisi tabela Radi i Ima_schemu.';
				end
			else if  update(radni_dan_s) and @radni_dan_s_deleted = 0
				begin
				--update-uje se sa nule na jedinicu
				--provera da li se izvrsava ispravljanje modifikacije 
				--(dan je bio postavljen na neradan ali postoje zapisi u Zahteva), u ovom slucaju se ne dodaje zapis u Ima_schemu
				--jer zapis vec postoji, samo je potrebno vratiti vrednost radni_dan_s na 1 (sto je uradjeno modifikacijom)
				set @ispravka_modifikacije = (select count(rd_id) from Production.Ima_schemu where rd_id = @rd_id);
				if @ispravka_modifikacije = 0
					begin
					insert into Production.Ima_schemu (rd_id, schema_id)
					values (@rd_id, @schema_id);
					print 'Uspešno modifikovana torka tabele Radni dan. Dodata šema radnog dana.';
					end
				end
				
			--end update
			end
		else
			begin
			--insert
			if @radni_dan_s = 1
				begin
				insert into Production.Ima_schemu (rd_id, schema_id)
				values (@rd_id, @schema_id);
				print 'Uspešno dodata torka tabele Radni dan. Dodata šema radnog dana.';
				end
			end

		if @if_update = 1 
		fetch next from kursor_for_deleted into @rd_id_deleted, @datum_deleted, @radni_dan_s_deleted;
		fetch next from kursor_for_inserted into @rd_id, @datum, @radni_dan_s;
		--end while
		end

		if @if_update = 1
			begin
			close kursor_for_deleted;
			deallocate kursor_for_deleted;
			end
		close kursor_for_inserted;
		deallocate kursor_for_inserted;
return;
end

--testiranje trigera:
--Pokušaj modifikacije radnog dana poslovanja promenom vrednosti obležja radni_dan_s na nulu, 
--gde za radni dan koji treba modifikovati postoje zapisi u tabeli Zahteva
select usluga_id, zahtev_id, termin_zak, zap_mbr, z.rd_id, radni_dan_s, datum 
from Production.Zahteva z
inner join Production.Radni_dan rd on rd.rd_id = z.rd_id 
where z.rd_id = 5;
update Production.Radni_dan
set radni_dan_s = 0
where rd_id = 5;
select * from Production.Radni_dan where rd_id = 5;
select * from Production.Radi where rd_id = 5;

--Pokušaj modifikacije radnog dana poslovanja promenom vrednosti obležja radni_dan_s na nulu, 
--gde za radni dan koji treba modifikovati ne postoje zapisi u tabeli Zahteva
select * from Production.Zahteva where rd_id = 7;
select * from Production.Radni_dan where rd_id = 7;
select * from Production.Ima_schemu where rd_id = 7;
select * from Production.Radi where rd_id = 7;
update Production.Radni_dan
set radni_dan_s = 0
where rd_id = 7;
select * from Production.Radni_dan where rd_id = 7;
select * from Production.Radi where rd_id = 7;
select * from Production.Ima_schemu where rd_id = 7;

--vracanje podataka o danu rd_id na stare:
update Production.Radni_dan
set radni_dan_s = 1
where rd_id = 7;
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('0708979735052',7,4);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('070498745052',7,4);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('1711991735052',7,4);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('0412993735052',7,4);

--Pokušaj modifikacije neradnog dana poslovanja promenom vrednosti obležja radni_dan_s na jedinicu
select * from Production.Radni_dan where rd_id = 1;
select * from Production.Ima_schemu where rd_id = 1;
update Production.Radni_dan 
set radni_dan_s = 1
where rd_id = 1;
select * from Production.Radni_dan where rd_id = 1;
select * from Production.Ima_schemu where rd_id = 1;
update Production.Radni_dan 
set radni_dan_s = 0
where rd_id = 1;

--Unošenje dana poslovanja koji je radan
insert into Production.Radni_dan (datum, radni_dan_s)
values('03-03-2016',1);
select * from Production.Radni_dan where datum = '03-03-2016'
select * from Production.Ima_schemu where rd_id = (select rd_id from Production.Radni_dan where datum = '03-03-2016');
delete from Production.Ima_schemu 
where rd_id = (select rd_id from Production.Radni_dan where datum = '03-03-2016');
delete  from Production.Radni_dan
where datum = '03-03-2016';
select * from Production.Ima_schemu
select * from Production.Radni_dan



if object_id('Production.tr_zahteva', 'TR') is not null
	drop trigger Production.tr_zahteva;
go
create trigger Production.tr_zahteva
on Production.Zahteva
after insert, update
as
begin
	set nocount on;
	declare @usluga_id smallint;
	declare @zahtev_id int;
	declare @termin time(0);
	declare @termin_zak time(0);
	declare @datum_zahtev date;
	declare @zap_mbr varchar(13);
	declare @rd_id int;
	declare @usluga_id_deleted smallint;
	declare @zahtev_id_deleted int;
	declare @termin_deleted time(0);
	declare @termin_zak_deleted time(0);
	declare @datum_zahtev_deleted date;
	declare @zap_mbr_deleted varchar(13);
	declare @rd_id_deleted int;
	declare @vreme_od time(0);
	declare @vreme_do time(0);
	declare @status_aktivnog tinyint = 4;
	declare @termin_zak_validan bit = 0;
	declare @is_update bit = 1;

	declare kursor_for_deleted cursor fast_forward for 
	select usluga_id, zahtev_id, termin, termin_zak, datum_zahtev, zap_mbr, rd_id
	from deleted;
	open kursor_for_deleted;
	fetch next from kursor_for_deleted into @usluga_id_deleted, @zahtev_id_deleted, @termin_deleted,
		@termin_zak_deleted, @datum_zahtev_deleted, @zap_mbr_deleted, @rd_id_deleted;
	if @usluga_id_deleted is null
		begin
		set @is_update = 0;
		close kursor_for_deleted;
		deallocate kursor_for_deleted;
		end

	declare kursor_for_inserted cursor fast_forward for 
	select usluga_id, zahtev_id, termin, termin_zak, datum_zahtev, zap_mbr, rd_id
	from inserted;
	open kursor_for_inserted;
	fetch next from kursor_for_inserted into @usluga_id, @zahtev_id, @termin,
		@termin_zak, @datum_zahtev, @zap_mbr, @rd_id;

	while @@fetch_status = 0
		begin
		
		--1.
		if @rd_id is not null
			begin
			declare @radni_dan_s bit = (select radni_dan_s from Production.Radni_dan where rd_id = @rd_id);
			if @radni_dan_s = 0
				begin
				if @is_update = 1
					begin
					--update 
					update Production.Zahteva 
					set zahtev_id = @zahtev_id_deleted,
					usluga_id = @usluga_id_deleted,
					termin = @termin_deleted,
					termin_zak = @termin_zak_deleted,
					zap_mbr = @zap_mbr_deleted,
					rd_id = @rd_id_deleted
					where usluga_id = @usluga_id and zahtev_id = @zahtev_id;
					end
				else
					begin
					--insert
					delete from Production.Zahteva
					where zahtev_id = @zahtev_id and usluga_id = @usluga_id;
					end
				raiserror('Datum za koji se pružanje usluge zakazuje mora biti radan dan.',10,1);
				break;
				end
			end
		else if @rd_id is null and @termin_zak is not null
			begin
			--ne moze biti zakazan termin ukoliko nije odredjen dan u kom se zakazuje 
			if @is_update = 1
				begin
				--update 
				update Production.Zahteva 
				set zahtev_id = @zahtev_id_deleted,
				usluga_id = @usluga_id_deleted,
				termin = @termin_deleted,
				termin_zak = @termin_zak_deleted,
				zap_mbr = @zap_mbr_deleted,
				rd_id = @rd_id_deleted
				where usluga_id = @usluga_id and zahtev_id = @zahtev_id;
				end
			else
				begin
				--insert
				delete from Production.Zahteva
				where zahtev_id = @zahtev_id and usluga_id = @usluga_id;
				end
			raiserror('Pružanje usluge mora da bude zakazano za određeni radni dan da bi se zakazao termin.',10,1);
			break;
			end	



		--2.
		declare @datum date = (select datum from Production.Radni_dan where rd_id = @rd_id);
		if @datum != @datum_zahtev
			begin
			if @is_update = 1
				begin
				--update 
				update Production.Zahteva 
				set zahtev_id = @zahtev_id_deleted,
				usluga_id = @usluga_id_deleted,
				termin = @termin_deleted,
				termin_zak = @termin_zak_deleted,
				zap_mbr = @zap_mbr_deleted,
				rd_id = @rd_id_deleted
				where usluga_id = @usluga_id and zahtev_id = @zahtev_id;
				end
			else
				begin
				--insert
				delete from Production.Zahteva
				where zahtev_id = @zahtev_id and usluga_id = @usluga_id;
				end
			--ne moze biti zakazan termin ukoliko nije odredjen dan u kom se zakazuje 
			raiserror('Datum za koji se zakazuje pružanje uslugu mora da odgovara zahtevanom datumu.',10,1);
			break;
			end	


		--3.
		if @termin_zak is not null
			begin
			declare kursor cursor fast_forward for
			select vreme_od, vreme_do
			from Production.Ima_schemu ish
			inner join Production.Schema_dan sd on ish.schema_id = sd.schema_id
			where rd_id = @rd_id;
			open kursor;

			fetch next from kursor into @vreme_od, @vreme_do;
			while @@fetch_status = 0
				begin
				if @termin_zak > @vreme_od and @termin_zak < @vreme_do
					begin
					set @termin_zak_validan = 1;
					break;
					end
				fetch next from kursor into @vreme_od, @vreme_do;
				end
			close kursor;
			deallocate kursor;
			if @termin_zak_validan = 0
				begin
				if @is_update = 1
					begin
					--update 
					update Production.Zahteva 
					set zahtev_id = @zahtev_id_deleted,
					usluga_id = @usluga_id_deleted,
					termin = @termin_deleted,
					termin_zak = @termin_zak_deleted,
					zap_mbr = @zap_mbr_deleted,
					rd_id = @rd_id_deleted
					where usluga_id = @usluga_id and zahtev_id = @zahtev_id;
					end
				else
					begin
					--insert
					delete from Production.Zahteva
					where zahtev_id = @zahtev_id and usluga_id = @usluga_id;
					end
					raiserror('Termin za koji se zakazuje pružanje usluge mora odgovarati šemi radnog dana.',10,1);
					break;
					end
			end


		--4.
		if @zap_mbr is not null
			begin
			declare @status_zaposlenog tinyint = (select status_id from Production.Radi where rd_id = @rd_id and zap_mbr = @zap_mbr);
			if @status_zaposlenog != 4
				begin
				if @is_update = 1
					begin
					--update 
					update Production.Zahteva 
					set zahtev_id = @zahtev_id_deleted,
					usluga_id = @usluga_id_deleted,
					termin = @termin_deleted,
					termin_zak = @termin_zak_deleted,
					zap_mbr = @zap_mbr_deleted,
					rd_id = @rd_id_deleted
					where usluga_id = @usluga_id and zahtev_id = @zahtev_id;
					end
				else
					begin
					--insert
					delete from Production.Zahteva
					where zahtev_id = @zahtev_id and usluga_id = @usluga_id;
					end
				raiserror('Status zaposlenog mora biti odgovarajući.',10,1);
				break;
				end
			end

		if @is_update = 1
		fetch next from kursor_for_deleted into @usluga_id_deleted, @zahtev_id_deleted, @termin_deleted,
			@termin_zak_deleted, @datum_zahtev_deleted, @zap_mbr_deleted, @rd_id_deleted;
		fetch next from kursor_for_inserted into @usluga_id, @zahtev_id, @termin,
			@termin_zak, @datum_zahtev, @zap_mbr, @rd_id;
		--end while
		end
	
	if @is_update = 1
		begin
		close kursor_for_deleted;
		deallocate kursor_for_deleted;
		end
	close kursor_for_inserted;
	deallocate kursor_for_inserted;
return;
end

--testiranje trigera
--Pokušaj zakazivanja pružanja zahtevane uluge neradnog dana
select * from Production.Radni_dan where rd_id = 1;
update Production.Zahteva
set rd_id = 1
where zahtev_id = 12 and usluga_id = 3;
select * from Production.Zahteva where zahtev_id = 12 and usluga_id = 3;

--Pokušaj zakazivanja termina pružanja zahtevane usluge kada nije zakazan dan u kom treba pružiti uslugu
select * from Production.Zahteva where  zahtev_id = 12 and usluga_id = 3;
update Production.Zahteva
set termin_zak = '12:00'
where zahtev_id = 12 and usluga_id = 3;

--Pokušaj zakazivanja pružanja zahtevane usluge za radni dan koji ne odgovara zahtevanom datumu
select * from Production.Radni_dan where rd_id = 5;
select * from Production.Zahteva where  zahtev_id = 11 and usluga_id = 6;
update Production.Zahteva
set rd_id = 5
where zahtev_id = 11 and usluga_id = 6;

--Pokušaj zakazivanja termina, određenog radnog dana koji odgovara zahtevanom datumu, koji ne odgovara šemi radnog dana
select * from Production.Ima_schemu ish inner join Production.Schema_dan sd on ish.schema_id = sd.schema_id where rd_id = 4;
select * from Production.Zahteva where  zahtev_id = 11 and usluga_id = 6;
update Production.Zahteva
set rd_id = 4,
termin_zak = '18:30'
where zahtev_id = 11 and usluga_id = 6;
update Production.Zahteva
set rd_id = null,
termin_zak = null
where zahtev_id = 11 and usluga_id = 6;

--Pokušaj angažovanja zaposlenog sa neispravnim statusom za izvršavanje usluge
select * from Production.Radni_dan where rd_id = 5;
select * from Production.Ima_schemu ish inner join Production.Schema_dan sd on ish.schema_id = sd.schema_id where rd_id = 5;
select * from Production.Zahteva where  zahtev_id = 12 and usluga_id = 3;
select * from Production.Radi where rd_id = 5 and zap_mbr = '1408983735452';
update Production.Zahteva
set rd_id = 5,
termin_zak = '12:00',
zap_mbr = '1408983735452'
where zahtev_id = 12 and usluga_id = 3;

--Ispravan pokušaj modifikacije
select * from Production.Radni_dan where rd_id = 5;
select * from Production.Ima_schemu ish inner join Production.Schema_dan sd on ish.schema_id = sd.schema_id where rd_id = 5;
select * from Production.Radi where rd_id = 5 and zap_mbr = '070498745052';
select * from Production.Zahteva where  zahtev_id = 12 and usluga_id = 3;
update Production.Zahteva
set rd_id = 5,
termin_zak = '12:00',
zap_mbr = '070498745052'
where zahtev_id = 12 and usluga_id = 3;
select * from Production.Zahteva where  zahtev_id = 12 and usluga_id = 3;
update Production.Zahteva
set rd_id = null,
termin_zak = null,
zap_mbr = null
where zahtev_id = 12 and usluga_id = 3;
