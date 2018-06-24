delete from mysql.proc where db = 'BIBLIOTECA';
#
# DELIMITATORE
#

DELIMITER $

#
#	procedure INSERIMENTO , CANC , E AGGIORNAMENTO TABELLA UTENTE
#


create procedure aggiungi_utente( in EMAILUTENTE varchar(250), in PASSWD varchar(250) ) 
	begin
		insert into Utente(email,password) value ( EMAILUTENTE,PASSWORD(PASSWD) );
	end $ 


create procedure cancella_utente(in EMAILUTENTE varchar(250) )
	begin
		delete from Utente where email = EMAILUTENTE ;
	end $


create procedure aggiorna_email (in EMAILVECCHIA varchar(250) , in EMAILNUOVA varchar(250) )
	begin
		update Utente set email = EMAILNUOVA where email = EMAILVECCHIA ;
	end $

create procedure aggiorna_password(in PASSWORD varchar(250) , in EMAILUTENTE varchar(250) )
	begin
		update Utente set password = PASSWORD where email = EMAILUTENTE ;
	end $

create procedure aggiorna_tipo_attivo( in EMAILUTENTE varchar(250) )
	begin 
		update Utente set tipo = 'ATTIVO' where email = EMAILUTENTE ;
	end $

create procedure aggiorna_tipo_passivo( in EMAILUTENTE varchar(250) )
	begin 
		update Utente set tipo = 'PASSIVO' where email = EMAILUTENTE ;
	end $


create procedure aggiorna_tipo( in EMAILUTENTE varchar(250) , in TIPO varchar(250) )
	begin 
		update Utente set tipo = TIPO where email = EMAILUTENTE ;
	end $



#
#	procedure CRUD ANAGRAFICA
#

create procedure aggiungi_anagrafica 

(
	in IDUTENTE int,
	in NOME  varchar(250),
	in COGNOME varchar(250),
	in CF varchar(250),
	in DATADINASCITA DATE,
	in LUOGODINASCITA varchar(250),
	in NAZIONE varchar(250)
)

	begin
		insert into Anagrafica value (IDUTENTE,NOME,COGNOME,CF,DATADINASCITA,LUOGODINASCITA,NAZIONE) ;
	end $	





create procedure cancella_anagrafica ( in IDUTENTE int )
	begin
	delete from Anagrafica where id_utente = IDUTENTE ;
	end $


#procedure PER AGGIORNAMENTO

#update NOME

create procedure aggiorna_nome (in NUOVONOME varchar(250) , in IDUTENTE int )
	begin
	update Anagrafica set nome= NUOVONOME where id_utente = IDUTENTE ;
	end $


#update COGNOME

create procedure aggiorna_cognome(in NUOVOCOGNOME varchar(250), in IDUTENTE int)
	begin
        update Anagrafica set cognome= NUOVOCOGNOME where id_utente = IDUTENTE ;
        end $


#update CODICE FISCALE

create procedure aggiorna_cf ( in NUOVOCF varchar(250) , in IDUTENTE int )
        begin
        update Anagrafica set cf = NUOVOCF where id_utente = IDUTENTE ;
        end $


#update DATA DI NASCITA

create procedure aggiorna_data_nascita (in NUOVADATA Date, in IDUTENTE int )
        begin
        update Anagrafica set data_nascita= NUOVADATA where id_utente = IDUTENTE ;
        end $


#update LUOGO DI NASCITA

create procedure aggiorna_luogo_nascita(in NUOVOLUOGO varchar(250), in IDUTENTE int)
        begin
        update Anagrafica set luogo_nascita = NUOVOLUOGO where id_utente = IDUTENTE;
        end $


#update NAZIONE
create procedure aggiorna_nazionalita (in NUOVANAZIONE varchar(250), in IDUTENTE int)
        begin
        update Anagrafica set nazionalita = NUOVANAZIONE where id_utente = IDUTENTE ;
        end $


#
#procedure PUBBLICAZIONE
#

create procedure aggiungi_pubblicazione 
	(
	in TITOLO varchar(250) ,
	in CATEG  varchar(250) ,
	in RIF 	  varchar(250)
	)
	
	begin
		insert into Pubblicazione (titolo, categoria , rif_inserimento ) value ( TITOLO , CATEG , RIF );
	end $


create procedure cancella_pubblicazione (in IDPUBB int )
	begin
		delete from Pubblicazione where id_pubblicazione = IDPUBB ; 
	end $


create procedure aggiorna_titolo   (in IDPUBB int , in STRNG varchar(250))
	begin
		update Pubblicazione set titolo = STRNG where id_pubblicazione = IDPUBB ; 
	end $

create procedure aggiorna_categoria(in IDPUBB int , in STRNG varchar(250))
	begin
		update Pubblicazione set categoria = STRNG where id_pubblicazione = IDPUBB ; 
	end $



