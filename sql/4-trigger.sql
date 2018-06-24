#CREATE
#    [DEFINER = { user | CURRENT_USER }]
#    TRIGGER trigger_name
#    trigger_time trigger_event
#    ON tbl_name FOR EACH ROW
#    [trigger_order]
#    trigger_body
#
#trigger_time: { BEFORE | AFTER }
#
#trigger_event: { INSERT | UPDATE | DELETE }
#
#trigger_order: { FOLLOWS | PRECEDES } other_trigger_name
#
#


delimiter $



drop trigger if exists inserimento_pubblicazione_trg;
create trigger inserimento_pubblicazione_trg 
	after insert on Pubblicazione FOR EACH ROW
	begin
	declare var_des varchar(1000);
	declare var_op varchar(250);
	set var_des = concat(' ha inserito la pubblicazione ',NEW.titolo)  ;
	set var_op = 'INSERIMENTO PUBBLICAZIONE';
	call aggiungi_storico(get_id_utente(NEW.rif_inserimento) , NEW.id_pubblicazione , var_des,var_op);
	end $


drop trigger if exists inserimento_metadati_trg;
create trigger inserimento_metadati_trg 
	after insert on Metadati FOR EACH ROW

	begin

		declare var_des varchar(1000);	
		declare var_op varchar(250);
		declare idutente int;
		declare emailutente varchar(250);

		set emailutente = get_email_by_isbn(NEW.isbn);
		set idutente = get_id_utente( emailutente );
		set var_des = concat(	'l\'utente ',emailutente,' ha inserito i metadati per la pubblicazione',get_titolo_pubblicazione( NEW.id_pubblicazione) ,
							 	':edizione->',NEW.edizione ,' data->', NEW.data_pubblicazione,' parole chiave-> ',NEW.parole_chiave,'isbn-> ', 										NEW.isbn ,'num.pagine-> ',NEW.num_pagine ,' lingua->', NEW.lingua , ' abstract-> ' ,  NEW.sinossi ) ;

		set var_op ='INSERIMENTO METADATI';

		call aggiungi_storico ( idutente , NEW.id_pubblicazione , var_des	,var_op );
	end $


drop trigger if exists inserimento_recensione_trg;
create trigger inserimento_recensione_trg
	after insert on Recensione FOR EACH ROW 
	begin
	declare var_des varchar(1000);
	declare var_op varchar(250);
	set var_des = concat('ha inserito la recensione: ',NEW.testo)	;
	set var_op = 'INSERIMENTO RECENSIONE' ;
	call aggiungi_storico ( NEW.id_utente , NEW.id_pubblicazione , var_des ,var_op );
	end $


drop trigger if exists inserimento_gradimento_trg;
create trigger inserimento_gradimento_trg
	after insert on Gradimento FOR EACH ROW 
	begin
	declare var_des varchar(1000);
	declare var_op varchar(250);
	set var_des = 'ha inserito un like ';
	set var_op = 'INSERIMENTO  LIKE';
	call aggiungi_storico ( NEW.id_utente , NEW.id_pubblicazione , var_des	,var_op  );
	end $



delimiter ;
