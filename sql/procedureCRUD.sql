delete from mysql.proc where db = 'BIBLIOTECA';
#
# DELIMITATORE
#

DELIMITER $

#
#	PROCEDURE INSERIMENTO , CANC , E AGGIORNAMENTO TABELLA UTENTE
#


CREATE PROCEDURE aggiungi_utente( IN EMAILUTENTE VARCHAR(100), IN PASSWD VARCHAR(100) ) 
	BEGIN
		INSERT INTO Utente(email,password) VALUE ( EMAILUTENTE,PASSWORD(PASSWD) );
	END $ 


CREATE PROCEDURE cancella_utente(IN EMAILUTENTE VARCHAR(100) )
	BEGIN
		DELETE FROM Utente where email = EMAILUTENTE ;
	END $


CREATE PROCEDURE aggiorna_email (IN EMAILVECCHIA VARCHAR(100) , IN EMAILNUOVA VARCHAR(100) )
	BEGIN
		UPDATE Utente SET email = EMAILNUOVA WHERE email = EMAILVECCHIA ;
	END $

CREATE PROCEDURE aggiorna_password(IN PASSWORD VARCHAR(100) , IN EMAILUTENTE VARCHAR(100) )
	BEGIN
		UPDATE Utente SET password = PASSWORD WHERE email = EMAILUTENTE ;
	END $

CREATE PROCEDURE aggiorna_tipo_attivo( IN EMAILUTENTE VARCHAR(100) )
	BEGIN 
		UPDATE Utente SET tipo = 'ATTIVO' WHERE email = EMAILUTENTE ;
	END $

CREATE PROCEDURE aggiorna_tipo_passivo( IN EMAILUTENTE VARCHAR(100) )
	BEGIN 
		UPDATE Utente SET tipo = 'PASSIVO' WHERE email = EMAILUTENTE ;
	END $


CREATE PROCEDURE aggiorna_tipo( IN EMAILUTENTE VARCHAR(100) , IN TIPO VARCHAR(10) )
	BEGIN 
		UPDATE Utente SET tipo = TIPO WHERE email = EMAILUTENTE ;
	END $



#
#	PROCEDURE CRUD ANAGRAFICA
#

CREATE PROCEDURE aggiungi_anagrafica 

(
	IN IDUTENTE INT,
	IN NOME  VARCHAR(100),
	IN COGNOME VARCHAR(100),
	IN CF VARCHAR(100),
	IN DATADINASCITA DATE,
	IN LUOGODINASCITA VARCHAR(100),
	IN NAZIONE VARCHAR(100)
)

	BEGIN
		INSERT INTO Anagrafica VALUE (IDUTENTE,NOME,COGNOME,CF,DATADINASCITA,LUOGODINASCITA,NAZIONE) ;
	END $	





CREATE PROCEDURE cancella_anagrafica ( IN IDUTENTE INT )
	BEGIN
	DELETE FROM Anagrafica WHERE id_utente = IDUTENTE ;
	END $


#PROCEDURE PER AGGIORNAMENTO

#UPDATE NOME

CREATE PROCEDURE aggiorna_nome (IN NUOVONOME VARCHAR(100) , IN IDUTENTE INT )
	BEGIN
	UPDATE Anagrafica SET nome= NUOVONOME WHERE id_utente = IDUTENTE ;
	END $


#UPDATE COGNOME

CREATE PROCEDURE aggiorna_cognome(IN NUOVOCOGNOME VARCHAR(100), IN IDUTENTE INT)
	BEGIN
        UPDATE Anagrafica SET cognome= NUOVOCOGNOME WHERE id_utente = IDUTENTE ;
        END $


#UPDATE CODICE FISCALE

CREATE PROCEDURE aggiorna_cf ( IN NUOVOCF VARCHAR(100) , IN IDUTENTE INT )
        BEGIN
        UPDATE Anagrafica SET cf = NUOVOCF WHERE id_utente = IDUTENTE ;
        END $


#UPDATE DATA DI NASCITA

CREATE PROCEDURE aggiorna_data_nascita (IN NUOVADATA Date, IN IDUTENTE INT )
        BEGIN
        UPDATE Anagrafica SET data_nascita= NUOVADATA WHERE id_utente = IDUTENTE ;
        END $


#UPDATE LUOGO DI NASCITA

