delimiter $

# OPERAZIONE _1. Modifica del livello di un utente (da attivo a passivo e viceversa).
		
# l operazione viene divisa in due procedure 
#		_1)	operazione_permessi -> si occupa di controllare se l utente che la chiama è attivo e di chiamare aggiorna_tipo_utente			
#		_2)	aggiorna_tipo_utente -> effettua l upgrade/downgrade (modifica del tipo) dell utente
#			
# ometto volutamente i controlli sull email se non esiste la mail la query la fallisce
		
		drop procedure if exists operazione_permessi ;
		create procedure operazione_permessi ( in email_utente varchar(250) , in email_utente_richiedente varchar(250) )
		
			BEGIN
			
				DECLARE err CONDITION FOR SQLSTATE '45000' ;
			
			
				declare all_ok BOOLEAN ;  

				declare CONTINUE HANDLER FOR SQLEXCEPTION set all_ok = false;	
	
				set all_ok = true;
	
			
				if ( check_tipo_utente(email_utente_richiedente) <> 0 )
					then
			
						call aggiorna_tipo_utente ( email_utente );
			
					else
							
						SIGNAL err SET MESSAGE_TEXT = 'non si dispongono dei privilegi necessari per effettuare questa operazione ';				
						
				
				end if ;
				
				if not all_ok 

					then

						ROLLBACK ;

				else 
					
					COMMIT ;

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
		
			select * from Pubblicazione where rif_inserimento = emailutente ;
		
		end $






# OPERAZIONE 6. Estrazione catalogo, cioè elenco di tutte le pubblicazioni con titolo, autori, editore e anno di pubblicazione, ordinato per titolo.
#
#			Per visualizzare la lista degli autori come una colonna utilizziamo GROUP_CONCAT con sintassi [ nome autore cognome autore] , ... []	
#
#

		drop procedure if exists estrazione_catalogo ;
		create procedure estrazione_catalogo()
	
		BEGIN
 	
 				select Pubblicazione.titolo , Metadati.isbn , Metadati.data_pubblicazione ,
 				
 							GROUP_CONCAT( concat (Autore.nome , ' ', Autore.cognome) separator ' , ') as Autori from Pubblicazione

							join Metadati on Pubblicazione.id_pubblicazione = Metadati.id_pubblicazione  

							join Attribuzione on Metadati.isbn = Attribuzione.isbn  

							join Autore on Attribuzione.id_autore = Autore.id_autore group by Metadati.isbn order by Pubblicazione.titolo ;

		end $






# OPERAZIONE 7. Estrazione dati completi di una pubblicazione specifica dato il suo ID.
#
#			query identica alla precedente limitata ad un preciso id_pubblicazione 
#

		drop procedure if exists estrazione_pubblicazione_dato_id ;
		create procedure estrazione_pubblicazione_dato_id ( in IDPUBB int)

		BEGIN

			select Pubblicazione.titolo , Metadati.isbn , GROUP_CONCAT( concat (Autore.nome , ' ', Autore.cognome) separator ' , ') as Autori from  Pubblicazione

    						join Metadati on Pubblicazione.id_pubblicazione = Metadati.id_pubblicazione  

							join Attribuzione on Metadati.isbn = Attribuzione.isbn  

							join Autore on Attribuzione.id_autore = Autore.id_autore where Pubblicazione.id_pubblicazione = 1 ;

		end $







# OPERAZIONE 8. Ricerca di pubblicazioni per ISBN, titolo, autore, e parole chiave.
#
#			Non posso effettuare le ricerche _in un unica query ISBN è un BIGINT,tutti gl altri sono _varchar
#
#			Splitto la query _in _2
#					_1) per la ricerca tramite isbn 
#					_2) per tutte le altre
#


# Query _1 per ricerca con ISBN

		drop procedure if exists ricerca_per_isbn ;
		create procedure ricerca_per_isbn ( in var_isbn bigint )
		
		begin
		
				select * from Pubblicazione
							
							join Metadati on Pubblicazione.id_pubblicazione = Metadati.id_pubblicazione
				
							where Metadati.isbn LIKE CONCAT('%', var_isbn , '%') ;  
		
		end $


# Query _2 per le ricerca basate su _varchar
#
# Utilizzo degli if per filtrare il tipo di ricerca e poi eseguo le query con la keyword _LIKE. Così anche se incomplete la ricerca produrrà come risultato
# le pubblicazioni che conterrano la var_search
#

		drop procedure if exists ricerca ;
		create procedure ricerca ( in var_search varchar(250) , var_tipo varchar(20))

		BEGIN
		
				DECLARE err CONDITION FOR SQLSTATE '45000' ;
		
				if strcmp( var_tipo , 'TITOLO') = 0
				
				then
				
						select titolo From Pubblicazione where titolo LIKE CONCAT('%', var_search , '%') ;
				
				elseif  strcmp( var_tipo , 'AUTORE') = 0 then
				
						#effettua la ricerca per autore
				
						select Pubblicazione.titolo , Metadati.isbn ,Autore.nome , Autore.cognome from Pubblicazione 
							
								join Metadati on Pubblicazione.id_pubblicazione = Metadati.id_pubblicazione
								
								join Attribuzione on Metadati.isbn = Attribuzione.isbn
								
								join Autore on Attribuzione.id_autore = Autore.id_autore
								
								where Autore.nome LIKE CONCAT('%', var_search , '%')  OR Autore.cognome LIKE CONCAT('%', var_search , '%') ;
														
				elseif 	strcmp( var_tipo , 'PAROLECHIAVE') = 0 then
				
						#effettua la ricerca per parole chiave
				
						select Pubblicazione.titolo , Metadati.isbn from Pubblicazione 
						
								join Metadati on Pubblicazione.id_pubblicazione = Metadati.id_pubblicazione 
								
								where Metadati.parole_chiave LIKE CONCAT('%', var_search , '%') ;

				else
						#errore_ricerca nel caso il parametro non si _in [ TITOLO , AUTORE , PAROLECHIAVE ]

						SIGNAL err SET MESSAGE_TEXT = 'errore ricerca , parametro di filtraggio non riconosciuto ';

				end if ;	
		end $





