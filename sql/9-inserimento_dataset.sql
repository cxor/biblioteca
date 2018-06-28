#aggiunta Utenti

DELETE FROM Utente ;

call aggiungi_utente('tommasodisalle@gmail.com','passwd');
call aggiungi_utente('danielecampli@gmail.com','passwd');
call aggiungi_utente('pippo@gmail.com','passwd');
call aggiungi_utente('pluto@gmail.com','passwd');
call aggiungi_utente('paperino@gmail.com','passwd');
call aggiungi_utente('minnie@gmail.com','passwd');
call aggiungi_utente('topolino@gmail.com','passwd');
call aggiungi_utente('uno@gmail.com','passwd');
call aggiungi_utente('due@gmail.com','passwd');
call aggiungi_utente('tre@gmail.com','passwd');


#aggiunta Anagrafica

DELETE FROM Anagrafica ;

call aggiungi_anagrafica(1,'tommaso','di salle','dsltms86e11g878o'  ,'1990-05-11','popoli','italia');
call aggiungi_anagrafica(2,'daniele','campli'  ,'aemndj67u32l912t'  ,'1991-07-20','popoli','italia');
call aggiungi_anagrafica(3,'pippo','disalle'   ,'moiuad99a23d712h'  ,'1981-08-30','popoli','italia');
call aggiungi_anagrafica(4,'pluto','disalle'   ,'moasqh22j54w345s'  ,'1971-01-31','popoli','italia');
call aggiungi_anagrafica(5,'paperino','disalle','asdhjw90m76p789r'  ,'1992-10-13','popoli','italia');
call aggiungi_anagrafica(6,'minnie','disalle'  ,'bbnmqw77a87d567b'  ,'1985-11-14','popoli','italia');
call aggiungi_anagrafica(7,'topolino','disalle','pzpzpz62a28s678y'  ,'1999-12-15','popoli','italia');
call aggiungi_anagrafica(8,'uno','disalle'	   ,'papaox88j91e266x'  ,'1987-03-23','popoli','italia');
call aggiungi_anagrafica(9,'due','disalle'     ,'qozmei57a13o897w'  ,'2000-05-25','popoli','italia');
call aggiungi_anagrafica(10,'tre','disalle'    ,'mxmxmx89i13j390p'  ,'1994-04-26','popoli','italia');

#aggiunta Pubblicazioni

DELETE FROM Pubblicazione;
call aggiungi_pubblicazione ('titolo_capitoloolo1','REPORT');
call aggiungi_pubblicazione ('titolo_capitoloolo2','LIBRO');
call aggiungi_pubblicazione ('titolo_capitoloolo3','TESI');
call aggiungi_pubblicazione ('titolo_capitoloolo4','ARTICOLO');
call aggiungi_pubblicazione ('titolo_capitoloolo5','ARTICOLO');
call aggiungi_pubblicazione ('titolo_capitoloolo6','TESI');
call aggiungi_pubblicazione ('titolo_capitoloolo7','LIBRO');
call aggiungi_pubblicazione ('titolo_capitoloolo8','REPORT');
call aggiungi_pubblicazione ('titolo_capitoloolo9','ARTICOLO');
call aggiungi_pubblicazione ('titolo_capitoloolo9','REPORT');


#aggiunta metadati

DELETE FROM Metadati;
#ins   dati value (IDPUBB, EDIZIONE ,EDITORE,DATAPUBB ,PAROLECHIAVE ,ISBN ,NUMPAGINE ,LINGUA ,SINOSSI);						
call aggiungi_metadati(1, 2 ,'editore1','1800-01-01' ,'par1 par2 par3' ,1 ,987 ,'italiana' ,'abstract pubblicazione1' );
call aggiungi_metadati(2, 1 ,'editore2','1800-01-01' ,'par1 par2 par3' ,2 ,987 ,'bulgara' ,'abstract pubblicazione2' );
call aggiungi_metadati(3, 1 ,'editore3','1800-01-01' ,'par1 par2 par3' ,3 ,987 ,'italiana' ,'abstract pubblicazione3' );
call aggiungi_metadati(4, 1 ,'editore4','1800-01-01' ,'par1 par2 par3' ,4 ,987 ,'svizzera' ,'abstract pubblicazione4' );
call aggiungi_metadati(5, 1 ,'editore5','1800-01-01' ,'par1 par2 par3' ,5 ,987 ,'italiana' ,'abstract pubblicazione5' );
call aggiungi_metadati(6, 1 ,'editore6','1800-01-01' ,'par1 par2 par3' ,6 ,987 ,'francese' ,'abstract pubblicazione6' );
call aggiungi_metadati(7 ,1 ,'editore3','1800-01-01' ,'par1 par2 par3' ,7 ,987 ,'inglese' ,'abstract pubblicazione3' );
call aggiungi_metadati(8, 1 ,'editore4','1800-01-01' ,'par1 par2 par3' ,8 ,987 ,'italiana' ,'abstract pubblicazione4' );
call aggiungi_metadati(9, 1 ,'editore5','1800-01-01' ,'par1 par2 par3' ,9 ,987 ,'giapponese' ,'abstract pubblicazione5' );
call aggiungi_metadati(10, 1 ,'editore6','1800-01-01' ,'par1 par2 par3' ,10 ,987 ,'italiana' ,'abstract pubblicazione6' );

