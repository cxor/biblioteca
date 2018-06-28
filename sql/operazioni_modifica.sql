

delimiter $


drop procedure if exists  modifica_edizione_metadati;
create procedure modifica_edizione_metadati (in EDI int , in _ISBN BIGINT , in _email varchar(50) )
	
	begin
	if ( check_tipo_utente(_email) <> 0 )
		then						
			call aggiorna_edizione_metadati (EDI,  _ISBN );
			call aggiungi_storico( get_id_utente( _email ) , get_id_pubblicazione_by_isbn( _ISBN ) , 'modificata edizione ' ,'MODIFICA PUBBLICAZIONE');
		end if ;
	end $





drop procedure if exists  modifica_editore_metadati ;
create procedure modifica_editore_metadati (in EDI varchar(50) , in __ISBN BIGINT , in _email varchar(50) )
	
	begin
		if ( check_tipo_utente(_email) <> 0 )
		then
			call aggiorna_editore_metadati(EDI , __ISBN );
			call aggiungi_storico( get_id_utente( _email ) , get_id_pubblicazione_by_isbn( __ISBN ) , 'modificato editore ' ,'MODIFICA PUBBLICAZIONE');
		end if ;
	end $





drop procedure if exists  modifica_data_pubblicazione_metadati ;
create procedure modifica_data_pubblicazione_metadati (in DATAPUBB DATE , in _ISBN BIGINT , in _email varchar(50)  )
	
	begin
		if ( check_tipo_utente(_email) <> 0 )
		then
			call aggiorna_data_pubblicazione_metadati( DATAPUBB,_ISBN );
			call aggiungi_storico( get_id_utente( _email ) , get_id_pubblicazione_by_isbn( _ISBN ) , 'modificata data pubblicazione' ,'MODIFICA PUBBLICAZIONE');
		end if ;
	end $





drop procedure if exists  modifica_parole_chiave_metadati ;
create procedure modifica_parole_chiave_metadati (in PAROLECHIAVE varchar(250) , in _ISBN BIGINT  ,in _email varchar(50) )
	
	begin
		if ( check_tipo_utente(_email) <> 0 )
		then
			call aggiorna_parole_chiave_metadati(PAROLECHIAVE, _ISBN) ;
			call aggiungi_storico( get_id_utente( _email ) , get_id_pubblicazione_by_isbn( _ISBN ) , 'modificate parole chiave' ,'MODIFICA PUBBLICAZIONE');
		end if ;
	end $






drop procedure if exists  modifica_isbn_metadati ;
create procedure modifica_isbn_metadati (in _ISBNNEW int(13), in _ISBN BIGINT ,in _email varchar(50)  )
	
	begin
		if ( check_tipo_utente(_email) <> 0 )
		then
			call aggiorna_isbn_metadati(_ISBNNEW ,_ISBN ) ;
			call aggiungi_storico( get_id_utente( _email ) , get_id_pubblicazione_by_isbn( _ISBN ) , 'modificato isbn' ,'MODIFICA PUBBLICAZIONE');
		end if ;
	end $






drop procedure if exists  modifica_num_pagine_metadati ;
create procedure modifica_num_pagine_metadati (in NUMPAGINE int,in _ISBN BIGINT , in _email varchar(50) )
	
	begin
		if ( check_tipo_utente(_email) <> 0 )
		then
			call aggiorna_num_pagine_metadati(NUMPAGINE , _ISBN );
			call aggiungi_storico( get_id_utente( _email ) , get_id_pubblicazione_by_isbn( _ISBN ) , 'modificato num pagine' ,'MODIFICA PUBBLICAZIONE');
		end if ;
	end $







drop procedure if exists  modifica_lingua_metadati ;
create procedure modifica_lingua_metadati (in LINGUA varchar(250),in _ISBN BIGINT , in _email varchar(50) )
	
	begin
		if ( check_tipo_utente(_email) <> 0 )
		then
			call aggiorna_lingua_metadati( LINGUA , _ISBN);
			call aggiungi_storico( get_id_utente( _email ) , get_id_pubblicazione_by_isbn( _ISBN ) , 'modificata lingua' ,'MODIFICA PUBBLICAZIONE');
		end if ;
	end $







drop procedure if exists  modifica_sinossi_metadati ;
create procedure modifica_sinossi_metadati (in SINOSSI varchar(1000) , in _ISBN BIGINT ,in _email varchar(50)  )
	
	begin
		if ( check_tipo_utente(_email) <> 0 )
		then
			call aggiorna_sinossi_metadati(SINOSSI , _ISBN);
			call aggiungi_storico( get_id_utente( _email ) , get_id_pubblicazione_by_isbn( _ISBN ) , 'modificata sinossi' ,'MODIFICA PUBBLICAZIONE');
		end if ;
	end $






delimiter ;







