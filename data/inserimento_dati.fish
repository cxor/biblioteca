


function call_aggiungi_risorse
	# call aggiungi_risorse(INT id_mediatype, VARCHAR uri, VARCHAR descrizione)
	for i in (seq 1 10)
	end
end

		
function call_aggiungi_versione_stampa
	for i in (seq 1 9)
	      set id_pubblicazione $i
	      set numero_copie (random 1 10)
	      set anno (random 1950 2018)
	      set mese (random 1 12)
	      set giorno (random 1 28)
	      echo "call aggiungi_versione_stampa($i, $numero_copie, $anno-$mese-$giorno)"
	end
end

