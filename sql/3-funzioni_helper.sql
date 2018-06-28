#
# Questo script definisce alcune utility 
# funzioni helper per _procedure e _trigger
#

#
# Imposto un nuovo delimitatore ,setto a $
#

delimiter $


#
# funzione per _check tipologia utente 
#

drop function if exists check_tipo_utente ;
create function check_tipo_utente ( email_utente varchar(100) ) returns integer
		READS SQL DATA

		
		begin
		
			return (select if ( (select tipo from Utente where email = email_utente) = 'ATTIVO', 1 , 0 ) ) ;
		
		end $


drop function if exists check_tipo_id_utente ;
create function check_tipo_id_utente ( idUtente int ) returns integer
		READS SQL DATA

		begin
		
			return (select if ( (select tipo from Utente where id_utente = idUtente) = 'ATTIVO', 1 , 0 ) ) ;
		
		end $






# funzione che recupera l ID di una pubblicazione dato il titolo 


drop function if exists get_id_pubblicazione;
create function get_id_pubblicazione( tit_pubb varchar(100) ) returns integer
		READS SQL DATA

		begin

			return ( select id_pubblicazione from Pubblicazione where titolo = tit_pubb );

		end $


#funzione che dato isbn ritorna l id_pubblicazione associato

drop function if exists get_id_pubblicazione_by_isbn ;
create function	get_id_pubblicazione_by_isbn (id_isbn varchar(250) ) returns integer
		READS SQL DATA

		begin

			return (select id_pubblicazione from Metadati where isbn = id_isbn );

		end $





# funzione che restituisce l ID di un utente data la mail

drop function if exists get_id_utente;
create function get_id_utente( emailutente varchar(100) ) returns integer
		READS SQL DATA

		begin

			return ( select id_utente from Utente where email = emailutente );

		end $





#funzione che recupera la mail di chi ha inserito un metadato

drop function if exists get_email_by_id ;
create function get_email_by_id ( var_id bigint ) returns varchar(100)
		READS SQL DATA

		begin

			return ( select email From Utente where  id_utente = var_id );	
	
		end $




#funzione che recupera il titolo di una pubblicazione dato il suo id

drop function if exists get_titolo_pubblicazione;
create function get_titolo_pubblicazione (var_id_pubb int) returns varchar(100)
		READS SQL DATA
	
		begin
	
			return ( select titolo from Pubblicazione where id_pubblicazione = var_id_pubb );

		end $



#
# Reimposto il delimitatore originale
#
delimiter ;
