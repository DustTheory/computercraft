#!/bin/sh

# Get all .lua files in .
luaFiles=( $DIR*.lua )

#region Remove gitFetch and gitRepo from the array
declare -a tmp
declare -i count=0

for file in ${luaFiles[@]};
do
  if [ $file != "gitRepo.lua" ] && [ $file != "gitFetch.lua" ]
  then
    tmp[count]=$file
    count=count+1
  fi
done

luaFiles=${tmp[@]}
#endregion

# Get position of the last file
pos=$((${#luaFiles[@]} - 1))
last=${luaFiles[$pos]}

echo -e "GitLuaFiles = {" > gitRepo.lua

for file in ${luaFiles[@]}; do
  if [ $file == $last ]
  then
    echo -e "\t\"$file\"" >> gitRepo.lua
    break
  else
    echo -e "\t\"$file\"," >> gitRepo.lua
  fi 
done

echo "}" >> gitRepo.lua