CREATE PROCEDURE aggiorna_luogo_nascita(IN NUOVOLUOGO VARCHAR(100), IN IDUTENTE INT)
        BEGIN
        UPDATE Anagrafica SET luogo_nascita = NUOVOLUOGO WHERE id_utente = IDUTENTE;
        END $


#UPDATE NAZIONE
CREATE PROCEDURE aggiorna_nazionalita (IN NUOVANAZIONE VARCHAR(100), IN IDUTENTE INT)
        BEGIN
        UPDATE Anagrafica SET nazionalita = NUOVANAZIONE WHERE id_utente = IDUTENTE ;
        END $


#
#PROCEDURE PUBBLICAZIONE
#

CREATE PROCEDURE aggiungi_pubblicazione 
	(
	IN TITOLO VARCHAR(100) ,
	IN CATEG  VARCHAR(100) ,
	IN RIF 	  VARCHAR(100)
	)
	
	BEGIN
		INSERT INTO Pubblicazione (titolo, categoria , rif_inserimento )VALUE ( TITOLO , CATEG , RIF );
	END $


CREATE PROCEDURE cancella_pubblicazione (IN IDPUBB INT )
	BEGIN
		DELETE FROM Pubblicazione WHERE id_pubblicazione = IDPUBB ; 
	END $


CREATE PROCEDURE aggiorna_titolo   (IN IDPUBB INT , IN STRNG VARCHAR(100))
	BEGIN
		UPDATE Pubblicazione SET titolo = STRNG WHERE id_pubblicazione = IDPUBB ; 
	END $

CREATE PROCEDURE aggiorna_categoria(IN IDPUBB INT , IN STRNG VARCHAR(100))
	BEGIN
		UPDATE Pubblicazione SET categoria = STRNG WHERE id_pubblicazione = IDPUBB ; 
	END $

#
#	PROCEDURE METADATI
#

CREATE PROCEDURE aggiungi_metadati 
	(
		IN IDPUBB 			INT,
		IN EDIZIONE			INT,
		IN EDITORE			VARCHAR(50),
		IN DATAPUBB 		DATE,
		IN PAROLECHIAVE		VARCHAR(200),
		IN ISBN				BIGINT,
		IN NUMPAGINE		INT,
		IN LINGUA			VARCHAR(50),
		IN SINOSSI			VARCHAR(1000)
	)

	BEGIN
		INSERT INTO Metadati VALUE (IDPUBB, EDIZIONE ,EDITORE,DATAPUBB ,PAROLECHIAVE ,ISBN ,NUMPAGINE ,LINGUA ,SINOSSI);
	END $

CREATE PROCEDURE cancella_metadati ( IN ISBN BIGINT )
	BEGIN
		DELETE FROM Metadati WHERE isbn = ISBN ;
	END $


CREATE PROCEDURE aggiorna_edizione_metadati (IN EDI INT , IN ISBN BIGINT )
	BEGIN
		UPDATE Metadati SET edizione = EDI WHERE isbn = ISBN ; 
	END $

CREATE PROCEDURE aggiorna_editore_metadati (IN EDI INT , IN ISBN BIGINT )
	BEGIN
		UPDATE Metadati SET editore = EDI WHERE isbn = ISBN ; 
	END $

CREATE PROCEDURE aggiorna_data_pubblicazione_metadati (IN DATAPUBB DATE , IN ISBN BIGINT )
	BEGIN
		UPDATE Metadati SET data_pubblicazione = DATAPUBB WHERE isbn = ISBN ; 
	END $

CREATE PROCEDURE aggiorna_parole_chiave_metadati (IN PAROLECHIAVE VARCHAR(200) , IN ISBN BIGINT )
	BEGIN
		UPDATE Metadati SET parole_chiave = PAROLECHIAVE WHERE isbn = ISBN ; 
	END $

CREATE PROCEDURE aggiorna_isbn_metadati (IN ISBNNEW INT(13), IN ISBN BIGINT )
	BEGIN
		UPDATE Metadati SET isbn = ISBNNEW WHERE isbn = ISBN ; 
	END $

CREATE PROCEDURE aggiorna_num_pagine_metadati (IN NUMPAGINE INT,IN ISBN BIGINT )
	BEGIN
		UPDATE Metadati SET num_pagine = NUMPAGINE WHERE isbn = ISBN ; 
	END $

CREATE PROCEDURE aggiorna_lingua_metadati (IN LINGUA VARCHAR(50),IN ISBN BIGINT )
	BEGIN
		UPDATE Metadati SET lingua = LINGUA WHERE isbn = ISBN ; 
	END $

