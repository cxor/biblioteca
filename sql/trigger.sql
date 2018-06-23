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
	call aggiungi_storico(get_id_utente(NEW.rif_inserimento) , NEW.id_pubblicazione , concat(' ha inserito la pubblicazione ',NEW.titolo) ,'INSERIMENTO PUBBLICAZIONE');
	end $


drop trigger if exists inserimento_metadati_trg;
create trigger inserimento_metadati_trg 
	after insert on Metadati FOR EACH ROW
	begin
	declare var_stringa varchar(1000);	
	declare idutente int;
	declare emailutente varchar(100);
	set emailutente = get_email_by_isbn(NEW.isbn);
	set idutente = get_id_utente( emailutente );
	set var_stringa = concat (concat('ed->',NEW.edizione ,' data->',NEW.data_pubblicazione ),     
	concat('par->',NEW.parole_chiave,'isbn>',NEW.isbn ,'num.pag>',NEW.num_pagine ,'lin->', NEW.lingua , 'sin->' ,  NEW.sinossi )) ;

	#da aggiustare non prende tutta la stringa 

	call aggiungi_storico ( idutente , NEW.id_pubblicazione , var_stringa	,'INSERIMENTO METADATI'  );
	end $

drop trigger if exists inserimento_recensione_trg;
create trigger inserimento_recensione_trg
	after insert on Recensione FOR EACH ROW 
	begin
	call aggiungi_storico ( NEW.id_utente , NEW.id_pubblicazione , concat('ha inserito la recensione: ',NEW.testo)	,'INSERIMENTO RECENSIONE'  );
	end $


drop trigger if exists inserimento_gradimento_trg;
create trigger inserimento_gradimento_trg
	after insert on Gradimento FOR EACH ROW 
	begin
	call aggiungi_storico ( NEW.id_utente , NEW.id_pubblicazione , 'ha inserito un like '	,'INSERIMENTO RECENSIONE'  );
	end $



delimiter ;
