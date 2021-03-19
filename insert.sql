--za insert datuma mm-dd-yyyy
insert into Production.Zaposleni (zap_mbr, zap_ime, zap_prz, zap_tel, zap_adresa, zap_od)
values('0708992735052','Natalija','Reljin','0691701450',N'Vojvode Mišića 31/11','02-03-2015');
insert into Production.Zaposleni (zap_mbr, zap_ime, zap_prz, zap_tel, zap_adresa, zap_od, zap_do)
values('2603993456765','Milan',N'Gajić','062456376','Kikindska 1','02-03-2015', '03-02-2016');
insert into Production.Zaposleni (zap_mbr, zap_ime, zap_prz, zap_tel, zap_adresa, zap_od)
values('0708979735052','Stefan',N'Teodosić','0611741450','Vojvode Putnika 3','02-04-2015');
insert into Production.Zaposleni (zap_mbr, zap_ime, zap_prz, zap_tel, zap_adresa, zap_od)
values('070498745052','Milena',N'Jovanović','0633701450',N'Niška 4','02-04-2015');
insert into Production.Zaposleni (zap_mbr, zap_ime, zap_prz, zap_tel, zap_adresa, zap_od)
values('1408983735452','Stefan',N'Jović','0641701450','Jesenjinova 32','02-05-2015');
insert into Production.Zaposleni (zap_mbr, zap_ime, zap_prz, zap_tel, zap_adresa, zap_od)
values('2408992735052','Nemanja',N'Andrić','0611701350',N'Bulevar oslobođenja 12','02-03-2015');
insert into Production.Zaposleni (zap_mbr, zap_ime, zap_prz, zap_tel, zap_adresa, zap_od)
values('1711991735052','Nikola',N'Filipović','0641701330',N'Vojvođanska 11','02-03-2015');
insert into Production.Zaposleni (zap_mbr, zap_ime, zap_prz, zap_tel, zap_adresa, zap_od)
values('0412993735052',N'Dušan',N'Ostojić','0631732450',N'Ustanička 22','02-05-2015');
--select * from Production.Zaposleni
--truncate table Production.Zaposleni


insert into Production.Usluga (naziv_usluge, usluga_cena, valuta)
values (N'Sečenje noktiju', 500, 'din');
insert into Production.Usluga (naziv_usluge, usluga_cena, valuta)
values (N'Kratkodlako šišanje', 700, 'din');
insert into Production.Usluga (naziv_usluge, usluga_cena, valuta)
values (N'Srednjedlako šišanje', 900, 'din');
insert into Production.Usluga (naziv_usluge, usluga_cena, valuta)
values (N'Dugodlako šišanje', 1000, 'din');
insert into Production.Usluga (naziv_usluge, usluga_cena, valuta)
values (N'Kupanje sitnijih rasa', 500, 'din');
insert into Production.Usluga (naziv_usluge, usluga_cena, valuta)
values (N'Kupanje srednjih rasa', 700, 'din');
insert into Production.Usluga (naziv_usluge, usluga_cena, valuta)
values (N'Kupanje velikih rasa', 900, 'din');
--select * from Production.Usluga
--truncate table Production.Usluga


insert into Production.Materijal (naz_mat, kol_mat, proizvodjac_mat, rok_upotrebe, mat_jedinicna_cena)
values (N'Šampon za kupanje dugodlakih pasa', 100, N'Šamponi za pse', '02-05-2021', 100);
insert into Production.Materijal (naz_mat, kol_mat, proizvodjac_mat, rok_upotrebe, mat_jedinicna_cena)
values (N'Šampon za kupanje srednjedlakih pasa', 120, N'Šamponi za pse', '02-05-2021', 80);
insert into Production.Materijal (naz_mat, kol_mat, proizvodjac_mat, rok_upotrebe, mat_jedinicna_cena)
values (N'Šampon za kupanje kratkodlakih pasa', 100, N'Šamponi za pse', '02-06-2021', 80);
insert into Production.Materijal (naz_mat, kol_mat, proizvodjac_mat, rok_upotrebe, mat_jedinicna_cena)
values (N'Šampon za kovrdžavu dlaku', 98, N'Šamponi za pse', '02-05-2021', 100);
insert into Production.Materijal (naz_mat, kol_mat, proizvodjac_mat, rok_upotrebe, mat_jedinicna_cena)
values (N'Regenerator za oštećenu dlaku', 41, N'Šamponi za pse', '02-05-2022', 120);
insert into Production.Materijal (naz_mat, kol_mat, proizvodjac_mat, rok_upotrebe, mat_jedinicna_cena)
values (N'Šampon za osetljivu kožu', 81, N'Šamponi za pse', '02-05-2021', 150);
--select * from Production.Materijal
--truncate table Production.Materijal;

