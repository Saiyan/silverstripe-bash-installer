#!/bin/bash

#Repository; folder; displayname
installer="https://github.com/silverstripe/silverstripe-installer.git"
framework="https://github.com/silverstripe/silverstripe-framework.git"
cms="https://github.com/silverstripe/silverstripe-cms.git"

#Menu Repository; folder +  displayname
modules=()
modules+=("https://github.com/silverstripe-labs/silverstripe-newsletter.git;newsletter")
modules+=("https://github.com/silverstripe/silverstripe-userforms.git;userforms")
modules+=("https://github.com/silverstripe-labs/silverstripe-subsites.git;subsites")
modules+=("https://github.com/silverstripe-labs/silverstripe-secureassets.git;secureassets")
modules+=("https://github.com/silverstripe/silverstripe-spamprotection.git;spamprotection")
modules+=("https://github.com/silverstripe/silverstripe-mathspamprotection.git;mathspamprotection")

count=0
selectedmodules=()


getModuleName(){
    if [[ -z $1 ]]; then return; fi
    index=$1
    IFS='; ' read -a repo <<< ${modules[$index]}
    echo "${repo[1]}"
}

getModuleRepo(){
    if [[ -z $1 ]]; then return; fi
    index=$1
    IFS='; ' read -a repo <<< ${modules[$index]}
    echo "${repo[0]}"
}


count=0

#show menu with all available modules
for i in ${modules[@]}
do
     echo "[$count] $(getModuleName $count)"
     count=$((count+1))
done

echo "Please choose Modules"
#read user input for selected modules. each line == one number
while read input
do
    if [ -z "$input" ]; then break; fi
    if [[ $input =~ ^-?[0-9]+$ && -n ${modules[$((input-0))]}  ]];then
        selectedmodules+=($((input-0)))
    else
        echo "N/A"
    fi
done

#show selected modules
count=0
selmodline="Modules selected: "
for i in ${selectedmodules[@]}
do
    if [ -n ${modules[$i]} ]; then
        #IFS='; ' read -a repo <<< ${modules[$i]}
        selmodline+="$(getModuleName $i) "
    fi
    count=$((count+1))
done
echo "$selmodline"

echo "Please enter folder-name for your project"

read project

echo "Are you sure you want to install silverstripe and create the folder $project in $PWD [Y/n]"

read yn
if [[ $yn != "Y" ]]; then exit;fi

echo "ok lets go"

git clone $installer $project

cd $project
git submodule add $framework framework
git submodule add $cms cms

count=0
for i in ${selectedmodules[@]}
do
    if [ -n ${modules[$i]} ]; then
        git submodule add $(getModuleRepo $i) $(getModuleName $i)
    fi
    count=$((count+1))
done