CREATE PROCEDURE aggiorna_sinossi_metadati (IN SINOSSI VARCHAR(1000) , IN ISBN BIGINT )
	BEGIN
		UPDATE Metadati SET sinossi = SINOSSI WHERE isbn = ISBN ; 
	END $



#
#PROCEDURE AUTORE
#



CREATE PROCEDURE aggiungi_autore  ( IN NOME VARCHAR(100) , IN COGNOME VARCHAR(100) )
	BEGIN
		INSERT INTO Autore ( nome , cognome ) VALUE ( NOME , COGNOME );
	END $

CREATE PROCEDURE cancella_autore ( IN IDAUT INT)
	BEGIN
		DELETE FROM Autore WHERE id_autore = IDAUT ;
	END $

CREATE PROCEDURE  aggiorna_nome_autore( IN NOME VARCHAR(100), IN IDAUT INT)
	BEGIN
		UPDATE Autore SET nome =NOME WHERE id_autore = IDAUT ;
	END $

CREATE PROCEDURE  aggiorna_cognome_autore( IN COGNOME VARCHAR(100), IN IDAUT INT)
	BEGIN
		UPDATE Autore SET cognome =COGNOME WHERE id_autore = IDAUT ;
	END $



#
# PROCEDURE CAPITOLO
#
CREATE PROCEDURE aggiungi_capitolo
	(
		IDPUBB			INT,
		TITOLO  		VARCHAR(100) ,
		DESCRIZIONE		VARCHAR(500) ,
		NUMCAP			INT
	)
	BEGIN
		INSERT INTO Capitolo (id_pubblicazione , titolo , descrizione , num_capitolo)  VALUE (IDPUBB , TITOLO, DESCRIZIONE , NUMCAP);
	END $

CREATE PROCEDURE cancella_capitolo ( IN IDCAP INT )
	BEGIN
		DELETE FROM Capitolo WHERE id_capitolo = IDCAP ;
	END $

CREATE PROCEDURE  aggiorna_titolo_capitolo( IN TITOLO VARCHAR(100), IN IDCAP INT)
	BEGIN
		UPDATE Capitolo SET titolo = TITOLO WHERE id_capitolo = IDAUT ;
	END $

CREATE PROCEDURE  aggiorna_descrizione_capitolo( IN DESCRIZIONE VARCHAR(500), IN IDCAP INT)
	BEGIN
		UPDATE Capitolo SET descrizione = DESCRIZIONE WHERE id_capitolo = IDAUT ;
	END $

CREATE PROCEDURE  aggiorna_num_capitolo( IN NUMCAP INT, IN IDCAP INT)
	BEGIN
		UPDATE Capitolo SET num_capitolo = NUMCAP WHERE id_capitolo = IDAUT ;
	END $




#
#PROCEDURE VERSIONE_STAMPA
#

CREATE PROCEDURE aggiungi_versione_stampa
	(	
		IDPUBB 		BIGINT ,
		NUMCOP 		INT ,
		DATASTAMP	DATE
	)
	BEGIN
		INSERT INTO Versione_Stampa ( isbn ,num_copie ,data_stampa ) VALUE (IDPUBB,NUMCOP ,DATASTAMP);
	END $

CREATE PROCEDURE  aggiorna_num_copie_versione_stampa( IN NUMCOP INT, IN IDVER INT)
	BEGIN
		UPDATE Versione_Stampa SET num_copie = NUMCOP WHERE id_versione_stampa = IDVER ;
	END $

CREATE PROCEDURE  aggiorna_data_versione_stampa ( IN DATAVER DATE, IN IDVER INT )
	BEGIN
		UPDATE Versione_Stampa SET data_stampa = DATAVER WHERE id_versione_stampa = IDVER ;
	END $


CREATE PROCEDURE cancella_versione_stampa (IN IDVER INT )
	BEGIN
		DELETE FROM Versione_Stampa WHERE id_versione = IDVER ;
	END $
#
#PROCEDURE MEDIATYPE
#

CREATE PROCEDURE aggiungi_mediatype 
	(
		IN TIPO			VARCHAR(200) ,
		IN FORMATO		VARCHAR(200)	
	)
	BEGIN
		INSERT INTO Mediatype (tipo , formato) VALUE ( TIPO , FORMATO ) ;
	END $


