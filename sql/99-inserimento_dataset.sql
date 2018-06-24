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

call aggiungi_pubblicazione ('titolo1','categ1', 'tommasodisalle@gmail.com');
call aggiungi_pubblicazione ('titolo2','categ2', 'tommasodisalle@gmail.com');
call aggiungi_pubblicazione ('titolo3','categ3', 'tommasodisalle@gmail.com');
call aggiungi_pubblicazione ('titolo4','categ4', 'danielecampli@gmail.com');
call aggiungi_pubblicazione ('titolo5','categ5', 'danielecampli@gmail.com');
call aggiungi_pubblicazione ('titolo6','categ6', 'danielecampli@gmail.com');
call aggiungi_pubblicazione ('titolo7','categ7', 'danielecampli@gmail.com');
call aggiungi_pubblicazione ('titolo8','categ8', 'pippo@gmail.com');
call aggiungi_pubblicazione ('titolo9','categ9', 'pippo@gmail.com');



#aggiunta metadati

DELETE FROM Metadati;
						
call aggiungi_metadati(1, 2 ,'editore1','1800-01-01' ,'par1 par2 par3' ,1234567890123 ,987 ,'italiana' ,'asbstract pubblicazione1' );
call aggiungi_metadati(2, 1 ,'editore2','1800-01-01' ,'par1 par2 par3' ,1234567890124 ,987 ,'italiana' ,'asbstract pubblicazione2' );
call aggiungi_metadati(3, 1 ,'editore3','1800-01-01' ,'par1 par2 par3' ,1234567890125 ,987 ,'italiana' ,'asbstract pubblicazione3' );
call aggiungi_metadati(4, 1 ,'editore4','1800-01-01' ,'par1 par2 par3' ,1234567890126 ,987 ,'italiana' ,'asbstract pubblicazione4' );
call aggiungi_metadati(5, 1 ,'editore5','1800-01-01' ,'par1 par2 par3' ,1234567890127 ,987 ,'italiana' ,'asbstract pubblicazione5' );
call aggiungi_metadati(6, 1 ,'editore6','1800-01-01' ,'par1 par2 par3' ,1234567890128 ,987 ,'italiana' ,'asbstract pubblicazione6' );


#aggiunti autori

CALL aggiungi_autore('aaa','zzz');
CALL aggiungi_autore('bbb','xxx');
CALL aggiungi_autore('ccc','yyy');
CALL aggiungi_autore('ddd','hhh');
CALL aggiungi_autore('eee','vvv');
CALL aggiungi_autore('fff','qqq');
CALL aggiungi_autore('ggg','aba');
CALL aggiungi_autore('qwe','zxc');
CALL aggiungi_autore('iii','fgh');
CALL aggiungi_autore('lll','yui');
CALL aggiungi_autore('mmm','tre');
CALL aggiungi_autore('nnn','gfd');
CALL aggiungi_autore('ooo','ghj');
CALL aggiungi_autore('tommaso','di salle');
CALL aggiungi_autore('daniele','campli');


call aggiungi_capitolo(1,'tit','desc1',1);
call aggiungi_capitolo(1,'tit','desc2',2);
call aggiungi_capitolo(1,'tit','desc3',3);
call aggiungi_capitolo(1,'tit','desc4',4);
call aggiungi_capitolo(1,'tit','desc5',5);
call aggiungi_capitolo(1,'tit','desc6',6);
call aggiungi_capitolo(1,'tit','desc7',7);
call aggiungi_capitolo(1,'tit','desc8',8);
call aggiungi_capitolo(2,'tit','desc1',1);
call aggiungi_capitolo(2,'tit','desc2',2);
call aggiungi_capitolo(2,'tit','desc3',3);
call aggiungi_capitolo(2,'tit','desc4',4);
call aggiungi_capitolo(2,'tit','desc5',5);
call aggiungi_capitolo(2,'tit','desc6',6);
call aggiungi_capitolo(2,'tit','desc7',7);
call aggiungi_capitolo(2,'tit','desc8',8);
call aggiungi_capitolo(3,'tit','desc1',1);
call aggiungi_capitolo(3,'tit','desc2',2);
call aggiungi_capitolo(3,'tit','desc3',3);
call aggiungi_capitolo(3,'tit','desc4',4);
call aggiungi_capitolo(3,'tit','desc5',5);
call aggiungi_capitolo(3,'tit','desc6',6);
call aggiungi_capitolo(3,'tit','desc7',7);
call aggiungi_capitolo(3,'tit','desc8',8);
call aggiungi_capitolo(4,'tit','desc1',1);
call aggiungi_capitolo(5,'tit','desc1',1);
call aggiungi_capitolo(6,'tit','desc1',1);
call aggiungi_capitolo(7,'tit','desc1',1);
call aggiungi_capitolo(8,'tit','desc1',1);
call aggiungi_capitolo(9,'tit','desc1',1);


call aggiungi_versione_stampa(1234567890123, 1, '1987-7-13');
call aggiungi_versione_stampa(1234567890124, 1, '1961-2-28');
call aggiungi_versione_stampa(1234567890125, 1, '1954-5-3');
call aggiungi_versione_stampa(1234567890126, 1, '2015-6-16');
call aggiungi_versione_stampa(1234567890127, 1, '1959-4-26');
call aggiungi_versione_stampa(1234567890128, 1, '1968-5-12');


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





call aggiungi_gradimento(1 , 1 );
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



call aggiungi_attribuzione(1234567890123 , 1);
call aggiungi_attribuzione(1234567890123 , 2);
call aggiungi_attribuzione(1234567890123 , 3);
call aggiungi_attribuzione(1234567890123 , 4);
call aggiungi_attribuzione(1234567890124 , 1);
call aggiungi_attribuzione(1234567890124 , 2);
call aggiungi_attribuzione(1234567890124 , 3);
call aggiungi_attribuzione(1234567890125 , 1);
call aggiungi_attribuzione(1234567890125 , 2);
call aggiungi_attribuzione(1234567890126 , 5);
call aggiungi_attribuzione(1234567890126 , 8);




call aggiungi_link( 1 ,1 );
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
