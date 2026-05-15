#!/bin/bash
release_file=/etc/os-release

echo "Hello User : $USER"
cat dot.art

echo "===EXAMPLE COMMANDS=== "
echo "___________________________________________"
echo "| listclones                              |"
echo "| remove <repo> <command name>            |"
echo "| TYPE COMMAND : nmap.. etc               |"
echo "|/etc/apt for directory or any directory  |"
echo "|_________________________________________|"


while true; do
	echo
	read -p "ENTER COMMAND ( PRESS Q TO QUIT ) : " command

	[[ "$command" == "q" || "$command" == "quit" ]] && break
       [[ -z "$command" ]] && echo " NO COMMAND. TRY AGAIN. " && continue

#GITHUB URL AUTO CLONNING

if [[ "$command" == https://github.com/* ]] || [[ "$command" == git@github.com:* ]]; then
	echo "GITHUB URL FOUND.... CLONING...."
	git clone "$command"

	if [ $? -eq 0 ]; then
		echo "[+] SUCCESSFULLY CLONED!"
		repo_name=$(basename "$command" .git)

		if [ -f "$repo_name/requirements.txt" ]; then
			echo "INSTALLING REQUIREMENTS..."
			pip3 install -r "$repo_name/requirements.txt" --break-system-packages

			if [ $ -eq 0 ]; then
				echo "[+] REQUIREMENTS SUCCESSFULLY INSTALLED."
			else
				echo "[-] REQUIREMENTS INSTALLATION FAILED."
			fi
		else
			echo "NO REQUIREMENTS FOUND."
		fi
	else
		echo "[-] FAILED CLONING"
	fi


	 #REMOVE REPO
elif [[ "$command" == "remove "* ]] || [[ "$command" == "rm "* ]]; then
	repo="${command#* }"
	if [ -d "$repo" ]; then
		read -p "DELETE REPO '$repo'? (y/n) : " confirm
	       if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
	rm -rf "$repo"

	if [ $? -eq 0 ]; then
		echo "'$repo' SUCCESSFULLY REMOVED"
	else
		echo "FAILED TO REMOVE : '$repo'"
	fi
else
	echo "CANCELLED"
	       fi
       else
	       echo "'$repo' NOT FOUND"
	fi




elif [[ "$command" == "listclones" ]]; then
	echo " ======CLONED REPOS====="
	for dir in */; do
		if [ -d "$dir/.git" ]; then
			echo "[+] $dir"
		fi
	done

elif command -v "$command" &> /dev/null; then
	echo "THE COMMAND IS AVAILABLE : '$command'"
	echo "=====RUNNING COMMAND====="
	"$command"
	echo "EXIT CODE : $?"

elif [ -d "$command" ]; then
	echo "COMMAND IS DIRECTORY : '$command'"
	sudo apt update -y "$command"
	ls "$command"
	echo "EXIT CODE : $?"


elif [ -f "$command" ]; then
	echo "COMMAND IS A REGULAR FILE: '$command'"
	echo "RUNNING FILE//////...."
	bash "$command"
	echo "THE EXIT CODE : $?"


elif [ -b "$command" ]; then
	echo "COMMAND IS A BLOCK"


else
	echo "'$command' NOT FOUND. ATTEMPTING TO INSTALL..."
	sudo apt install -y "$command" 

	if [ $? -eq 0 ] && command -v "$command" &> /dev/null; then
		echo "[+] SUCCESSFULLY INSTALLED : '$command'"
		echo "=====RUNNING COMMAND====="

		"$command"
	else
		echo "[-] INSTALLATION FAILED"

	fi
fi

echo
echo "COMMAND LOCATION : $(which "$command" 2>/dev/null || echo ' PATH NOT FOUND ' )"

done


echo "THANK YOU"








