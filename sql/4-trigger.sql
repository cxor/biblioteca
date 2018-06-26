

	
	
	
#
# Questo script conterrà solo i trigger
#

DELIMITER $

#
# TRIGGER STORICO
#


drop trigger if exists storico_trg;
create trigger storico_trg

	before insert on Storico FOR EACH ROW 
	BEGIN 

		
	if strcmp (NEW.operazione ,'INSERIMENTO PUBBLICAZIONE') <> 0
	
	OR strcmp (NEW.operazione ,'CANCELLAZIONE PUBBLICAZIONE') <> 0 then signal sqlstate '45000' set message_text='Il marcatore non appartiene alle formazioni in gioco';
	
	
	end if ;
	end $


