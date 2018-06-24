delimiter $

# OPERAZIONE 1. Modifica del livello di un utente (da attivo a passivo e viceversa).
drop procedure if exists aggiorna_tipo_utente ; 
create procedure aggiorna_tipo_utente (in email_utente varchar(100) )
	BEGIN
		
		DECLARE varq varchar(10) ;
		set varq = get_id_utente( email_utente);
		if  strcmp( varq , 'ATTIVO') = 1
		THEN
			select varq ;
			call aggiorna_tipo_attivo(email_utente);
		ELSE
			call aggiorna_tipo_passivo(email_utente);
		end if;
		
	end $







# OPERAZIONE 2. Estrazione elenco delle ultime dieci pubblicazioni inserite.

drop procedure if exists seleziona_ultime_dieci_pubblicazioni_inserite ; 
create procedure seleziona_ultime_dieci_pubblicazioni_inserite( )
	BEGIN
		select * from Pubblicazione order by data_inserimento DESC LIMIT 10 ;
	end $









# OPERAZIONE 3. Estrazione elenco delle pubblicazioni aggiornate di recente (ultimi 30 giorni)

drop procedure if exists seleziona_pubblicazioni_ultima_mod_30giorni ; 
create procedure seleziona_pubblicazioni_ultima_mod_30giorni( )
	BEGIN
		select * from Pubblicazione where data_ultima_modifica between ( CURRENT_TIMESTAMP - INTERVAL 30 DAY)  and CURRENT_TIMESTAMP ; 
	end $













# OPERAZIONE 4. Estrazione elenco degli utenti più “collaborativi” (cioè quelli che hanno inserito più pubblicazioni).
# par numutenti è il numero per il limit nell operazione non è definito

drop procedure if exists seleziona_utenti_piu_collaborativi ; 
create procedure seleziona_utenti_piu_collaborativi( in numutenti int )
	BEGIN
		select * from Utente order by num_inserimenti DESC LIMIT numutenti ;
	end $










# OPERAZIONE 5. Estrazione elenco delle pubblicazioni inserite da un utente.
drop procedure if exists seleziona_pubblicazioni_inserite_da_un_utente ;
create procedure seleziona_pubblicazioni_inserite_da_un_utente( in emailutente varchar(100) )
	BEGIN
	select * from Pubblicazione where rif_inserimento = emailutente ;
	end $






# OPERAZIONE 6. Estrazione catalogo, cioè elenco di tutte le pubblicazioni con titolo, autori, editore e anno di pubblicazione, ordinato per titolo.
drop procedure if exists estrazione_catalogo ;
create procedure estrazione_catalogo()
	BEGIN
 			select Pubblicazione.* , Metadati.isbn , GROUP_CONCAT( concat (Autore.nome , ' ', Autore.cognome) separator ' , ') as Autori from  Pubblicazione
							join Metadati on Pubblicazione.id_pubblicazione = Metadati.id_pubblicazione  
							join Attribuzione on Metadati.isbn = Attribuzione.isbn  
							join Autore on Attribuzione.id_autore = Autore.id_autore group by Metadati.isbn order by Pubblicazione.titolo ;
end $






# OPERAZIONE 7. Estrazione dati completi di una pubblicazione specifica dato il suo ID.
drop procedure if exists estrazione_pubblicazione_dato_id ;
create procedure estrazione_pubblicazione_dato_id ( in IDPUBB int)
	BEGIN
			select Pubblicazione.* , Metadati.isbn , GROUP_CONCAT( concat (Autore.nome , ' ', Autore.cognome) separator ' , ') as Autori from  Pubblicazione
    						join Metadati on Pubblicazione.id_pubblicazione = Metadati.id_pubblicazione  
							join Attribuzione on Metadati.isbn = Attribuzione.isbn  
							join Autore on Attribuzione.id_autore = Autore.id_autore where Pubblicazione.id_pubblicazione = 1 ;
	end $







# OPERAZIONE 8. Ricerca di pubblicazioni per ISBN, titolo, autore, e parole chiave.



# OPERAZIONE 9. Inserimento di una recensione relativa a una pubblicazione.
drop procedure if exists inserimento_recensione ;
create procedure inserimento_recensione ( in emailutente varchar(100) , in titolopubb varchar(100) ,in TESTO varchar(1000)	)
	BEGIN
		call aggiungi_recensione(get_id_utente(emailutente) , get_id_pubblicazione(titolopubb) , TESTO );		
	end $







# OPERAZIONE 10. Approvazione o di una recensione (da parte del moderatore).
drop procedure if exists approva_recensione ;
create procedure approva_recensione( in IDPUBB int , in IDUTENTE int )
	BEGIN
		call aggiorna_stato_recensione( IDPUBB , IDUTENTE );
	end $	









# OPERAZIONE 11. Inserimento di un like_ relativo a una pubblicazione.
drop procedure if exists aggiungi_like ;
create procedure aggiungi_like (in IDUTENTE int , in IDPUBB int)
	BEGIN
	
		DECLARE all_ok BOOLEAN;
		DECLARE CONTINUE HANDLER FOR SQLEXCEPTION set all_ok = false;
		set all_ok = true;
		START TRANSACTION;
		call aggiungi_gradimento( IDUTENTE , IDPUBB );
		call aggiungi_uno_a_like(IDPUBB) ;
		if NOT all_ok THEN ROLLBACK;
		ELSE COMMIT;
		end if;		


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
drop procedure if exists elenco_recensioni_in_attesa ;
create procedure elenco_recensioni_in_attesa ( )
	BEGIN
		select * from Recensione where stato = 'in ATTESA';
	end $







# OPERAZIONE 15. Estrazione log_ delle modifiche effettuare su una pubblicazione.

# OPERAZIONE 16. Estrazione elenco delle pubblicazioni per le quali è disponibile un download.

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




