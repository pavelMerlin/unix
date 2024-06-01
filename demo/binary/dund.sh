#!/bin/bash


port=8080
curl_deploy=false
curl_undeploy=false


tomcat_path=/home/radnere/tomcat
webapps=webapps
script_path=$(readlink -f "$0")
script_dir=$(dirname "$script_path")
war_file_path=$(find "$script_dir" -type f -name "*.war")
war_filename="$(basename "$war_file_path")"


function undeploy {
  apps_directory="$tomcat_path""/""$webapps""/"
  deployed_file="$apps_directory""$war_filename"
  if [ -f "$deployed_file" ]
  then
    rm "$deployed_file"
    echo "$war_filename was removed"
  else
    echo "$war_filename was not found in $apps_directory"
  fi

  deployed_directory="${deployed_file%.*}"
  if [ -d "$deployed_directory" ]
  then
    directory="${deployed_directory%.*}"
    rm -R "$directory"
    echo "${war_filename%.*} was removed from $apps_directory"
  else
    echo "${war_filename%.*} was not found in $apps_directory"
  fi
}


function deploy {
  if [ ! -f "$war_file_path" ]
  then
    echo "$war_filename was not found"
    echo "Check if it is in the directory with this script"
    exit 1
  fi

  apps_directory="$tomcat_path""/""$webapps""/"
  cp "$war_file_path" "$apps_directory"
  echo "$war_filename was placed in $apps_directory"
}


for opt in "$@"
do
  case $opt in
    -u)
      echo "Try to undeploy"
      undeploy
      ;;
    -d)
      echo "Try to deploy"
      deploy
      ;;
    -p)
      tomcat_path=$2
      ;;
    --uc)
      echo "Undeploy using curl"
      curl_undeploy=true
      ;;
    --dc)
      echo "Deploy using curl"
      curl_deploy=true
      ;;
    --un=*)
      username=${1#*=}
      ;;
    --pw=*)
      password=${1#*=}
      ;;
    --port=*)
      port=${1#*=}
      ;;
    *)
      echo "Unknown command"
  esac
  shift
done

if [ $curl_deploy = "true" ] && [[ -n ${username+x} ]] && [[ -n ${password+x} ]]
then
  res=$(curl -o /dev/null -s -w "%{http_code}" -u "$username"":""$password" http://localhost:"$port"/manager/text/deploy?path=/"${war_filename%.*}""&war=file:""$war_file_path""&update=true")
  echo "Response:"
  echo $res
fi

if [ $curl_undeploy = "true" ] && [[ -n ${username+x} ]] && [[ -n ${password+x} ]]
then
  res=$(curl -o /dev/null -s -w "%{http_code}" -u "$username"":""$password" http://localhost:"$port"/manager/text/undeploy?path=/"${war_filename%.*}")
    echo "Response:"
    echo $res
fi