CREATE PROCEDURE aggiorna_tipo_mediatype (IN TIPO VARCHAR(100) , IN IDVER INT )
	BEGIN
		UPDATE Mediatype SET tipo = TIPO WHERE id_mediatype = IDVER ;
	END $


CREATE PROCEDURE aggiorna_formato_mediatype (IN FORMATO VARCHAR(100) , IN IDVER INT )
	BEGIN
		UPDATE Mediatype SET formato = FORMATO WHERE id_mediatype = IDVER ;
	END $



#
# PROCEDURE RISORSE
#

CREATE PROCEDURE aggiungi_risorse 
	(	
		IN IDMEDIA INT ,
		IN URI	VARCHAR(200),
		IN DESCR VARCHAR(500)
	)
BEGIN
	INSERT INTO Risorse  (id_mediatype , uri , descrizione )VALUE (IDMEDIA , URI , DESCR);
END $

CREATE PROCEDURE aggiorna_uri_risorse (IN URI VARCHAR(100) , IN IDRISORSA INT )
	BEGIN
		UPDATE Risorse SET uri = URI WHERE id_risorsa = IDRISORSA ;	
	END $

CREATE PROCEDURE aggiorna_formato_risorse (IN DESCRIZ VARCHAR(100) , IN IDRISORSA INT )
	BEGIN
		UPDATE Risorse SET descrizione = DESCRIZ WHERE id_risorsa = IDRISORSA ;	
	END $



#
# PROEDURE RECENSIONE
#


CREATE PROCEDURE aggiungi_recensione 
	(
		IN IDUTENTE INT ,
		IDPUBB 	INT,
		IN TESTO VARCHAR(1000)	
	)
	BEGIN
		INSERT INTO Recensione ( id_utente , id_pubblicazione , testo) VALUE (IDUTENTE , IDPUBB , TESTO);
	END $

CREATE PROCEDURE cancella_recensione (IN IDUTENTE INT , IN IDPUBB INT)
	BEGIN
		DELETE FROM Recensione WHERE id_utente = IDUTENTE AND id_pubblicazione = IDPUBB ;
	END $

CREATE PROCEDURE aggiorna_stato_recensione ( IN IDUTENTE INT , IN IDPUBB INT )
	BEGIN
		UPDATE Recensione SET stato = 'APPROVATA' WHERE id_utente = IDUTENTE AND id_pubblicazione = IDPUBB ;
	END $

CREATE PROCEDURE aggiorna_testo_recensione (IN IDUTENTE INT , IN IDPUBB INT , IN TESTO VARCHAR(1000) )
	BEGIN
		UPDATE Recensione SET testo = TESTO AND stato = 'IN ATTESA' AND data = CURRENT_TIMESTAMP WHERE id_utente = IDUTENTE AND id_pubblicazione = IDPUBB ;
	END $

#
# PROCEDURE GRADIMENTO
#



CREATE PROCEDURE aggiungi_gradimento ( IN IDUTENTE INT , IN IDPUBB INT )
	BEGIN
		INSERT INTO Gradimento  ( id_utente , id_pubblicazione )VALUE (IDUTENTE , IDPUBB );
	END $

CREATE PROCEDURE cancella_gradimento (IN IDUTENTE INT , IN IDPUBB INT )
	BEGIN
		DELETE FROM Gradimento WHERE id_utente = IDUTENTE AND id_pubblicazione = IDPUBB ;
	END $


#
# PROCEDURE ATTRIBUZIONE
#

CREATE PROCEDURE aggiungi_attribuzione ( IN IDPUBB BIGINT , IN IDAUT INT )
	BEGIN
		INSERT INTO Attribuzione VALUE (IDPUBB , IDAUT );
	END $

CREATE PROCEDURE cancella_attribuzione (IN IDPUBB BIGINT , IN IDAUT INT )
	BEGIN
		DELETE FROM Attribuzione WHERE  id_pubblicazione = IDPUBB AND id_autore = IDAUT ;
	END $
#
# PROCEDURE LINK
#

CREATE PROCEDURE aggiungi_link( IN IDPUBB INT,IN IDRIS INT )
	BEGIN
	INSERT INTO Link VALUE (IDPUBB , IDRIS );
	END $

CREATE PROCEDURE cancella_link (IN IDPUBB INT , IN IDRIS INT )
	BEGIN
		DELETE FROM Link WHERE id_pubblicazione = IDPUBB AND id_risorsa= IDRIS;
	END $



#
# reimposto il delimitatore ;
#

DELIMITER $


