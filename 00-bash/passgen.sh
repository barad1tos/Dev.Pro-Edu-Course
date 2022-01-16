#!/bin/bash

echo "Password Generator Script"

PS3="Select the operation: "

select opt in special_characters no_special_characters ; do

  case $opt in
    special_characters)
      read -r "Enter the length of password: " p1
      openssl rand -base64 14 | cut -c1-"$p1"
      ;;
    no_special_characters)
      read -r "Enter the length of password: " p2
      openssl rand -hex 14 | cut -c1-"$p2"
      ;;
    quit)
      break
      ;;
    *) 
      echo "Invalid option $REPLY"
      ;;
  esac
done
