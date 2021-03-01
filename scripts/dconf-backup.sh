#!/usr/bin/env bash
echo "Dconfig Importer/Exporter"
echo ""
echo "The file will be saved and loaded from your home directory."
PS3='Please enter your choice: '
options=("Export Dconf file." "Import Dconf file." "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Export Dconf file.")
        	cd ~
		dconf dump / > saved_settings.dconf
		echo "Done. The file is located in home directory."
            ;;
        "Import Dconf file.")
           	cd ~
		dconf load / < saved_settings.dconf
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