insert into Production.Schema_dan (vreme_od, vreme_do)
values('18:00', '19:00');
insert into Production.Schema_dan (vreme_od, vreme_do)
values('08:00', '16:00');
insert into Production.Schema_dan (vreme_od, vreme_do)
values('09:00', '17:00');
insert into Production.Schema_dan (vreme_od, vreme_do)
values('10:00', '18:00');
insert into Production.Schema_dan (vreme_od, vreme_do)
values('08:00', '17:00');
insert into Production.Schema_dan (vreme_od, vreme_do)
values('09:00', '19:00');
insert into Production.Schema_dan (vreme_od, vreme_do)
values('08:00', '19:00');
insert into Production.Schema_dan (vreme_od, vreme_do)
values('09:00', '18:00');
insert into Production.Schema_dan (vreme_od, vreme_do)
values('10:00', '18:00');
insert into Production.Schema_dan (vreme_od, vreme_do)
values ('16:30', '17:00');
--select * from Production.Schema_dan
--truncate table Production.Schema_dan



insert into Production.Radni_dan (datum, radni_dan_s)
values('04-25-2020', 0);
insert into Production.Radni_dan (datum, radni_dan_s)
values('04-26-2020', 0);
insert into Production.Radni_dan (datum, radni_dan_s)
values('04-27-2020', 1);
insert into Production.Radni_dan (datum, radni_dan_s)
values('04-28-2020', 1);
insert into Production.Radni_dan (datum, radni_dan_s)
values('04-29-2020', 1)
insert into Production.Radni_dan (datum, radni_dan_s)
values('04-30-2020', 1);
insert into Production.Radni_dan (datum, radni_dan_s)
values('05-01-2020', 1);
insert into Production.Radni_dan (datum, radni_dan_s)
values('05-02-2020', 0);
--select * from Production.Radni_dan
--truncate table Production.Radni_dan


insert into Production.Ima_schemu (rd_id, schema_id)
values(7, 1);
insert into Production.Ima_schemu (rd_id, schema_id)
values(6, 3);
insert into Production.Ima_schemu (rd_id, schema_id)
values(5, 3);
insert into Production.Ima_schemu (rd_id, schema_id)
values(4, 2);
insert into Production.Ima_schemu (rd_id, schema_id)
values(3, 3);
insert into Production.Ima_schemu (rd_id, schema_id)
values(4, 10);

select * from Production.Schema_dan 
--select * from Production.Ima_schemu
--truncate table Production.Ima_schemu


insert into Production.Status (naziv_stat)
values('Odsutan zbog bolovanja');
insert into Production.Status (naziv_stat)
values(N'Odsutan zbog godišnjeg odmora');
insert into Production.Status (naziv_stat)
values('Odsutan iz nepoznatih razloga');
insert into Production.Status (naziv_stat)
values(N'Došao na posao');
--select * from Production.Status
--truncate table Production.Status


--za 28. april
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('0708992735052', 4,4 );
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('0708979735052',4,4);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('070498745052',4,2);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('1408983735452',4,2);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('2408992735052',4,4);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('1711991735052',4,4);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('0412993735052',4,4);

--za 29.04.
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('0708992735052', 5,4 );
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('0708979735052',5,4);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('070498745052',5,4);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('1408983735452',5,2);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('2408992735052',5,4);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('1711991735052',5,4);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('0412993735052',5,4);

--30. april
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('0708992735052',6,2);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('0708979735052',6,4);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('070498745052',6,4);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('1408983735452',6,2);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('2408992735052',6,4);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('1711991735052',6,4);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('0412993735052',6,4);

insert into Production.Radi (zap_mbr, rd_id, status_id)
values('0708979735052',7,4);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('070498745052',7,4);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('1711991735052',7,4);
insert into Production.Radi (zap_mbr, rd_id, status_id)
values('0412993735052',7,4);
--select * from Production.Radi
--truncate table Production.Radi

