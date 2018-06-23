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
DROP PROCEDURE IF EXISTS seleziona_pubblicazioni_inserite_da_un_utente ;
CREATE PROCEDURE seleziona_pubblicazioni_inserite_da_un_utente( IN emailutente VARCHAR(100) )
	BEGIN
	select * from Pubblicazione where rif_inserimento = emailutente ;
	END $






# OPERAZIONE 6. Estrazione catalogo, cioè elenco di tutte le pubblicazioni con titolo, autori, editore e anno di pubblicazione, ordinato per titolo.
DROP PROCEDURE IF EXISTS estrazione_catalogo ;
CREATE PROCEDURE estrazione_catalogo()
	BEGIN
 			SELECT Pubblicazione.* , Metadati.isbn , GROUP_CONCAT( concat (Autore.nome , ' ', Autore.cognome) separator ' , ') AS Autori FROM  Pubblicazione
							JOIN Metadati on Pubblicazione.id_pubblicazione = Metadati.id_pubblicazione  
							JOIN Attribuzione on Metadati.isbn = Attribuzione.isbn  
							JOIN Autore on Attribuzione.id_autore = Autore.id_autore GROUP BY Metadati.isbn ;
END $






# OPERAZIONE 7. Estrazione dati completi di una pubblicazione specifica dato il suo ID.
DROP PROCEDURE IF EXISTS estrazione_pubblicazione_dato_id ;
CREATE PROCEDURE estrazione_pubblicazione_dato_id ( IN IDPUBB INT)
	BEGIN
			SELECT Pubblicazione.* , Metadati.isbn , GROUP_CONCAT( concat (Autore.nome , ' ', Autore.cognome) separator ' , ') AS Autori FROM  Pubblicazione
    						JOIN Metadati ON Pubblicazione.id_pubblicazione = Metadati.id_pubblicazione  
							JOIN Attribuzione ON Metadati.isbn = Attribuzione.isbn  
							JOIN Autore ON Attribuzione.id_autore = Autore.id_autore WHERE Pubblicazione.id_pubblicazione = 1 ;
	END $







# OPERAZIONE 8. Ricerca di pubblicazioni per ISBN, titolo, autore, e parole chiave.







# OPERAZIONE 9. Inserimento di una recensione relativa a una pubblicazione.
DROP PROCEDURE IF EXISTS inserimento_recensione ;
CREATE PROCEDURE inserimento_recensione ( IN IDUTENTE INT ,	IDPUBB 	INT,IN TESTO VARCHAR(1000)	)
	BEGIN
		CALL aggiungi_recensione(IDUTENTE ,IDPUBB , TESTO );		
	END $







# OPERAZIONE 10. Approvazione o di una recensione (da parte del moderatore).
DROP PROCEDURE IF EXISTS approva_recensione ;
CREATE PROCEDURE approva_recensione( IN IDPUBB INT , IN IDUTENTE INT )
	BEGIN
		call aggiorna_stato_recensione( IDPUBB , IDUTENTE );
	END $	









# OPERAZIONE 11. Inserimento di un like_ relativo a una pubblicazione.
DROP PROCEDURE IF EXISTS aggiungi_like ;
CREATE PROCEDURE aggiungi_like (IN IDUTENTE INT , IN IDPUBB INT)
	BEGIN
	
		DECLARE all_ok BOOLEAN;
		DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET all_ok = false;
		SET all_ok = true;
		START TRANSACTION;
		CALL aggiungi_gradimento( IDUTENTE , IDPUBB );
		CALL aggiungi_uno_a_like(IDPUBB) ;
		IF NOT all_ok THEN ROLLBACK;
		ELSE COMMIT;
		END IF;		


	END $


#HANDLER PER OPERAZIONE 11
DROP PROCEDURE IF EXISTS aggiungi_uno_a_like ;
CREATE PROCEDURE aggiungi_uno_a_like(IN IDPUBB INT )
	BEGIN
		UPDATE Pubblicazione SET numlike = numlike +1  WHERE id_pubblicazione = IDPUBB ;
	END $







# OPERAZIONE 12. Calcolo numero dei like_ per una pubblicazione.
DROP PROCEDURE IF EXISTS calcolo_numero_like ;
CREATE PROCEDURE calcolo_numero_like ( IN IDPUBB INT )
	BEGIN
		SELECT numlike FROM Pubblicazione WHERE id_pubblicazione = IDPUBB ;
	END $








# OPERAZIONE 13. Estrazione elenco delle recensioni approvate per una pubblicazione.
DROP PROCEDURE IF EXISTS elenco_recensioni_approvate_pubblicazione ;
CREATE PROCEDURE elenco_recensioni_approvate_pubblicazione ( IN IDPUBB INT)
	BEGIN
		SELECT * FROM Recensione WHERE id_pubblicazione = IDPUBB AND stato = 'APPROVATA';
	END $









# OPERAZIONE 14. Estrazione elenco delle recensioni in_ attesa di approvazione.
DROP PROCEDURE IF EXISTS elenco_recensioni_in_attesa ;
CREATE PROCEDURE elenco_recensioni_in_attesa ( )
	BEGIN
		SELECT * FROM Recensione WHERE stato = 'IN ATTESA';
	END $







# OPERAZIONE 15. Estrazione log_ delle modifiche effettuare su una pubblicazione.

# OPERAZIONE 16. Estrazione elenco delle pubblicazioni per le quali è disponibile un download.

# OPERAZIONE 17. Estrazione della lista delle pubblicazioni in_ catalogo, ognuna con la data dell’ultima ristampa 
# utilizzando group_by e order non funziona, cercando sembra che mariadb ignori order_by nellasottoquery -> risolto con limit (chiedere se va bene)
DROP PROCEDURE IF EXISTS elenco_pubblicazioni_ultima_ristampa ;
CREATE PROCEDURE elenco_pubblicazioni_ultima_ristampa()
	BEGIN
		SELECT Pubblicazione.titolo , temp.data_stampa FROM Pubblicazione  
			JOIN Metadati ON Pubblicazione.id_pubblicazione = Metadati.id_pubblicazione  
			JOIN (select * from Versione_Stampa ORDER BY data_stampa LIMIT 123456 )  as temp ON Metadati.isbn = temp.isbn  GROUP BY Pubblicazione.titolo;

				
	END $
	

# OPERAZIONE 18. Data una pubblicazione, restituire tutte le pubblicazioni del catalogo aventi gli stessi autori