#aggiunti autori
call aggiungi_autore('isaac','newton');
call aggiungi_autore('paul','erdos');
call aggiungi_autore('claude','shannon');
call aggiungi_autore('dennis','ritchie');
call aggiungi_autore('ken','thompson');
call aggiungi_autore('vincenzo','stoico');
call aggiungi_autore('eugenio','mancini');
call aggiungi_autore('leonardo','da vinci');
call aggiungi_autore('nikola','tesla');
call aggiungi_autore('alan','turing');
call aggiungi_autore('giacomo','leopardi');
call aggiungi_autore('giuseppe','verdi');
call aggiungi_autore('giacomo','pucci');
call aggiungi_autore('tommaso','di salle');
call aggiungi_autore('daniele','campli');

call aggiungi_capitolo(1,'titolo_capitolo','desc1',1);
call aggiungi_capitolo(1,'titolo_capitolo','desc2',2);
call aggiungi_capitolo(1,'titolo_capitolo','desc3',3);
call aggiungi_capitolo(1,'titolo_capitolo','desc4',4);
call aggiungi_capitolo(1,'titolo_capitolo','desc5',5);
call aggiungi_capitolo(1,'titolo_capitolo','desc6',6);
call aggiungi_capitolo(1,'titolo_capitolo','desc7',7);
call aggiungi_capitolo(1,'titolo_capitolo','desc8',8);
call aggiungi_capitolo(2,'titolo_capitolo','desc1',1);
call aggiungi_capitolo(2,'titolo_capitolo','desc2',2);
call aggiungi_capitolo(2,'titolo_capitolo','desc3',3);
call aggiungi_capitolo(2,'titolo_capitolo','desc4',4);
call aggiungi_capitolo(2,'titolo_capitolo','desc5',5);
call aggiungi_capitolo(2,'titolo_capitolo','desc6',6);
call aggiungi_capitolo(2,'titolo_capitolo','desc7',7);
call aggiungi_capitolo(2,'titolo_capitolo','desc8',8);
call aggiungi_capitolo(3,'titolo_capitolo','desc1',1);
call aggiungi_capitolo(3,'titolo_capitolo','desc2',2);
call aggiungi_capitolo(3,'titolo_capitolo','desc3',3);
call aggiungi_capitolo(3,'titolo_capitolo','desc4',4);
call aggiungi_capitolo(3,'titolo_capitolo','desc5',5);
call aggiungi_capitolo(3,'titolo_capitolo','desc6',6);
call aggiungi_capitolo(3,'titolo_capitolo','desc7',7);
call aggiungi_capitolo(3,'titolo_capitolo','desc8',8);
call aggiungi_capitolo(4,'titolo_capitolo','desc1',1);
call aggiungi_capitolo(5,'titolo_capitolo','desc1',1);
call aggiungi_capitolo(6,'titolo_capitolo','desc1',1);
call aggiungi_capitolo(7,'titolo_capitolo','desc1',1);
call aggiungi_capitolo(8,'titolo_capitolo','desc1',1);
call aggiungi_capitolo(9,'titolo_capitolo','desc1',1);

