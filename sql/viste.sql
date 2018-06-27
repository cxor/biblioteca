
drop view if exists view_pubblicazione_autori ;
create view view_pubblicazione_autori as

	
	select pubb.titolo,pubb.categoria  , met.* ,
 				
 							GROUP_CONCAT( concat (Autore.nome , ' ', Autore.cognome) separator ' , ') as Autori from Pubblicazione as pubb

							join Metadati as met on pubb.id_pubblicazione = met.id_pubblicazione  

							join Attribuzione on met.isbn = Attribuzione.isbn  

							join Autore on Attribuzione.id_autore = Autore.id_autore group by met.isbn order by pubb.titolo ;
	
	
	
