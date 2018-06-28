delimiter $

# OPERAZIONE _1. Modifica del livello di un utente (da attivo a passivo e viceversa).
		
# l operazione viene divisa in due procedure 
#		_1)	operazione_permessi -> si occupa di controllare se l utente che la chiama è attivo e di chiamare aggiorna_tipo_utente			
#		_2)	aggiorna_tipo_utente -> effettua l upgrade/downgrade (modifica del tipo) dell utente
#			
# ometto volutamente i controlli sull email se non esiste la mail la query la fallisce per il vincolo referenziale
# e non effettuo il check sul tipo attivo , permetto il downgrade
		
		drop procedure if exists operazione_permessi ;
		create procedure operazione_permessi ( in email_utente varchar(250) , in email_utente_richiedente varchar(250) )
		
			BEGIN
			
				DECLARE err CONDITION FOR SQLSTATE '45000' ;
			
				if ( check_tipo_utente(email_utente_richiedente) <> 0 )
					then
						
						call aggiorna_tipo_utente ( email_utente );
			
					else
							
						SIGNAL err SET MESSAGE_TEXT = 'non si dispongono dei privilegi necessari per effettuare questa operazione ';				
				
				end if ;
				
				

			end $
			
		
		drop procedure if exists aggiorna_tipo_utente ; 
		create procedure aggiorna_tipo_utente (in email_utente varchar(250) )
		
			BEGIN
				
				DECLARE varq varchar(250) ;
		
				set varq =  (select tipo from Utente where email = email_utente );
		
				if  strcmp( varq , 'ATTIVO') = 1
		
				THEN
				
					call aggiorna_tipo_attivo(email_utente);
		
				ELSE
		
					call aggiorna_tipo_passivo(email_utente);
		
				end if;
				
			end $







# OPERAZIONE 2. Estrazione elenco delle ultime dieci pubblicazioni inserite.
#	La procedura è una semplice _select ; avendo aggiunto un attributo data inserimento 
#	ordiniamo il result _set per questa colonna e limitiamo il risultato alle prime 10   
#
		drop procedure if exists seleziona_ultime_dieci_pubblicazioni_inserite ; 
		create procedure seleziona_ultime_dieci_pubblicazioni_inserite( )

			begin
			
				select * from Pubblicazione order by data_inserimento DESC LIMIT 10 ;
	
			end $









# OPERAZIONE 3. Estrazione elenco delle pubblicazioni aggiornate di recente (ultimi 30 giorni)
#				
#		L operazione è basata su una _select dove il valore di data_ultima_modifica deve essere nell intervallo definito da CURRENT_TIMESTAMP - INTERVAL 30 DAY   
#
		drop procedure if exists seleziona_pubblicazioni_ultima_mod_30giorni ; 
		create procedure seleziona_pubblicazioni_ultima_mod_30giorni( )
	
			BEGIN
			
				select * from Pubblicazione where data_ultima_modifica between ( CURRENT_TIMESTAMP - INTERVAL 30 DAY)  and CURRENT_TIMESTAMP ; 
	
			end $









# OPERAZIONE 4. Estrazione elenco degli utenti più “collaborativi” (cioè quelli che hanno inserito più pubblicazioni).
#			
#		 Il parametro "numutenti" è il numero per il limit . Nell operazione non è definito quindi rendo parametrica la query
#

		drop procedure if exists seleziona_utenti_piu_collaborativi ; 
		create procedure seleziona_utenti_piu_collaborativi( in numutenti int )
	
			BEGIN
	
				select * from Utente order by num_inserimenti DESC LIMIT numutenti ;
	
			end $










# OPERAZIONE 5. Estrazione elenco delle pubblicazioni inserite da un utente.
#
#
		drop procedure if exists seleziona_pubblicazioni_inserite_da_un_utente ;
		create procedure seleziona_pubblicazioni_inserite_da_un_utente( in emailutente varchar(250) )
	
		BEGIN
			 select * from Pubblicazione join Storico on Pubblicazione.id_pubblicazione = Storico.id_pubblicazione 
	
				 	where Storico.id_utente  = get_id_utente(emailutente) AND operazione ='INSERIMENTO PUBBLICAZIONE';
		end $






# OPERAZIONE 6. Estrazione catalogo, cioè elenco di tutte le pubblicazioni con titolo, autori, editore e anno di pubblicazione, ordinato per titolo.
#
#			
#
#

		drop procedure if exists estrazione_catalogo ;
		create procedure estrazione_catalogo()
	
		BEGIN
 				select	* from view_pubblicazione_autori order by titolo ;
		end $