#
#	procedure METADATI
#

create procedure aggiungi_metadati 
	(
		in IDPUBB 			int,
		in EDIZIONE			int,
		in EDITORE			varchar(250),
		in DATAPUBB 		DATE,
		in PAROLECHIAVE		varchar(250),
		in ISBN				BIGINT,
		in NUMPAGINE		int,
		in LINGUA			varchar(250),
		in SINOSSI			varchar(1000)
	)

	begin
		insert into Metadati value (IDPUBB, EDIZIONE ,EDITORE,DATAPUBB ,PAROLECHIAVE ,ISBN ,NUMPAGINE ,LINGUA ,SINOSSI);
	end $

create procedure cancella_metadati ( in ISBN BIGINT )
	begin
		delete from Metadati where isbn = ISBN ;
	end $


create procedure aggiorna_edizione_metadati (in EDI int , in ISBN BIGINT )
	begin
		update Metadati set edizione = EDI where isbn = ISBN ; 
	end $

create procedure aggiorna_editore_metadati (in EDI int , in ISBN BIGINT )
	begin
		update Metadati set editore = EDI where isbn = ISBN ; 
	end $

create procedure aggiorna_data_pubblicazione_metadati (in DATAPUBB DATE , in ISBN BIGINT )
	begin
		update Metadati set data_pubblicazione = DATAPUBB where isbn = ISBN ; 
	end $

create procedure aggiorna_parole_chiave_metadati (in PAROLECHIAVE varchar(250) , in ISBN BIGINT )
	begin
		update Metadati set parole_chiave = PAROLECHIAVE where isbn = ISBN ; 
	end $

create procedure aggiorna_isbn_metadati (in ISBNNEW int(13), in ISBN BIGINT )
	begin
		update Metadati set isbn = ISBNNEW where isbn = ISBN ; 
	end $

create procedure aggiorna_num_pagine_metadati (in NUMPAGINE int,in ISBN BIGINT )
	begin
		update Metadati set num_pagine = NUMPAGINE where isbn = ISBN ; 
	end $

create procedure aggiorna_lingua_metadati (in LINGUA varchar(250),in ISBN BIGINT )
	begin
		update Metadati set lingua = LINGUA where isbn = ISBN ; 
	end $

create procedure aggiorna_sinossi_metadati (in SINOSSI varchar(1000) , in ISBN BIGINT )
	begin
		update Metadati set sinossi = SINOSSI where isbn = ISBN ; 
	end $



#
#procedure AUTORE
#



create procedure aggiungi_autore  ( in NOME varchar(250) , in COGNOME varchar(250) )
	begin
		insert into Autore ( nome , cognome ) value ( NOME , COGNOME );
	end $

create procedure cancella_autore ( in IDAUT int)
	begin
		delete from Autore where id_autore = IDAUT ;
	end $

create procedure  aggiorna_nome_autore( in NOME varchar(250), in IDAUT int)
	begin
		update Autore set nome =NOME where id_autore = IDAUT ;
	end $

create procedure  aggiorna_cognome_autore( in COGNOME varchar(250), in IDAUT int)
	begin
		update Autore set cognome =COGNOME where id_autore = IDAUT ;
	end $



#
# procedure CAPITOLO
#
create procedure aggiungi_capitolo
	(
		IDPUBB			int,
		TITOLO  		varchar(250) ,
		DESCRIZIONE		varchar(1000) ,
		NUMCAP			int
	)
	begin
		insert into Capitolo (id_pubblicazione , titolo , descrizione , num_capitolo)  value (IDPUBB , TITOLO, DESCRIZIONE , NUMCAP);
	end $

create procedure cancella_capitolo ( in IDCAP int )
	begin
		delete from Capitolo where id_capitolo = IDCAP ;
	end $

create procedure  aggiorna_titolo_capitolo( in TITOLO varchar(250), in IDCAP int)
	begin
		update Capitolo set titolo = TITOLO where id_capitolo = IDAUT ;
	end $

create procedure  aggiorna_descrizione_capitolo( in DESCRIZIONE varchar(1000), in IDCAP int)
	begin
		update Capitolo set descrizione = DESCRIZIONE where id_capitolo = IDAUT ;
	end $

create procedure  aggiorna_num_capitolo( in NUMCAP int, in IDCAP int)
	begin
		update Capitolo set num_capitolo = NUMCAP where id_capitolo = IDAUT ;
	end $



#
#procedure VERSIONE_STAMPA
#

create procedure aggiungi_versione_stampa
	(	
		CODICEISBN 		BIGINT ,
		NUMCOP 		int ,
		DATASTAMP	DATE
	)
	begin
		insert into Versione_Stampa ( isbn ,num_copie ,data_stampa ) value (CODICEISBN,NUMCOP ,DATASTAMP);
	end $

