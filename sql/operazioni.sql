
#
# Questo script contiene delle utility che facilitano l utilizzo di alcune query e alcune procedure utili per la base di dati.
# Non vengono _create su tutte le possibili operazioni ma solo su alcune di quelle che si ritengono più adeguate
#


delimiter $


#
# Immaginando un form di registrazione ha senso unificare i dati di Utente e Anagrafica
# Viene quindi creata una procedura che prende i parametri passati dalla form e "smistati" alle rispettive query 
# aggiungi_utente e aggiungi_anagrafica presenti nel _file delle operazioni CRUD
#

drop procedure if exists login ;
create procedure login ( in var_email varchar(50) , in var_password varchar(50) ,OUT is_correct boolean )
	begin
		
    IF EXISTS(SELECT * FROM Utente WHERE email = var_email AND password = PASSWORD(var_password) ) then
        set is_correct = true;
    ELSE
         set is_correct = false;
    END IF;
		
	end $




drop procedure if exists registrazione ; 
create procedure registrazione 
			(		
				in email_utente 	varchar(250) ,
				in password_utente 	varchar(250) ,
				in _nome  			varchar(250) ,
				in _cognome 		varchar(250) ,
				in _cf 				varchar(250) ,
				in _datadinascita 	DATE		 ,
				in _luogodinascita 	varchar(250) ,
				in _nazione 		varchar(250)
			)
			
			begin
				
				# handler boolena che funziona da guardia _in caso di errore ( inizializzato a true -> passa a false _in caso di SQLExcpetion)
				
				declare all_ok BOOLEAN ;  
				
				declare var_id_utente int ;
				
				declare CONTINUE HANDLER FOR SQLEXCEPTION set all_ok = false;	

				set all_ok = true;

				START TRANSACTION;

				call aggiungi_utente ( email_utente , password_utente );

				set var_id_utente = last_insert_id();

				call aggiungi_anagrafica( var_id_utente , _nome , _cognome , _cf , _datadinascita , _luogodinascita , _nazione );

				if not all_ok 
				
					then ROLLBACK;
				
					else COMMIT;
				
				end if;	

			end $			



# aggiunta pubblicazione
# procedura utilizzata per l inserimento di una pubblicazione che andrà a popolare le tabelle pubblicazione e Metadati

drop procedure if exists inserisci_pubblicazione ;
create procedure inserisci_pubblicazione 
		( 
			in _email				varchar(250) ,
			in _titolo_pubb 		varchar(250) ,
			in _categoria 			varchar(250) ,
			in _edizione			int			 ,
			in _editore				varchar(250) ,
			in _data_pubblicazione	DATE		 ,
			in _parole_chiave		varchar(250) ,
			in _isbn				BIGINT		 ,
			in _numPagine			int			 ,
			in _lingua				varchar(250) ,
			in _sinossi				varchar(1000)
		)
		begin
				
				declare all_ok BOOLEAN ;  
				
				declare _id_utente int ;
				
				declare var_descrizione varchar(100) ;
				
				declare id_pubb int ;
				
				declare CONTINUE HANDLER FOR SQLEXCEPTION set all_ok = false;	

				set all_ok = true;

				START TRANSACTION;

				

					set _id_utente = get_id_utente(_email) ;
					
					call aggiungi_pubblicazione(_titolo_pubb , _categoria  );
					
					set var_descrizione = concat(' l utente ', _email ,' ha inserito una pubblicazione');
		
					
					call aggiorna_num_pubblicazione (_email );
				
					set id_pubb = last_insert_id();
			
					call aggiungi_storico( get_id_utente( _email ) , id_pubb , var_descrizione ,'INSERIMENTO PUBBLICAZIONE');
				
			
				
					call aggiungi_metadati ( id_pubb , _edizione , _editore , _data_pubblicazione , _parole_chiave ,_isbn , _numPagine , _lingua , _sinossi);

					
					
					
						if not all_ok 
				
							then ROLLBACK;
				
						else COMMIT;
				
						end if ;
		end $

#
# procedura per inserire un autore
#


drop procedure if exists inserisci_autore_pubblicazione ;
create procedure inserisci_autore_pubblicazione 
		(
			id_isbn			 	bigint ,
			nome_autore 		varchar(250),
			cognome_autore 		varchar(250)
		)
		begin
		
			declare var_id_autore 	int;

			declare l_id 	int ;
			
			declare all_ok BOOLEAN ;  

			declare CONTINUE HANDLER FOR SQLEXCEPTION set all_ok = false;	

			set all_ok = true;

			START TRANSACTION;
			
			# mi salvo l id dell autore controllo se esiste
			#nel caso procedo solo all attribuzione. Se non esiste inserisco il novo autore e poi inserisco l attribuzione
			
			select id_autore  into var_id_autore from Autore where nome = nome_autore and cognome = cognome_autore ;
			
			if var_id_autore <> 0

				then

					call aggiungi_attribuzione ( id_isbn , var_id_autore ) ;

				else

					call aggiungi_autore ( nome_autore , cognome_autore ) ;

					set l_id = 	last_insert_id();

					call aggiungi_attribuzione ( id_isbn , l_id ) ;

			end if ;
			
			if not all_ok 

				then ROLLBACK;

				else COMMIT;

			end if;		
		
		
		end $










