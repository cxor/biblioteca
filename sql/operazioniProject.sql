DELIMITER $

# OPERAZIONE 1. Modifica del livello di un utente (da attivo a passivo e viceversa).
DROP PROCEDURE IF EXISTS aggiorna_tipo_utente ; 
CREATE PROCEDURE aggiorna_tipo_utente (IN EMAIL1 VARCHAR(100) )
	BEGIN
		DECLARE varq VARCHAR(10) ;
		SET varq = ( SELECT tipo FROM Utente WHERE email = EMAIL1 ) ;
		IF  strcmp( varq , 'ATTIVO') = 1
		THEN
			select varq ;
			call aggiorna_tipo_attivo(EMAIL1);
		ELSE
			call aggiorna_tipo_passivo(EMAIL1);
		END IF;
		
	END $

# OPERAZIONE 2. Estrazione elenco delle ultime dieci pubblicazioni inserite.

DROP PROCEDURE IF EXISTS seleziona_ultime_dieci_pubblicazioni_inserite ; 
CREATE PROCEDURE seleziona_ultime_dieci_pubblicazioni_inserite( )
	BEGIN
		select * from Pubblicazione order by data_inserimento DESC LIMIT 10 ;
	END $



# OPERAZIONE 3. Estrazione elenco delle pubblicazioni aggiornate di recente (ultimi 30 giorni)
DROP PROCEDURE IF EXISTS seleziona_pubblicazioni_ultima_mod_30giorni ; 
CREATE PROCEDURE seleziona_pubblicazioni_ultima_mod_30giorni( )
	BEGIN
		select * from Pubblicazione where data_ultima_modifica between ( CURRENT_TIMESTAMP - INTERVAL 30 DAY)  AND CURRENT_TIMESTAMP ; 
	END $



# OPERAZIONE 4. Estrazione elenco degli utenti più “collaborativi” (cioè quelli che hanno inserito più pubblicazioni).
DROP PROCEDURE IF EXISTS seleziona_utenti_piu_collaborativi ; 
CREATE PROCEDURE seleziona_utenti_piu_collaborativi( IN numutenti INT )
	BEGIN
		select * from Utente ORDER BY num_inserimenti DESC LIMIT numutenti ;
	END $

# OPERAZIONE 5. Estrazione elenco delle pubblicazioni inserite da un utente.

# OPERAZIONE 6. Estrazione catalogo, cioè elenco di tutte le pubblicazioni con titolo, autori, editore e anno di pubblicazione, ordinato per titolo.

# OPERAZIONE 7. Estrazione dati completi di una pubblicazione specifica dato il suo ID.

# OPERAZIONE 8. Ricerca di pubblicazioni per ISBN, titolo, autore, e parole chiave.

# OPERAZIONE 9. Inserimento di una recensione relativa a una pubblicazione.

# OPERAZIONE 10. Approvazione o di una recensione (da parte del moderatore).

# OPERAZIONE 11. Inserimento di un like_ relativo a una pubblicazione.

# OPERAZIONE 12. Calcolo numero dei like_ per una pubblicazione.

# OPERAZIONE 13. Estrazione elenco delle recensioni approvate per una pubblicazione.

# OPERAZIONE 14. Estrazione elenco delle recensioni in_ attesa di approvazione.

# OPERAZIONE 15. Estrazione log_ delle modifiche effettuare su una pubblicazione.

# OPERAZIONE 16. Estrazione elenco delle pubblicazioni per le quali è disponibile un download.

# OPERAZIONE 17. Estrazione della lista delle pubblicazioni in_ catalogo, ognuna con la data dell’ultima ristampa 

# OPERAZIONE 18. Data una pubblicazione, restituire tutte le pubblicazioni del catalogo aventi gli stessi autori

