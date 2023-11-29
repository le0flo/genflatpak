#!/bin/bash

appIDs=()

while IFS= read -r line; do
    appIDs+=( "$line" )
done < <( flatpak list --app --columns=application | grep -v "Application ID" )

appNames=()

while IFS= read -r line; do
    appNames+=( "$line" )
done < <( flatpak list --app --columns=name | grep -v "Name" )

appNum=${#appIDs[@]}

dir="$( getent passwd "$USER" | cut -d: -f6 )/.config/flatpakApps"

[ -d $dir ] || mkdir -p $dir

if [ $# -eq 0  ];
then
	for (( i=0; i<=$appNum-1; i++ ))
	do
    		file="$dir/${appIDs[$i]}.sh"
    		touch $file
    		echo "" > $file
    		echo '#!/bin/bash' >> $file
    		echo "flatpak run ${appIDs[$i]}" >> $file

    		chmod +x $file

    		linkname=( ${appNames[$i]} )
    		link="/usr/bin/${linkname[0]}"
		
		echo ${link,,}
    		sudo ln $file ${link,,} 2> /dev/null
	done

	echo "Links created successfully"
else
	for (( i=0; i<=$appNum-1; i++ ))
	do
		linkname=( ${appNames[$i]} )
		link="/usr/bin/${linkname[0]}"
		
		echo ${link,,}
		sudo rm -rf ${link,,}
	done

	echo "Links deleted successfully"
fi
