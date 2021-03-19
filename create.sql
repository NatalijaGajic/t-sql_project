
/*
drop schema Production;
go
create schema Production;
go*/

if object_id('Production.Zaposleni', 'U') is not null
	drop table Production.Zaposleni;
create table Production.Zaposleni 
(
	zap_mbr varchar(13) not null,
	zap_ime nvarchar(40) not null,
	zap_prz nvarchar(40) not null,
	zap_tel varchar(11) not null default(''),
	zap_adresa nvarchar(60) not null default(''),
	zap_od date not null,
	zap_do date null, 
	zap_korisnicko varchar(20) null,
	zap_lozinka varchar(20) null,
	constraint PK_Zaposleni_zap_mbr PRIMARY KEY(zap_mbr),
	constraint CHK_Zaposleni_zap_do CHECK(zap_od <zap_do)
);



if object_id('Production.Usluga', 'U') is not null
	drop table Production.Usluga
create table Production.Usluga 
(
	usluga_id smallint not null,
	naziv_usluge nvarchar(80) not null,
	usluga_cena smallmoney not null,
	valuta varchar(3) not null default('din'),
	constraint PK_Usluga PRIMARY KEY(usluga_id),
	constraint CHK_Usluga_usluga_cena CHECK(usluga_cena>0)
);

if OBJECT_ID('Production.DFT_Usluga_usluga_id') is not null
	alter table Production.Usluga
		drop constraint DFT_Usluga_usluga_id;
if OBJECT_ID('usluga_seq') is not null
	drop sequence usluga_seq;

create sequence usluga_seq as smallint
start with 1
increment by 1;

alter table Production.Usluga
	add constraint DFT_Usluga_usluga_id default (next value for usluga_seq) for usluga_id;


if object_id('Production.Materijal','U') is not null
	drop table Production.Materijal;
create table Production.Materijal
(
	mat_id int not null,
	naz_mat nvarchar(80) not null,
	kol_mat int not null,
	proizvodjac_mat nvarchar(80) not null,
	rok_upotrebe date null,
	mat_jedinicna_cena smallmoney not null,
	constraint PK_Materijal_mat_id PRIMARY KEY(mat_id),
	constraint CHK_Materijal_mat_jedinicna_cena CHECK(mat_jedinicna_cena>0),
	constraint CHK_Materijal_kol_mat CHECK(kol_mat>=0)
)

if OBJECT_ID('Production.DFT_materijal_mat_id') is not null
	alter table Production.Materijal
		drop constraint DFT_materijal_mat_id;
if OBJECT_ID('materijal_seq') is not null
	drop sequence materijal_seq;

create sequence materijal_seq as int
start with 1
increment by 1;

alter table Production.Materijal
	add constraint DFT_materijal_mat_id default (next value for materijal_seq) for mat_id;


if object_id('Production.Schema_dan','U') is not null
	drop table Production.Schema_dan;
create table Production.Schema_dan
(
	schema_id smallint not null,
	vreme_od time(0) not null,
	vreme_do time(0) not null,
	constraint PK_Schema_dan_schema_id PRIMARY KEY(schema_id),
	constraint CHK_Schema_dan_vreme_do CHECK(vreme_od<vreme_do)
)

if OBJECT_ID('Production.DFT_schema_dan_schema_id') is not null
	alter table Production.Schema_dan
		drop constraint DFT_schema_dan_schema_id;
if OBJECT_ID('schema_dan_seq') is not null
	drop sequence schema_dan_seq;

create sequence schema_dan_seq as smallint
start with 1
increment by 1;

alter table Production.Schema_dan 
	add constraint DFT_schema_dan_schema_id default(next value for schema_dan_seq) for schema_id;

if object_id('Production.Radni_dan','U') is not null
	drop table Production.Radni_dan;
create table Production.Radni_dan
(
	rd_id int not null,
	datum date not null,
	radni_dan_s bit not null default(0),
	constraint PK_Radni_dan_rd_id PRIMARY KEY(rd_id),
	constraint UQ_Radni_dan_datum UNIQUE(datum)
);

if OBJECT_ID('Production.DFT_radni_dan_rd_id') is not null
	alter table Production.Radni_dan
		drop constraint DFT_radni_dan_rd_id;
if OBJECT_ID('radni_dan_seq') is not null
	drop sequence radni_dan_seq;

create sequence radni_dan_seq as int
start with 1
increment by 1;

alter table Production.Radni_dan 
	add constraint DFT_radni_dan_rd_id default(next value for radni_dan_seq) for rd_id;

if object_id('Production.Ima_schemu','U') is not null
	drop table Production.Ima_schemu;
create table Production.Ima_schemu
(
	rd_id int not null,
	schema_id smallint not null,
	constraint PK_Ima_schemu PRIMARY KEY (rd_id, schema_id),
	constraint FK_Ima_schemu_Radni_dan FOREIGN KEY (rd_id) REFERENCES Production.Radni_dan,
	constraint FK_Ima_schemu_Schema_dan FOREIGN KEY (schema_id) REFERENCES Production.Schema_dan
);


if object_id('Production.Status','U') is not null
	drop table Production.Status;
create table Production.Status
(
	status_id tinyint not null,
	naziv_stat nvarchar(70) not null,
	constraint PK_Status PRIMARY KEY (status_id)
);

if OBJECT_ID('Production.DFT_status_status_id') is not null
	alter table Production.Status
		drop constraint DFT_status_status_id;
