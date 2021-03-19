if object_id('Production.Se_koristi','U') is not null
	drop table Production.Se_koristi;

if object_id('Production.Mat_za','U') is not null
	drop table Production.Mat_za;

if object_id('Production.Zahteva','U') is not null
	drop table Production.Zahteva;

if OBJECT_ID('Production.DFT_zahtev_za_salon_zahtev_id') is not null
	alter table Production.Zahtev_za_salon
		drop constraint DFT_zahtev_za_salon_zahtev_id;
if OBJECT_ID('zahtev_za_salon_seq') is not null
	drop sequence zahtev_za_salon_seq;

if object_id('Production.Zahtev_za_salon','U') is not null
	drop table Production.Zahtev_za_salon;

if object_id('Production.Radi','U') is not null
	drop table Production.Radi;

if OBJECT_ID('Production.DFT_status_status_id') is not null
	alter table Production.Status
		drop constraint DFT_status_status_id;
if OBJECT_ID('status_seq') is not null
	drop sequence status_seq;

if object_id('Production.Status','U') is not null
	drop table Production.Status;

if object_id('Production.Ima_schemu','U') is not null
	drop table Production.Ima_schemu;

if OBJECT_ID('Production.DFT_radni_dan_rd_id') is not null
	alter table Production.Radni_dan
		drop constraint DFT_radni_dan_rd_id;
if OBJECT_ID('radni_dan_seq') is not null
	drop sequence radni_dan_seq;

if object_id('Production.Radni_dan','U') is not null
	drop table Production.Radni_dan;

if OBJECT_ID('Production.DFT_schema_dan_schema_id') is not null
	alter table Production.Schema_dan
		drop constraint DFT_schema_dan_schema_id;
if OBJECT_ID('schema_dan_seq') is not null
	drop sequence schema_dan_seq;

if object_id('Production.Schema_dan','U') is not null
	drop table Production.Schema_dan;

if OBJECT_ID('Production.DFT_materijal_mat_id') is not null
	alter table Production.Materijal
		drop constraint DFT_materijal_mat_id;
if OBJECT_ID('materijal_seq') is not null
	drop sequence materijal_seq;

if object_id('Production.Materijal','U') is not null
	drop table Production.Materijal;

if OBJECT_ID('Production.DFT_Usluga_usluga_id') is not null
	alter table Production.Usluga
		drop constraint DFT_Usluga_usluga_id;
if OBJECT_ID('usluga_seq') is not null
	drop sequence usluga_seq;

if object_id('Production.Usluga', 'U') is not null
	drop table Production.Usluga

if object_id('Production.Zaposleni', 'U') is not null
	drop table Production.Zaposleni;