# OPERAZIONE 7. Estrazione dati completi di una pubblicazione specifica dato il suo ID.
#
#			query identica alla precedente limitata ad un preciso id_pubblicazione 
#

		drop procedure if exists estrazione_pubblicazione_dato_id ;
		create procedure estrazione_pubblicazione_dato_id ( in IDPUBB int)

		BEGIN

			select	* from view_pubblicazione_autori  where id_pubblicazione = IDPUBB ;

		end $


# OPERAZIONE 8. Ricerca di pubblicazioni per ISBN, titolo, autore, e parole chiave.
#
#			Non posso effettuare le ricerche _in un unica query ISBN è un BIGINT,tutti gl altri sono _varchar
#			Splitto la query _in _2
#					_1) per la ricerca tramite isbn 
#					_2) per tutte le altre passando come parametro il tipo di query desiderata [TITOLO , AUTORE , PAROLECHIAVE ]
#


# Query _1 per ricerca con ISBN

		drop procedure if exists ricerca_per_isbn ;
		create procedure ricerca_per_isbn ( in var_isbn bigint )
		
		begin
		
				select Pubblicazione.titolo from Pubblicazione
							
							join Metadati on Pubblicazione.id_pubblicazione = Metadati.id_pubblicazione
				
							where Metadati.isbn LIKE CONCAT('%', var_isbn , '%') ;  
		
		end $


# Query _2 per le ricerca basate su _varchar
#
# Utilizzo degli if per filtrare il tipo di ricerca e poi eseguo le query con la keyword _LIKE. Così anche se incomplete la ricerca produrrà come risultato
# le pubblicazioni che conterrano la var_search
#

		drop procedure if exists ricerca ;
		create procedure ricerca ( in var_search varchar(50), in var_isbn  BIGINT , in var_autori varchar(50) , in var_titolo varchar(50) )

		BEGIN
		
		
		select * from view_pubblicazione_autori 
		
			where Autori LIKE CONCAT('%', var_autori , '%')  OR Autori LIKE CONCAT('%', var_autori , '%') ;
		
			OR titolo LIKE CONCAT('%', var_titolo , '%') ;
		 
		 	OR parole_chiave LIKE CONCAT('%', var_search , '%') 
		 	
		 	OR isbn LIKE CONCAT('%', var_isbn , '%') ;
		
				
		end $





select * from view_pubblicazione_autori 
		
			where Autore.nome LIKE CONCAT('%', 123 , '%')  OR Autore.cognome LIKE CONCAT('%', 123 , '%') 
		
			OR titolo LIKE CONCAT('%', 123 , '%') 
		 
		 	OR Metadati.parole_chiave LIKE CONCAT('%', 123 , '%') 
		 	
		 	OR Metadati.isbn LIKE CONCAT('%', 123 , '%') ;


# OPERAZIONE 9. Inserimento di una recensione relativa a una pubblicazione.
#					
#



		drop procedure if exists inserimento_recensione ;
		create procedure inserimento_recensione ( in emailutente varchar(250) , in id_pubb int ,in TESTO varchar(1000)	)
		
		BEGIN
			DECLARE all_ok BOOLEAN;
			DECLARE var_descrizione varchar(100);
			DECLARE CONTINUE HANDLER FOR SQLEXCEPTION set all_ok = true;
		
			
		
			START TRANSACTION;
			set var_descrizione = concat(' l utente ',emailutente,' ha inserito una recensione');
			call aggiungi_recensione(get_id_utente(emailutente) , id_pubb, TESTO );	
			call aggiungi_storico( get_id_utente( emailutente ) , id_pubb , var_descrizione ,'INSERIMENTO RECENSIONE');
		
			if NOT all_ok 
			THEN
				ROLLBACK;
			ELSE 
				COMMIT;
			end if;	
		
		end $






# OPERAZIONE 10. Approvazione o di una recensione (da parte del moderatore).
#
#	Questa query è limitata a utenti ATTIVI
#

		drop procedure if exists approva_recensione ;
		create procedure approva_recensione( in IDUTENTE int , in IDPUBB int , in emailutente varchar(250) )

		BEGIN	



			DECLARE all_ok BOOLEAN;

			DECLARE var_descrizione varchar(250);

			DECLARE CONTINUE HANDLER FOR SQLEXCEPTION set all_ok = true;
						
			if ( check_tipo_utente( emailutente ) <> 0 )
			
				then		
			
					START TRANSACTION;
			
					call aggiorna_stato_recensione( IDUTENTE , IDPUBB );	

					set var_descrizione = CONCAT('l utente attivo ', emailutente ,' ha approvato la recensione di ', get_email_by_id(IDUTENTE) );
		
					call aggiungi_storico( get_id_utente( emailutente ) , IDPUBB , var_descrizione ,'MODIFICA RECENSIONE');
				
					if NOT all_ok 
						
						THEN
							
								ROLLBACK;
						ELSE 
							
							COMMIT;

					end if;	
				
			else
							
				select 'non si dispongono dei privilegi necessari per effettuare questa operazione ' as Errore;				
					
			end if ;	
	
				
						
	
	
		end $	