if OBJECT_ID('status_seq') is not null
	drop sequence status_seq;

create sequence status_seq as tinyint
start with 1
increment by 1;

alter table Production.Status 
	add constraint DFT_status_status_id default(next value for status_seq) for status_id;

if object_id('Production.Radi','U') is not null
	drop table Production.Radi;
create table Production.Radi
(
	zap_mbr varchar(13) not null,
	rd_id int not null,
	status_id tinyint not null,
	constraint PK_Radi PRIMARY KEY (rd_id, zap_mbr),
	constraint FK_Radi_Radni_dan FOREIGN KEY (rd_id) REFERENCES Production.Radni_dan,
	constraint FK_Radi_Zaposleni FOREIGN KEY (zap_mbr) REFERENCES Production.Zaposleni,
	constraint FK_Radi_Status FOREIGN KEY (status_id) REFERENCES Production.Status
);


if object_id('Production.Zahtev_za_salon','U') is not null
	drop table Production.Zahtev_za_salon;
create table Production.Zahtev_za_salon
(
	zahtev_id int not null,
	status_zahteva nvarchar(40) not null default(''),
	datum_podnosenja date not null,
	constraint PK_Zahtev_za_salon PRIMARY KEY (zahtev_id)
);

if OBJECT_ID('Production.DFT_zahtev_za_salon_zahtev_id') is not null
	alter table Production.Zahtev_za_salon
		drop constraint DFT_zahtev_za_salon_zahtev_id;
if OBJECT_ID('zahtev_za_salon_seq') is not null
	drop sequence zahtev_za_salon_seq;

create sequence zahtev_za_salon_seq as int
start with 1
increment by 1;

alter table Production.Zahtev_za_salon
	add constraint DFT_zahtev_za_salon_zahtev_id default(next value for zahtev_za_salon_seq) for zahtev_id;

if object_id('Production.Zahteva','U') is not null
	drop table Production.Zahteva;
create table Production.Zahteva
(
	usluga_id smallint not null,
	zahtev_id int not null,
	termin time(0) not null,
	termin_zak time(0) null,
	datum_zahtev date not null,
	zap_mbr varchar(13) null,
	rd_id int null,
	constraint PK_Zahteva PRIMARY KEY (zahtev_id, usluga_id),
	constraint FK_Zahteva_Usluga FOREIGN KEY (usluga_id) REFERENCES Production.Usluga,
	constraint FK_Zahteva_Zahtev_za_salon FOREIGN KEY (zahtev_id) REFERENCES Production.Zahtev_za_salon,
	constraint FK_Zahteva_Radi FOREIGN KEY (rd_id, zap_mbr) REFERENCES Production.Radi,
	constraint FK_Zahteva_Radni_dan FOREIGN KEY (rd_id) REFERENCES Production.Radni_dan
);

if object_id('Production.Mat_za','U') is not null
	drop table Production.Mat_za;
create table Production.Mat_za
(
	usluga_id smallint not null,
	mat_id int not null,
	normativ smallint null,
	jedinica varchar(10) null,
	constraint PK_Mat_za PRIMARY KEY (usluga_id, mat_id),
	constraint FK_Mat_za_Usluga FOREIGN KEY (usluga_id) REFERENCES Production.Usluga,
	constraint FK_Mat_za_Materijal FOREIGN KEY (mat_id) REFERENCES Production.Materijal
);

if object_id('Production.Se_koristi','U') is not null
	drop table Production.Se_koristi;
create table Production.Se_koristi
(
	zahtev_id int not null,
	usluga_id smallint not null,
	mat_id int not null,
	kol_potr smallint not null,
	constraint PK_Se_koristi PRIMARY KEY (zahtev_id, usluga_id, mat_id),
	constraint FK_Se_koristi_Mat_za FOREIGN KEY (usluga_id, mat_id) REFERENCES Production.Mat_za,
	constraint FK_Se_koristi_Zahteva FOREIGN KEY (zahtev_id, usluga_id) REFERENCES Production.Zahteva
)

--indeksi
If indexproperty(object_id('Production.Zahtev_za_salon'), 'ind_zahtev_za_salon_datum', 'IndexId') is not null
	drop index ind_zahtev_za_salon_datum
	on Production.Zahtev_za_salon

create nonclustered index ind_zahtev_za_salon_datum
on Production.Zahtev_za_salon (datum_podnosenja desc)

If indexproperty(object_id('Production.Zahteva'), 'ind_zahteva_rd_id', 'IndexId') is not null
	drop index ind_zahteva_rd_id
	on Production.Zahteva

create nonclustered index ind_zahteva_rd_id
on Production.Zahteva (rd_id)
include(termin_zak, usluga_id)

If indexproperty(object_id('Production.Zahteva'), 'ind_zahteva_zap_mbr_rd_id', 'IndexId') is not null
	drop index ind_zahteva_zap_mbr_rd_id
	on Production.Zahteva

create nonclustered index ind_zahteva_zap_mbr_rd_id
on Production.Zahteva (zap_mbr, rd_id)

If indexproperty(object_id('Production.Zaposleni'), 'ind_zaposleni_korisnicko', 'IndexId') is not null
	drop index ind_zaposleni_korisnicko
	on Production.Zaposleni

create unique index ind_zaposleni_korisnicko
on Production.Zaposleni (zap_korisnicko)
	where zap_korisnicko is not null