call aggiungi_versione_stampa(1, 1, '1987-7-13');
call aggiungi_versione_stampa(2, 1, '1961-2-28');
call aggiungi_versione_stampa(3, 1, '1954-5-3');
call aggiungi_versione_stampa(4, 1, '2015-6-16');
call aggiungi_versione_stampa(5, 1, '1959-4-26');
call aggiungi_versione_stampa(6, 1, '1968-5-12');


call aggiungi_mediatype('tipo1','formato1');
call aggiungi_mediatype('tipo2','formato2');
call aggiungi_mediatype('tipo3','formato3');
call aggiungi_mediatype('tipo4','formato4');
call aggiungi_mediatype('tipo5','formato5');
call aggiungi_mediatype('tipo6','formato6');
call aggiungi_mediatype('tipo7','formato7');
call aggiungi_mediatype('tipo8','formato8');


call aggiungi_risorse(1,'uri1','desc1');
call aggiungi_risorse(2,'uri2','desc2');
call aggiungi_risorse(3,'uri3','desc3');
call aggiungi_risorse(4,'uri4','desc4');
call aggiungi_risorse(5,'uri5','desc5');
call aggiungi_risorse(6,'uri6','desc6');
call aggiungi_risorse(7,'uri7','desc7');
call aggiungi_risorse(8,'uri8','desc8');


call aggiungi_recensione(1,1,'testo1');
call aggiungi_recensione(1,2,'testo2');
call aggiungi_recensione(1,3,'testo3');
call aggiungi_recensione(1,4,'testo4');
call aggiungi_recensione(1,5,'testo5');
call aggiungi_recensione(1,6,'testo6');
call aggiungi_recensione(1,7,'testo7');
call aggiungi_recensione(2,3,'testo9');
call aggiungi_recensione(2,4,'testo10');
call aggiungi_recensione(2,5,'testo11');
call aggiungi_recensione(3,6,'testo12');
call aggiungi_recensione(3,7,'testo13');
call aggiungi_recensione(4,8,'testo14');
call aggiungi_recensione(4,1,'testo15');
call aggiungi_recensione(5,2,'testo16');


call aggiungi_gradimento(1 , 1);
call aggiungi_gradimento(1 , 2);
call aggiungi_gradimento(1 , 3);
call aggiungi_gradimento(1 , 4);
call aggiungi_gradimento(2 , 1);
call aggiungi_gradimento(2 , 2);
call aggiungi_gradimento(2 , 3);
call aggiungi_gradimento(3 , 1);
call aggiungi_gradimento(3 , 2);
call aggiungi_gradimento(3 , 3);
call aggiungi_gradimento(3 , 4);
call aggiungi_gradimento(4 , 1);
call aggiungi_gradimento(4 , 2);
call aggiungi_gradimento(4 , 3);
call aggiungi_gradimento(4 , 4);



call aggiungi_attribuzione(1 , 1);
call aggiungi_attribuzione(1 , 2);
call aggiungi_attribuzione(1 , 3);
call aggiungi_attribuzione(1 , 4);
call aggiungi_attribuzione(2 , 1);
call aggiungi_attribuzione(2 , 2);
call aggiungi_attribuzione(2 , 3);
call aggiungi_attribuzione(3 , 1);
call aggiungi_attribuzione(3 , 2);
call aggiungi_attribuzione(4 , 1);
call aggiungi_attribuzione(4 , 2);


call aggiungi_storico(1,1,'inserita pubblicazione' , 'INSERIMENTO PUBBLICAZIONE');
call aggiungi_storico(1,2,'inserita pubblicazione' , 'INSERIMENTO PUBBLICAZIONE');
call aggiungi_storico(2,3,'inserita pubblicazione' , 'INSERIMENTO PUBBLICAZIONE');
call aggiungi_storico(2,4,'inserita pubblicazione' , 'INSERIMENTO PUBBLICAZIONE');
call aggiungi_storico(3,5,'inserita pubblicazione' , 'INSERIMENTO PUBBLICAZIONE');

call aggiungi_link( 1, 1);
call aggiungi_link( 1, 2);
call aggiungi_link( 1, 3);
call aggiungi_link( 2, 1);
call aggiungi_link( 2, 3);
call aggiungi_link( 2, 4);
call aggiungi_link( 3, 5);
call aggiungi_link( 3, 6);
call aggiungi_link( 3, 7);
call aggiungi_link( 4, 6);
call aggiungi_link( 4, 7);
call aggiungi_link( 4, 8);