# OPERAZIONE 11. Inserimento di un like_ relativo a una pubblicazione.
#
#	Operazione consentita solo ad utenti attivi . Utilizza un Handler per il plus_one
#
#

		drop procedure if exists aggiungi_like ;
		create procedure aggiungi_like ( in IDPUBB int , in emailutente varchar(250) )
	
		BEGIN
	
			DECLARE all_ok BOOLEAN;

			DECLARE CONTINUE HANDLER FOR SQLEXCEPTION set all_ok = false;

			set all_ok = true;

			START TRANSACTION;
	
			call aggiungi_gradimento( get_id_utente ( emailutente ) , IDPUBB );

			call aggiungi_uno_a_like( IDPUBB ) ;
			
			call aggiungi_storico( get_id_utente ( emailutente ) , IDPUBB , 'l utente ha inserito un like' ,'INSERIMENTO LIKE');

			if NOT all_ok 	
				THEN
					ROLLBACK;
				ELSE 	
					COMMIT;
			end if;				
		end $



#HANDLER PER OPERAZIONE 11
		drop procedure if exists aggiungi_uno_a_like ;
		create procedure aggiungi_uno_a_like(in IDPUBB int )
	
		BEGIN
	
			update Pubblicazione set numlike = numlike + 1  where id_pubblicazione = IDPUBB ;
		
		end $







# OPERAZIONE 12. Calcolo numero dei like_ per una pubblicazione.
		drop procedure if exists calcolo_numero_like ;
		create procedure calcolo_numero_like ( in IDPUBB int )
	
		BEGIN
	
			select numlike from Pubblicazione where id_pubblicazione = IDPUBB ;
	
		end $








# OPERAZIONE 13. Estrazione elenco delle recensioni approvate per una pubblicazione.
		drop procedure if exists elenco_recensioni_approvate_pubblicazione ;
		create procedure elenco_recensioni_approvate_pubblicazione ( in IDPUBB int)
	
		BEGIN
		
			select get_email_by_id(id_utente ) as email , data , testo from Recensione where id_pubblicazione = IDPUBB and stato = 'APPROVATA';
	
		end $







# OPERAZIONE 14. Estrazione elenco delle recensioni in_ attesa di approvazione.
#
#	
#
		drop procedure if exists elenco_recensioni_in_attesa ;
		create procedure elenco_recensioni_in_attesa ( in emailutente varchar(250) )
	
		BEGIN
				
			DECLARE err CONDITION FOR SQLSTATE '45000' ;

			if ( check_tipo_utente(emailutente) <> 0 )

				then
	
					select * from Recensione where stato = 'in ATTESA';

			else
							
					SIGNAL err SET MESSAGE_TEXT = 'non si dispongono dei privilegi necessari per effettuare questa operazione ';				
					
			end if ;	
	
		end $







# OPERAZIONE 15. Estrazione log_ delle modifiche effettuare su una pubblicazione.

		drop procedure if exists log_modifiche;
		create procedure modifica_log(in id_pubb int)
		begin
				select * from Storico where id_pubblicazione = id_pubb and operazione = 'MODIFICA PUBBLICAZIONE';
		end $


# OPERAZIONE 16. Estrazione elenco delle pubblicazioni per le quali è disponibile un download.

		drop procedure if exists pubblicazioni_con_download ;
		create procedure pubblicazioni_con_download()
		
		begin
		
			select * from view_pubblicazione_download ;	
		
		end $


#
# OPERAZIONE 17. Estrazione della lista delle pubblicazioni in_ catalogo, ognuna con la data dell’ultima ristampa 
# 

	drop procedure if exists elenco_pubblicazioni_ultima_ristampa ;
	create procedure elenco_pubblicazioni_ultima_ristampa()

	BEGIN

		select Pubblicazione.titolo , max(Versione_Stampa.data_stampa) From Pubblicazione
		
			JOIN Metadati on Pubblicazione.id_pubblicazione = Metadati.id_pubblicazione 
			
			JOIN Versione_Stampa on Metadati.isbn = Versione_Stampa.isbn GROUP BY Pubblicazione.titolo ;
		
	end $


# OPERAZIONE 18. Data una pubblicazione, restituire tutte le pubblicazioni aventi gli stessi autori
#





	drop procedure if exists elenco_pubblicazioni_stessi_autori_tre ;
	create procedure elenco_pubblicazioni_stessi_autori_tre( in id_pubb int )

	begin

		select * from view_pubblicazione_autori 
			where Autori = ( select Autori from view_pubblicazione_autori where id_pubblicazione =id_pubb ) and id_pubblicazione <> id_pubb ;


	end $





# reimposto il delimiter

delimiter ;