# OPERAZIONE 9. Inserimento di una recensione relativa a una pubblicazione.
#					Questa operazione è permessa solo a utenti attivi
#



		drop procedure if exists inserimento_recensione ;
		create procedure inserimento_recensione ( in emailutente varchar(250) , in titolopubb varchar(250) ,in TESTO varchar(1000)	)

		BEGIN

			DECLARE err CONDITION FOR SQLSTATE '45000' ;

			if ( check_tipo_utente(emailutente) <> 0 )

					then
			
						call aggiungi_recensione(get_id_utente(emailutente) , get_id_pubblicazione(titolopubb) , TESTO );	
			
					else
							
						SIGNAL err SET MESSAGE_TEXT = 'non si dispongono dei privilegi necessari per effettuare questa operazione ';				
						
				
				end if ;			

		end $







# OPERAZIONE 10. Approvazione o di una recensione (da parte del moderatore).
#
#	Questa query è limitata a utenti ATTIVI
#

		drop procedure if exists approva_recensione ;
		create procedure approva_recensione( in IDPUBB int , in IDUTENTE int , in emailutente varchar(250) )

		BEGIN	

			DECLARE err CONDITION FOR SQLSTATE '45000' ;

			if ( check_tipo_utente(emailutente) <> 0 )

				then
	
				call aggiorna_stato_recensione( IDPUBB , IDUTENTE );	

			else
							
				SIGNAL err SET MESSAGE_TEXT = 'non si dispongono dei privilegi necessari per effettuare questa operazione ';				
					
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
	
			DECLARE IDUTENTE int ;
	
			DECLARE all_ok BOOLEAN;

			DECLARE err CONDITION FOR SQLSTATE '45000' ;

			DECLARE CONTINUE HANDLER FOR SQLEXCEPTION set all_ok = false;

		

				if ( check_tipo_utente(emailutente) <> 0 )

					then
		
						set all_ok = true;

						START TRANSACTION;
		
						set IDUTENTE = get_id_utente ( emailutente );

						call aggiungi_gradimento( IDUTENTE , IDPUBB );

						call aggiungi_uno_a_like(IDPUBB) ;

						if NOT all_ok 
						
							THEN
							
							ROLLBACK;

						ELSE 
							
							COMMIT;

						end if;		

					else
								
						SIGNAL err SET MESSAGE_TEXT = 'non si dispongono dei privilegi necessari per effettuare questa operazione ';				
						
				end if ;

			end $


#HANDLER PER OPERAZIONE 11
		drop procedure if exists aggiungi_uno_a_like ;
		create procedure aggiungi_uno_a_like(in IDPUBB int )
	
		BEGIN
	
			update Pubblicazione set numlike = numlike +1  where id_pubblicazione = IDPUBB ;
		
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
		
			select * from Recensione where id_pubblicazione = IDPUBB and stato = 'APPROVATA';
	
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





# OPERAZIONE 16. Estrazione elenco delle pubblicazioni per le quali è disponibile un download.

		drop procedure if exists pubblicazioni_con_download ;
		create procedure pubblicazioni_con_download()
		
		begin
		
			select * from Pubblicazione 
					
					join Link on Pubblicazione.id_pubblicazione = Link.id_pubblicazione
					
					join Risorse on Link.id_risorsa = Risorse.id_risorsa
					
					join Mediatype on Risorse.id_mediatype = Mediatype.id_mediatype
					
						where Mediatype.tipo = 'DOWNLOAD' ; 		
		
		end $



# OPERAZIONE 17. Estrazione della lista delle pubblicazioni in_ catalogo, ognuna con la data dell’ultima ristampa 
# utilizzando group_by e order non funziona, cercando sembra che mariadb ignori order_by nellasottoquery -> risolto con limit (chiedere se va bene)

	drop procedure if exists elenco_pubblicazioni_ultima_ristampa ;
	create procedure elenco_pubblicazioni_ultima_ristampa()

	BEGIN

		select Pubblicazione.titolo , temp.data_stampa from Pubblicazione  

			join Metadati on Pubblicazione.id_pubblicazione = Metadati.id_pubblicazione  

			join (select * from Versione_Stampa order by data_stampa LIMIT 123456 )  as temp on Metadati.isbn = temp.isbn  group by Pubblicazione.titolo;
				
	end $
	

# OPERAZIONE 18. Data una pubblicazione, restituire tutte le pubblicazioni del catalogo aventi gli stessi autori