insert into Production.Zahtev_za_salon (status_zahteva, datum_podnosenja)
values (N'Obrađen','04-21-2020');
insert into Production.Zahtev_za_salon (status_zahteva, datum_podnosenja)
values (N'Obrađen','04-21-2020');
insert into Production.Zahtev_za_salon (status_zahteva, datum_podnosenja)
values (N'Obrađen','04-22-2020');
insert into Production.Zahtev_za_salon (status_zahteva, datum_podnosenja)
values (N'Obrađen','04-22-2020');
insert into Production.Zahtev_za_salon (status_zahteva, datum_podnosenja)
values (N'Obrađen','04-23-2020');
insert into Production.Zahtev_za_salon (status_zahteva, datum_podnosenja)
values (N'Obrađen','04-23-2020');
insert into Production.Zahtev_za_salon (status_zahteva, datum_podnosenja)
values (N'Obrađen','04-23-2020');
insert into Production.Zahtev_za_salon (status_zahteva, datum_podnosenja)
values (N'Obrađen','04-24-2020');
insert into Production.Zahtev_za_salon (status_zahteva, datum_podnosenja)
values (N'Obrađen','04-24-2020');
insert into Production.Zahtev_za_salon (status_zahteva, datum_podnosenja)
values (N'Odbijen','04-23-2020');
insert into Production.Zahtev_za_salon (status_zahteva, datum_podnosenja)
values (N'Odbijen','04-24-2020');

insert into Production.Zahtev_za_salon (status_zahteva, datum_podnosenja)
values (N'Primljen','04-25-2020');
insert into Production.Zahtev_za_salon (status_zahteva, datum_podnosenja)
values (N'Primljen','04-25-2020');
insert into Production.Zahtev_za_salon(status_zahteva, datum_podnosenja)
values (N'Primljen', '04-29-2020');

--select * from Production.Zahtev_za_salon
--truncate table Production.Zahtev_za_salon

insert into Production.Zahteva (zahtev_id, usluga_id, termin, termin_zak, datum_zahtev, zap_mbr, rd_id)
values(1, 1, '12:00', '12:00', '04-28-2020', '0708992735052', 4);
insert into Production.Zahteva (zahtev_id, usluga_id, termin, termin_zak, datum_zahtev, zap_mbr, rd_id)
values(1, 2, '12:30', '12:30', '04-28-2020', '0708992735052', 4);
insert into Production.Zahteva (zahtev_id, usluga_id, termin, termin_zak, datum_zahtev, zap_mbr, rd_id)
values(2, 1, '14:00', '13:20', '04-28-2020', '0412993735052', 4);
insert into Production.Zahteva (zahtev_id, usluga_id, termin, termin_zak, datum_zahtev, zap_mbr, rd_id)
values(3, 1, '13:00', '13:00', '04-28-2020', '0708992735052', 4);
insert into Production.Zahteva (zahtev_id, usluga_id, termin, termin_zak, datum_zahtev, zap_mbr, rd_id)
values(4, 1, '14:00', '14:00', '04-28-2020', '2408992735052', 4);
insert into Production.Zahteva (zahtev_id, usluga_id, termin, datum_zahtev)
values(10, 2, '12:00', '04-28-2020');


