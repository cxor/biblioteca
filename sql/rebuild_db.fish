#!/bin/env fish
#
# rebuild_db: script to automate the execution of sql scripts.


function install_rebuild_db
	source rebuild_db.fish
	cp rebuild_db.fish $HOME/.config/fish/functions
	if set -q is_installed_rebuild_db
		set -e is_installed_rebuild_db
	end
end



function var_switcher_by_host
	switch $argv[1]
		case 'cxor'
			if not set -q mysql_password
				set -Ux mysql_password $__mysql_password 
			end
			set -g sql_scripts (ls /master/Dropbox/Zotero/Universit@/DB-Laboratorio/biblioteca/sql/ | grep '.sql' | sort)

		case 'h00k'
			if not set -q mysql_password
				set -Ux mysql_password "tomtom"
			end
			set -g sql_scripts (ls $HOME/Scrivania/GIT/biblioteca/sql | grep '.sql' | sort)
		
		case 'root'
			set_color -o red; and echo "Attenzione: stai eseguendo questo script come root. [ABORT]"
			return 1

		case *
			set_color -o red; and echo "Attenzione: stai eseguendo questo script in un host non autorizzato. [ABORT]"
			return 1
	end
	set -g mysql_user 'root'
	set -g mysql_database 'BIBLIOTECA'
	return 0
end




function rebuild_db
	var_switcher_by_host (whoami)
	if [ $status -eq '1' ]
		return 1
	end
	# fallthrough se non si e' root e se si e' autorizzati ad eseguire gli script sql
	for script in $sql_scripts
		mysql -u $mysql_user --password=$mysql_password $mysql_database < $script
		if [ $status -eq '0' ]
			set_color -o white; and echo "Script $script eseguito con successo."
		else
			set_color -o red; and echo "Attenzione: lo script $script non e' stato eseguito con successo. [ABORT]"
			return 1
		end
	end
	set_color -o green; and echo "Database $mysql_database ricostruito con successo."
	return 0
end
	

