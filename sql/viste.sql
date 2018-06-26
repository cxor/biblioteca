#
#	viste
#


delimiter $

drop view if exists view_pubblicazione_autori ;
create view view_pubblicazione_autori as

	
	select Pubblicazione.titolo , Metadati.isbn , Metadati.data_pubblicazione ,
 				
 							GROUP_CONCAT( concat (Autore.nome , ' ', Autore.cognome) separator ' , ') as Autori from Pubblicazione

							join Metadati on Pubblicazione.id_pubblicazione = Metadati.id_pubblicazione  

							join Attribuzione on Metadati.isbn = Attribuzione.isbn  

							join Autore on Attribuzione.id_autore = Autore.id_autore group by Metadati.isbn order by Pubblicazione.titolo ;
	
	
	
delimiter ;
