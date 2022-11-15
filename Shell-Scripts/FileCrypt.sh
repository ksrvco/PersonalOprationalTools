#!/bin/bash
# Tool name: FileCrypt - Encrypt files and directories
# Written by: KsrvcO
# Version: 1.0
# Tested on: Debian based linux systems
# Contact me: flower.k2000@gmail.com
# This tool can decrypt files that encrypted by this tool.
# Make sure that gnupg installed on your system.
reset
echo -e "
·▄▄▄▄   ▄▄▄· ▄▄▄▄▄ ▄▄▄·  ▄▄· ▄▄▄   ▄· ▄▌ ▄▄▄·▄▄▄▄▄
██▪ ██ ▐█ ▀█ •██  ▐█ ▀█ ▐█ ▌▪▀▄ █·▐█▪██▌▐█ ▄█•██
▐█· ▐█▌▄█▀▀█  ▐█.▪▄█▀▀█ ██ ▄▄▐▀▀▄ ▐█▌▐█▪ ██▀· ▐█.▪
██. ██ ▐█ ▪▐▌ ▐█▌·▐█ ▪▐▌▐███▌▐█•█▌ ▐█▀·.▐█▪·• ▐█▌·
▀▀▀▀▀•  ▀  ▀  ▀▀▀  ▀  ▀ ·▀▀▀ .▀  ▀  ▀ • .▀    ▀▀▀
                                         by KsrvcO
[+] Tool name: FileCrypt - Encrypt files and directories
[+] Written by: KsrvcO
[+] Version: 1.0
[+] Tested on: Debian based linux operation systems
1. Encrypt directory
2. Decrypt directory
3. ByeBye
"
read -p "[+] Choose an option: " option
if [ $option == 1 ]
	then
		read -p "[!] Give me your directory (ex: /home/user/docs): " files
		tar czf encrypted_data.tar.gz $files
		read -s -p "[!] Enter your strong password for encrypt your files: " encpass
		echo ""
		gpg --batch -c --passphrase $encpass encrypted_data.tar.gz 2>/dev/null
		rm -rf rm archived_data.tar.gz
		echo "[!] File encrypted successfully with name encrypted_data.tar.gz.gpg"
		read -p "[!] Do you want to delete files directory? (y/n): " question
		if [ $question == "y" ]
			then
				rm -rf encrypted_data.tar.gz
				rm -rf $files
				echo "[!] $files removed successfully."
				exit
		elif [ $question == "n" ]
			then
				exit
		else
			exit
		fi
elif [ $option == 2 ]
	then
		read -p "[!] Give me your encrypted file: " encfile
		read -s -p "[!] Enter your password for decrypt your file: " encryptedpass
		echo ""
		gpg --batch --yes --passphrase $encryptedpass --output decrypted_data.tar.gz --decrypt $encfile 2>/dev/null
		tar xvf decrypted_data.tar.gz
		echo "[!] Decrypted successfully."
		rm -rf decrypted_data.tar.gz
		rm -rf $encfile
elif [ $option == 3 ]
	then
		exit
fi
exit