#
# procedura per inserire una  risorsa
#
# tipo e formato sono definiti , quindi 	
# potrebbe andare bene anche passare direttamente id_mediatype ma per sicurezza eseguo la query per recuperare l id e passo entrambi  i parametri 
# tipo e formato
#
# Assumo che uri e id_mediatype identifichino univocaente una risorsa
#


drop procedure if exists inserisci_risorsa_pubblicazione ;
create procedure inserisci_risorsa_pubblicazione
	(
		varemail		varchar(250),
		var_pubb 		int,
		var_uri 		varchar(250),
		var_descrizione varchar(500),
		var_tipo 		varchar(250),
		var_formato 	varchar(250)
	)

	begin

		declare var_storico varchar(100);

		declare var_id_utente	int;

		declare idmediatype int ;

		declare var_risorsa int ;

		declare l_id 		int ;
				
		declare all_ok BOOLEAN ;  
		
		declare CONTINUE HANDLER FOR SQLEXCEPTION set all_ok = false;	
		
		set all_ok = true;
		
		
		START TRANSACTION;
		set var_id_utente = get_id_utente(varemail);
		
		set var_storico = concat('ha inserito una risorsa =>> uri-> ', var_uri , ' , var_descrizione-> ',var_descrizione);
		
		select id_mediatype into idmediatype from Mediatype where tipo = var_tipo and formato =  var_formato ;
		
		select id_risorsa into var_risorsa from Risorse where id_mediatype = idmediatype and uri = var_uri ;
		
		if var_risorsa <>  0
		
			then
				#la risorsa esiste , procedo solo ad associarla con la pubblicazione
			
				call aggiungi_link(var_pubb , var_risorsa );
		
				call aggiungi_storico( var_id_utente , var_pubb , var_storico , 'INSERIMENTO RISORSE' );
		
			else
				# creo la risorsa e la associo 
		
				call aggiungi_risorse( idmediatype , var_uri , var_descrizione);
		
				set l_id = 	last_insert_id();
		
				call aggiungi_link(var_pubb , l_id );
		
				call aggiungi_storico( var_id_utente , var_pubb , var_storico , 'INSERIMENTO RISORSE' );
		end if;
	
		
		
			if not all_ok 

				then ROLLBACK;

				else COMMIT;

			end if;		
		
		
		
		
	end $








#
# procedura per inserimento indice
#

drop procedure if exists inserimento_capitolo ;
create procedure inserimento_capitolo  (	varpubb int , vartitolo varchar(250) , vardescr varchar(250) , varnumcap 	int , varemail varchar(250) )

	begin
		
			declare var_storico varchar(100);

			declare var_id_utente	int;

			declare all_ok BOOLEAN ;  

			declare CONTINUE HANDLER FOR SQLEXCEPTION set all_ok = false;	
	
			set all_ok = true;

			set var_storico = concat('ha inserito il capitolo ' , varnumcap);

			set var_id_utente = get_id_utente(varemail);

			START TRANSACTION;
			
			call aggiungi_capitolo ( varpubb , vartitolo , vardescr , varnumcap ) ;
		
			if not all_ok 

				then

				ROLLBACK ;

				else COMMIT ;

			end if ;

	end $




#
# PROCEDURA per togliere il _like , INVERSA di OPERAZIONE _11
#


		drop procedure if exists cancella_like ;
		create procedure cancella_like ( in IDPUBB int , in emailutente varchar(250) )
	
		BEGIN
	
			declare var_exist int ;
			DECLARE all_ok BOOLEAN;

			DECLARE CONTINUE HANDLER FOR SQLEXCEPTION set all_ok = false;

			set all_ok = true;

			START TRANSACTION;


#devo gestire il caso in cui l utente inserisca più volte la rimozione del gradimento , 
#eseguo un _check , se presente procedo alla rimozione altrimenti nonfaccio nulla	
			
			if (select count(*) as count from Gradimento where id_utente =  get_id_utente ( emailutente ) and id_pubblicazione = IDPUBB ) = 1
			then 
			
			call cancella_gradimento( get_id_utente ( emailutente ) , IDPUBB );


			
			call togli_uno_a_like( IDPUBB ) ;
			
			call aggiungi_storico( get_id_utente ( emailutente ) , IDPUBB , 'l utente ha cancellato un like' ,'CANCELLAZIONE LIKE');
			end if ;
			if NOT all_ok 	
				THEN
					ROLLBACK;
				ELSE 	
					COMMIT;
			end if;				
		end $


#HANDLER PER OPERAZIONE 11 inversa
		drop procedure if exists togli_uno_a_like ;
		create procedure togli_uno_a_like(in IDPUBB int )
	
		BEGIN
	
			update Pubblicazione set numlike = numlike - 1  where id_pubblicazione = IDPUBB ;
		
		end $







#procedura per cancellare una recensione
drop procedure if exists elimina_recensione ;
		create procedure elimina_recensione(in IDPUBB int , in IDUTENTE int , in IDATTIVO int  )
	begin
		
		call cancella_recensione (IDUTENTE , IDPUBB) ;
		
		call aggiungi_storico( IDATTIVO , IDPUBB , 'l utente ha cancellato una recensione' ,'CANCELLAZIONE RECENSIONE');
		
		
	end $










#
# Reimposto il delimitatore
#



delimiter ;




