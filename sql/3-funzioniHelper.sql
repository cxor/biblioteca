#funzioni helper per _procedure e _trigger

delimiter $


# funzione che recupera l ID di una pubblicazione dato il titolo ( bisogna aggiustare il titolo _UNIQUE )

drop function if exists get_id_pubblicazione;
create function get_id_pubblicazione( tit_pubb varchar(100) ) returns integer
	READS SQL DATA
	begin
		return ( select id_pubblicazione from Pubblicazione where titolo = tit_pubb );
	end $





# funzione che restituisce l ID di un utente data la mail

drop function if exists get_id_utente;
create function get_id_utente( emailutente varchar(100) ) returns integer
	READS SQL DATA
	begin
		return ( select id_utente from Utente where email = emailutente );
	end $





#funzione che recupera la mail di chi ha inserito un metadato

drop function if exists get_email_by_isbn ;
create function get_email_by_isbn ( var_isbn bigint ) returns varchar(100)
	READS SQL DATA
	begin
		return ( select Pubblicazione.rif_inserimento From Pubblicazione 
						join Metadati on Pubblicazione.id_pubblicazione = Metadati.id_pubblicazione where Metadati.isbn = var_isbn  );	
	end $




#funzione che recupera il titolo di una pubblicazione dato il suo id

drop function if exists get_titolo_pubblicazione;
create function get_titolo_pubblicazione (var_id_pubb int) returns varchar(100)
	READS SQL DATA
	begin
		return ( select titolo from Pubblicazione where id_pubblicazione = var_id_pubb );
	end $



delimiter ;