create procedure  aggiorna_num_copie_versione_stampa( in NUMCOP int, in IDVER int)
	begin
		update Versione_Stampa set num_copie = NUMCOP where id_versione_stampa = IDVER ;
	end $

create procedure  aggiorna_data_versione_stampa ( in DATAVER DATE, in IDVER int )
	begin
		update Versione_Stampa set data_stampa = DATAVER where id_versione_stampa = IDVER ;
	end $


create procedure cancella_versione_stampa (in IDVER int )
	begin
		delete from Versione_Stampa where id_versione = IDVER ;
	end $
#
#procedure MEDIATYPE
#

create procedure aggiungi_mediatype 
	(
		in TIPO			varchar(250) ,
		in FORMATO		varchar(250)	
	)
	begin
		insert into Mediatype (tipo , formato) value ( TIPO , FORMATO ) ;
	end $


create procedure aggiorna_tipo_mediatype (in TIPO varchar(250) , in IDVER int )
	begin
		update Mediatype set tipo = TIPO where id_mediatype = IDVER ;
	end $


create procedure aggiorna_formato_mediatype (in FORMATO varchar(250) , in IDVER int )
	begin
		update Mediatype set formato = FORMATO where id_mediatype = IDVER ;
	end $



#
# procedure RISORSE
#

create procedure aggiungi_risorse 
	(	
		in IDMEDIA int ,
		in URI	varchar(250),
		in DESCR varchar(1000)
	)
begin
	insert into Risorse  (id_mediatype , uri , descrizione )value (IDMEDIA , URI , DESCR);
end $

create procedure aggiorna_uri_risorse (in URI varchar(250) , in IDRISORSA int )
	begin
		update Risorse set uri = URI where id_risorsa = IDRISORSA ;	
	end $

create procedure aggiorna_formato_risorse (in DESCRIZ varchar(250) , in IDRISORSA int )
	begin
		update Risorse set descrizione = DESCRIZ where id_risorsa = IDRISORSA ;	
	end $



#
# PROEDURE RECENSIONE
#


create procedure aggiungi_recensione 
	(
		in IDUTENTE int ,
		IDPUBB 	int,
		in TESTO varchar(1000)	
	)
	begin
		insert into Recensione ( id_utente , id_pubblicazione , testo) value (IDUTENTE , IDPUBB , TESTO);
	end $

create procedure cancella_recensione (in IDUTENTE int , in IDPUBB int)
	begin
		delete from Recensione where id_utente = IDUTENTE and id_pubblicazione = IDPUBB ;
	end $

create procedure aggiorna_stato_recensione ( in IDUTENTE int , in IDPUBB int )
	begin
		update Recensione set stato = 'APPROVATA' where id_utente = IDUTENTE and id_pubblicazione = IDPUBB ;
	end $

create procedure aggiorna_testo_recensione (in IDUTENTE int , in IDPUBB int , in TESTO varchar(1000) )
	begin
		update Recensione set testo = TESTO and stato = 'in ATTESA' and data = CURRENT_TIMESTAMP where id_utente = IDUTENTE and id_pubblicazione = IDPUBB ;
	end $

#
# procedure GRADIMENTO
#



create procedure aggiungi_gradimento ( in IDUTENTE int , in IDPUBB int )
	begin
		insert into Gradimento  ( id_utente , id_pubblicazione )value (IDUTENTE , IDPUBB );
	end $

create procedure cancella_gradimento (in IDUTENTE int , in IDPUBB int )
	begin
		delete from Gradimento where id_utente = IDUTENTE and id_pubblicazione = IDPUBB ;
	end $


#
# procedure ATTRIBUZIONE
#

create procedure aggiungi_attribuzione ( in IDPUBB BIGINT , in IDAUT int )
	begin
		insert into Attribuzione value (IDPUBB , IDAUT );
	end $

create procedure cancella_attribuzione (in IDPUBB BIGINT , in IDAUT int )
	begin
		delete from Attribuzione where  id_pubblicazione = IDPUBB and id_autore = IDAUT ;
	end $
#
# procedure LINK
#

create procedure aggiungi_link( in IDPUBB int,in IDRIS int )
	begin
	insert into Link value (IDPUBB , IDRIS );
	end $

create procedure cancella_link (in IDPUBB int , in IDRIS int )
	begin
		delete from Link where id_pubblicazione = IDPUBB and id_risorsa= IDRIS;
	end $



#
#procedure STORICO
#
drop procedure if exists aggiungi_storico ;
create procedure aggiungi_storico ( in idut int , in idpubb int , in descr varchar(1000) , in oper varchar(40) )
begin
	insert into Storico (id_utente,id_pubblicazione, descrizione , operazione ) value ( idut , idpubb , descr , oper ) ;
end $

	





#
# reimposto il delimitatore ;
#

DELIMITER $


