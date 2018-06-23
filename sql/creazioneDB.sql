drop DATABASE if exists BIBLIOTECA;

create DATABASE BIBLIOTECA;

USE BIBLIOTECA

#
#	CREAZIONE TABELLE PER LE ENTITà
#

create table Utente (
	id_utente    		int AUTO_INCREMENT PRIMARY KEY,
	email 		 	varchar(100) not NULL,
	password	 	varchar(100) not NULL,
	tipo		 	varchar(10)  not NULL default 'PASSIVO',
	num_inserimenti 	int default 0, 	
	CONSTRAINT UNICA_EMAIL 	unique(email)
);

create table Anagrafica (
	id_utente  		int PRIMARY KEY,
	nome  		 	varchar(100) not NULL,
	cognome		 	varchar(100) not NULL,	
	cf		 	varchar(100) not NULL,
	data_nascita  		DATE	     not NULL,
	luogo_nascita 		varchar(100) not NULL,
	nazionalita		varchar(100) not NULL,
	CONSTRAINT ANAGRAFICA_UTENTE FOREIGN KEY (id_utente) REFERENCES Utente(id_utente) ON DELETE CASCADE,
	CONSTRAINT UNICA_ANAGRAFICA unique(cf)
);

create table Pubblicazione (
	id_pubblicazione 	int AUTO_INCREMENT PRIMARY KEY,
	titolo		 	varchar(100) not NULL,
	data_inserimento 	TIMESTAMP default CURRENT_TIMESTAMP, 
	data_ultima_modifica 	TIMESTAMP default CURRENT_TIMESTAMP,
	categoria 		varchar(100) not NULL,
	numlike		 	int default 0,
	rif_inserimento 	varchar(100) not NULL,
	CONSTRAINT PUBBLICAZIONE_UTENTE FOREIGN KEY (rif_inserimento) REFERENCES Utente(email) 	# decidereondelete
);

create table Metadati (
	id_pubblicazione	int,
	edizione		int default 1 not NULL,
	editore			varchar(50),
	data_pubblicazione 	DATE,
	parole_chiave		varchar(200),
	isbn			BIGINT PRIMARY KEY,
	num_pagine		int,
	lingua			varchar(50),
	sinossi			varchar(1000),
	CONSTRAINT METADATI_PUBBLICAZIONE FOREIGN KEY(id_pubblicazione) REFERENCES Pubblicazione(id_pubblicazione)
);

create table Autore (
	id_autore 		int AUTO_INCREMENT PRIMARY KEY,
	nome 			varchar(100) not NULL,
	cognome 		varchar(100) not NULL
);


create table Capitolo (
	id_capitolo		int AUTO_INCREMENT PRIMARY KEY,
	id_pubblicazione 	int,
	titolo			varchar(100) not NULL,
	descrizione		varchar(500),
	num_capitolo		int,
	CONSTRAINT CAPITOLO_PUBBLICAZIONE FOREIGN KEY(id_pubblicazione) REFERENCES Pubblicazione(id_pubblicazione),
	CONSTRAINT UNICO_CAPITOLO unique (id_pubblicazione,num_capitolo)
);

create table Versione_Stampa (
	id_versione_stampa		int AUTO_INCREMENT PRIMARY KEY,
	isbn 			BIGINT not NULL,
	num_copie 		int not NULL,
	data_stampa		DATE,
	CONSTRAINT VERSIONESTAMPA_METADATI FOREIGN KEY(isbn) REFERENCES Metadati(isbn)
);


create table Mediatype (
	id_mediatype 		int AUTO_INCREMENT PRIMARY KEY,
	tipo			varchar(100) not NULL,
	formato			varchar(100) not NULL
);

create table Risorse (
	id_risorsa 		int AUTO_INCREMENT PRIMARY KEY,
	id_mediatype		int not NULL,
	uri			varchar(200) not NULL,
	descrizione		varchar(500),
	CONSTRAINT RISORSE_MEDIATYPE FOREIGN KEY(id_mediatype) REFERENCES Mediatype(id_mediatype)
);


#
#CREAZIONE TABELLE PER RELAZIONI
#

create table Recensione (
	id_utente		int not NULL,
	id_pubblicazione 	int not NULL,
	data 			TIMESTAMP default CURRENT_TIMESTAMP,
	stato 			varchar(10) not NULL default 'IN ATTESA',
	testo 			varchar(1000),
	CONSTRAINT RECENSIONE_PUBBLICAZIONE FOREIGN KEY(id_pubblicazione) REFERENCES Pubblicazione(id_pubblicazione),
	CONSTRAINT RECENSIONE_UTENTE FOREIGN KEY (id_utente) REFERENCES Utente(id_utente),
	CONSTRAINT UNICA_RECENSIONE unique(id_utente , id_pubblicazione)
);
	
# La tabella sottostante Gradimento corrisponde alla tabella Like, tuttavia MySQL non permette di utilizzare
create table Gradimento (
	id_utente		int not NULL,
	id_pubblicazione 	int not NULL,
	data			TIMESTAMP default CURRENT_TIMESTAMP,
	CONSTRAINT GRADIMENTO_UTENTE FOREIGN KEY (id_utente) REFERENCES Utente (id_utente) ON DELETE CASCADE,
	CONSTRAINT GRADIMENTO_PUBBLICAZIONE FOREIGN KEY (id_pubblicazione) REFERENCES Pubblicazione(id_pubblicazione) ON DELETE CASCADE,
	CONSTRAINT UNICO_LIKE unique(id_utente,id_pubblicazione)
);


create table Storico (

	id_utente 		int not NULL,
	id_pubblicazione	int not NULL,
	data			TIMESTAMP default CURRENT_TIMESTAMP,
	descrizione		varchar(100) not NULL,
	operazione 		varchar(40) not NULL,
	CONSTRAINT LOG_UTENTE FOREIGN KEY (id_utente) REFERENCES Utente (id_utente),
	CONSTRAINT LOG_PUBBLICAZIONE FOREIGN KEY (id_pubblicazione) REFERENCES Pubblicazione(id_pubblicazione)
);


create table Attribuzione(
	isbn			 		BIGINT not NULL,
	id_autore 				int not NULL,
	CONSTRAINT ATTRIBUZIONE_METADATI FOREIGN KEY (isbn) REFERENCES Metadati(isbn),
	CONSTRAINT ATTRIBUZIONE_AUTORE FOREIGN KEY (id_autore) REFERENCES Autore(id_autore),
	CONSTRAINT UNICA_ATTRIBUZIONE unique(isbn, id_autore)
);


create table Link (
	id_pubblicazione 	int not NULL,
	id_risorsa		int not NULL,
	CONSTRAINT LINK_PUBBLICAZIONE FOREIGN KEY (id_pubblicazione) REFERENCES Pubblicazione(id_pubblicazione),
	CONSTRAINT LINK_RISORSA FOREIGN KEY (id_risorsa) REFERENCES Risorse(id_risorsa)	
);



