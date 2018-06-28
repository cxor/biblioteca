#
# Questo script conterrà solo i _trigger
#
DELIMITER $

#
# TRIGGER STORICO
#
#--	Questo trigger controlla che l operazione inserita sia conforme a quelle permesse come descritto nella documentazione
#


drop trigger if exists storico_trg;
create trigger storico_trg

	before insert on Storico FOR EACH ROW 
	BEGIN 

		
	if ( select   ( strcmp (NEW.operazione ,'INSERIMENTO PUBBLICAZIONE') = 0 
		     	 OR strcmp ( NEW.operazione,'CANCELLAZIONE PUBBLICAZIONE') = 0
				 OR strcmp ( NEW.operazione,'MODIFICA PUBBLICAZIONE') = 0
		 		 OR strcmp ( NEW.operazione,'INSERIMENTO RECENSIONE') = 0 
		 		 OR strcmp ( NEW.operazione,'CANCELLAZIONE RECENSIONE') = 0
			     OR strcmp ( NEW.operazione,'MODIFICA RECENSIONE') = 0 
			     OR strcmp ( NEW.operazione,'INSERIMENTO RISORSE') = 0 
		 		 OR strcmp ( NEW.operazione,'CANCELLAZIONE RISORSE') = 0
			     OR strcmp ( NEW.operazione,'MODIFICA RISORSE') = 0 
	    		 OR strcmp ( NEW.operazione,'INSERIMENTO LIKE') = 0
 				 OR strcmp ( NEW.operazione,'CANCELLAZIONE LIKE') = 0		
       			  )
		 =  0 )
		 	then 
				signal sqlstate '45000' set message_text='operazione non consentita';
	
			end if ;
	end $




# TRIGGER RECENSIONE
# Una recensione è inserita da un utente attivo non necessita di essere moderata. Viene quindi aggiornato immediatamente lo stato in 'APPROVATA'
#
#

drop trigger if exists recensione_trg;
create trigger recensione_trg
before insert on Recensione FOR EACH ROW 
	BEGIN 

		if ( check_tipo_id_utente(NEW.id_utente) <> 0 )
		then
			set NEW.stato = 'APPROVATA' ;
		end if;
	end $


#
# -- Trigger anagrafica -> La data di Nascita non può essere superiore alla data odierna
#

drop trigger if exists anagrafica_trg;
create trigger anagrafica_trg
before insert on Anagrafica FOR EACH ROW 
	BEGIN 

	DECLARE err CONDITION FOR SQLSTATE '45000' ;
			
		if New.data_nascita > NOW()
		then
			SIGNAL err SET MESSAGE_TEXT = 'la data inserita non è valida ';
		end if;
	end $



#trigger pubblicazione che aggiorna la data dell ultima modifica 


drop trigger if exists modifica_pubblicazione_trg;
create trigger modifica_pubblicazione_trg 
before UPDATE on Pubblicazione FOR EACH ROW 
	BEGIN 
		 set NEW.data_ultima_modifica = CURRENT_TIMESTAMP ;
	end $
	
	

-- le categorie che vengono supportate dalla base di dati sono limitate a  TESI , REPORT , ARTICOLO , LIBRO
drop trigger if exists insert_pubblicazione_trg;
create trigger insert_pubblicazione_trg 
before INSERT on Pubblicazione FOR EACH ROW 
	BEGIN 
	if ( select   ( strcmp (NEW.categoria ,'TESI') = 0 
		     	 OR strcmp ( NEW.categoria,'REPORT') = 0
				 OR strcmp ( NEW.categoria,'ARTICOLO') = 0
		 		 OR strcmp ( NEW.categoria,'LIBRO') = 0 
		 		
       			  )
		 =  0 )
		 	then 
				signal sqlstate '45000' set message_text='categoria non consentita';
	
			end if ;
	end $



drop trigger if exists versione_stampa_trg;
create trigger versione_stampa_trg 
before INSERT on Versione_Stampa FOR EACH ROW 
	begin
		declare var_date date ;	
		
		declare maxdate date ;	
		
		select data_pubblicazione into var_date from Metadati where isbn = NEW.isbn ;
		select max(data_stampa) into maxdate from Versione_Stampa where isbn = NEW.isbn ;
		if NEW.data_stampa < var_date
			then
				signal sqlstate '45000' set message_text='errore : la data della stampa non può essere inferiore a quella di pubblicazione ';
		end if ;
		 
	
		if NEW.data_stampa < maxdate
			then
				signal sqlstate '45000' set message_text='errore : la data dell ultima stampa inserita  ';
		end if ;
	end $


delimiter ;