insert into Production.Zahteva (zahtev_id, usluga_id, termin, termin_zak, datum_zahtev, zap_mbr, rd_id)
values(5, 3, '14:00', '14:00', '04-29-2020', '0708992735052', 5);
insert into Production.Zahteva (zahtev_id, usluga_id, termin, termin_zak, datum_zahtev, zap_mbr, rd_id)
values(5, 6, '14:45', '14:45', '04-29-2020', '0708992735052', 5);
insert into Production.Zahteva (zahtev_id, usluga_id, termin, termin_zak, datum_zahtev, zap_mbr, rd_id)
values(6, 4, '15:00', '15:00', '04-29-2020', '0708979735052', 5);
insert into Production.Zahteva (zahtev_id, usluga_id, termin, termin_zak, datum_zahtev, zap_mbr, rd_id)
values(6, 7, '15:45', '15:45', '04-29-2020', '0708979735052', 5);
insert into Production.Zahteva (zahtev_id, usluga_id, termin, termin_zak, datum_zahtev, zap_mbr, rd_id)
values(7, 4, '16:00', '16:00', '04-29-2020', '2408992735052', 5);
insert into Production.Zahteva (zahtev_id, usluga_id, termin, termin_zak, datum_zahtev, zap_mbr, rd_id)
values(8, 3, '15:30', '15:30', '04-29-2020', '0412993735052', 5);
insert into Production.Zahteva (zahtev_id, usluga_id, termin, termin_zak, datum_zahtev, zap_mbr, rd_id)
values(9, 4, '16:30', '16:30', '04-29-2020', '2408992735052', 5);
insert into Production.Zahteva (zahtev_id, usluga_id, termin, termin_zak, datum_zahtev, zap_mbr, rd_id)
values(9, 5, '16:30', '16:30', '04-29-2020', '0708992735052', 5);
insert into Production.Zahteva (zahtev_id, usluga_id, termin, termin_zak, datum_zahtev, zap_mbr, rd_id)
values(9, 7, '16:00', '16:00', '04-29-2020', '0412993735052', 5);
insert into Production.Zahteva (zahtev_id, usluga_id, termin, datum_zahtev)
values(11, 3, '16:00', '04-29-2020');

--12 odgovara semi termin
insert into Production.Zahteva (zahtev_id, usluga_id, termin, datum_zahtev)
values(12, 3, '12:00', '04-29-2020');
insert into Production.Zahteva (zahtev_id, usluga_id, termin, datum_zahtev)
values(12, 6, '12:30', '04-29-2020');
--11 ne ogovara semi termin
insert into Production.Zahteva (zahtev_id, usluga_id, termin, datum_zahtev)
values(11, 6, '18:30', '04-28-2020');
--13 ne odgovara dan, a radan je ili odgovara ali je neradan
insert into Production.Zahteva (zahtev_id, usluga_id, termin, datum_zahtev)
values (13, 2, '13:00', '05-01-2020');
/*select * from Production.Zahteva
where zahtev_id = 9
truncate table Production.Zahteva*/


select * from Production.Usluga
select * from Production.Materijal
insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(3, 2, 50, 'ml');
insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(2, 3, 50, 'ml');
insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(4, 1, 50, 'ml');
insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(3, 4, 50, 'ml');
insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(2, 4, 50, 'ml');
insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(4, 4, 50, 'ml');

insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(5, 1, 50, 'ml');
insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(5, 2, 50, 'ml');
insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(5, 3, 50, 'ml');
insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(5, 4, 50, 'ml');
insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(5, 5, 50, 'ml');
insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(5, 6, 50, 'ml');

insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(6, 1, 50, 'ml');
insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(6, 2, 50, 'ml');
insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(6, 3, 50, 'ml');
insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(6, 4, 50, 'ml');
insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(6, 5, 50, 'ml');
insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(6, 6, 50, 'ml');


insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(7, 1, 50, 'ml');
insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(7, 2, 50, 'ml');
insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(7, 3, 50, 'ml');
insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(7, 4, 50, 'ml');
insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(7, 5, 50, 'ml');
insert into Production.Mat_za (usluga_id, mat_id, normativ,jedinica)
values(7, 6, 50, 'ml');
--select * from Production.Mat_za
--truncate table Production.Mat_za

--select * from Production.Usluga
--select * from Production.Materijal
insert into Production.Se_koristi (zahtev_id,usluga_id,mat_id,kol_potr)
values(9,5,2,50);
insert into Production.Se_koristi (zahtev_id,usluga_id,mat_id,kol_potr)
values(9,7,6,60);
insert into Production.Se_koristi (zahtev_id,usluga_id,mat_id,kol_potr)
values(5,6,3,50);
insert into Production.Se_koristi (zahtev_id,usluga_id,mat_id,kol_potr)
values(6,7,3,50);
--select * from Production.Se_koristi
--truncate table Production.Se_koristi 


/*select mz.usluga_id, mz.mat_id, naziv_usluge, naz_mat
from Production.Mat_za mz
inner join Production.Usluga u on mz.usluga_id = u.usluga_id
inner join Production.Materijal m on mz.mat_id = m.mat_id
order by mz.usluga_id

select * from Production.Usluga
select * from Production.Materijal*/



