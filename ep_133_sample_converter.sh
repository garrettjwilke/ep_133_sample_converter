#!/usr/bin/env bash

req-check() {
  declare -a REQUIREMENTS=("sox" "ffmpeg")
  for i in "${REQUIREMENTS[@]}"
  do
    REQ_TEST=$(which $i)
    if [ "$REQ_TEST" == "" ]
    then
      message "Install $i" "$i is not installed. install $i from your package manager."
      exit
    fi
  done
}

help-menu() {
cat <<EOF

          ---------------------------
            ep-133 sample converter
          ---------------------------

EOF
}

message() {
  cat <<EOF
  
            -${1}-

    $2

EOF
}

arg-check() {
  #COUNTER=0
  COUNTER=$(echo $@ | wc -w | xargs)
  if [ $COUNTER -gt 1 ]
  then
    message "ERROR" "you can only convert one file at a time. run with --help for options"
    exit
  fi
  if [ "$1" == "" ]
  then
    message "ERROR" "you must input a file. run with --help for options"
    exit
  elif [ "$1" == "--help" ] || [ "$1" == "-h" ]
  then
    help-menu
    exit
  fi
  sox --info $1
  if [ $? -gt 0 ]
  then
    message "ERROR" "not a valid audio file"
    exit
  fi
}

convert_file() {
  INPUT_FILE=$1
  OUTPUT_FILE=${INPUT_FILE%.*}
  sox $INPUT_FILE -c 1 -r 46875 -b 16 ${OUTPUT_FILE}_ep-133.wav #speed 2.0
}

req-check
arg-check $@
convert_file $1
