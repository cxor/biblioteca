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


drop trigger if exists pubblicazione_trg;
create trigger pubblicazione_trg
after UPDATE on Pubblicazione FOR EACH ROW 
	BEGIN 
		update Pubblicazione set data_ultima_modifica = CURRENT_TIMESTAMP where id_pubblicazione = NEW.id_pubblicazione ;
	end $




delimiter ;
