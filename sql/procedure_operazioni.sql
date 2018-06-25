
delimiter $

# procedura aggiunta utente _in fase di registrazione che andrà a popolorare le tabelle Utente e Anagrafica
# droppo la procedura se già presente e la creo 

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
				
				declare idut int ;
				
				declare CONTINUE HANDLER FOR SQLEXCEPTION set all_ok = false;	

				set all_ok = true;

				START TRANSACTION;

				call aggiungi_utente ( email_utente , password_utente );

				set idut = last_insert_id();

				call aggiungi_anagrafica( idut , _nome , _cognome , _cf , _datadinascita , _luogodinascita , _nazione );

				if not all_ok 
				
					then ROLLBACK;
				
					else COMMIT;
				
				end if;	

			end $			



#aggiunta pubblicazione
# procedura utilizzata per l inserimento di una pubblicazione che andrà a popolare le tabelle pubblicazione e Metadati

drop procedure if exists inserisci_pubblicazione ;
create procedure inserisci_pubblicazione 
		(
			in _titolo_pubb 		varchar(250) ,
			in _categoria 			varchar(250) ,
			in _email_utente 		varchar(250) ,
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
				
				declare idpubb int ;
				
				declare CONTINUE HANDLER FOR SQLEXCEPTION set all_ok = false;	

				set all_ok = true;

				START TRANSACTION;

				call aggiungi_pubblicazione(_titolo_pubb , _categoria , _email_utente );
					
				set idpubb = last_insert_id();
	
				call aggiungi_metadati ( idpubb , _edizione , _editore , _data_pubblicazione , _parole_chiave ,_isbn , _numPagine , _lingua , _sinossi);

				if not all_ok 
				
					then ROLLBACK;
				
					else COMMIT;
				
				end if;	
				
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
		
			declare idaut 	int;

			declare l_id 	int ;
			
			declare all_ok BOOLEAN ;  

			declare CONTINUE HANDLER FOR SQLEXCEPTION set all_ok = false;	

			set all_ok = true;

			START TRANSACTION;
			
			# mi salvo l id dell autore controllo se esiste
			#nel caso procedo solo all attribuzione. Se non esiste inserisco il novo autore e poi inserisco l attribuzione
			
			select id_autore  into idaut from Autore where nome = nome_autore and cognome = cognome_autore ;
			
			if idaut <> 0

				then

					call aggiungi_attribuzione ( id_isbn , idaut ) ;

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

		declare varsto varchar(100);

		declare idut	int;

		declare idmediatype int ;

		declare var_risorsa int ;

		declare l_id 		int ;
				
		declare all_ok BOOLEAN ;  
		
		declare CONTINUE HANDLER FOR SQLEXCEPTION set all_ok = false;	
		
		set all_ok = true;
		
		set idut = get_id_utente(varemail);
		
		set varsto = concat('ha inserito una risorsa =>> uri-> ', var_uri , ' , var_descrizione-> ',var_descrizione);
		
		START TRANSACTION;
		
		# tipo e formatosono definiti , quindi 	
		# potrebbe andare bene anche passare direttamente id_mediatype ma per sicurezza eseguo la query per recuperare l id e passo entrambi  i parametri 
		# tipo e formato
		
		select id_mediatype into idmediatype from Mediatype where tipo = var_tipo and formato =  var_formato ;
		
		select id_risorsa into var_risorsa from Risorse where 	id_mediatype = idmediatype and uri = var_uri ;
		
		if var_risorsa <>  0
		
			then
				#la risorsa esiste , procedo solo ad associarla con la pubblicazione
		
				call aggiungi_link(var_pubb , var_risorsa );
		
			else
				# creo la risorsa e la associo 
		
				call aggiungi_risorse( idmediatype , var_uri , var_descrizione);
		
				set l_id = 	last_insert_id();
		
				call aggiungi_link(var_pubb , l_id );
		
		end if;
		
		call aggiungi_storico( idut , var_pubb , varsto , 'INSERIMENTO RISORSA' );
		
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
		
			declare varsto varchar(100);

			declare idut	int;

			declare all_ok BOOLEAN ;  

			declare CONTINUE HANDLER FOR SQLEXCEPTION set all_ok = false;	
	
			set all_ok = true;

			set varsto = concat('ha inserito il capitolo ' , varnumcap);

			set idut = get_id_utente(varemail);

			START TRANSACTION;
			
			call aggiungi_capitolo ( varpubb , vartitolo , vardescr , varnumcap ) ;
	
			call aggiungi_storico( idut , varpubb , varsto , 'INSERIMENTO CAPITOLO' );
	
			if not all_ok 

				then

				ROLLBACK ;

				else COMMIT ;

			end if ;

	end $

#
# Reimposto il delimitatore
#

delimiter ;




