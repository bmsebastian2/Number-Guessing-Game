#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess_game --no-align --tuples-only -c"

# Solicitar al usuario que ingrese un nombre de usuario
echo "Enter your username:"
read username

ADIVINAR_NUMERO(){     
    objetivo=$1
    id_user=$2    
    echo $objetivo
     # Imprimir el número aleatorio (opcional)
    intentos=0
    while true; do
        read -p "Guess the secret number between 1 and 1000:" numero
        if ! [[ "$numero" =~ ^-?[0-9]+$ ]]; then
            echo "That is not an integer, guess again:"
            continue
        fi
        intentos=$((intentos + 1))
        if [ "$numero" -eq "$objetivo" ]; then
            echo You guessed it in $intentos tries. The secret number was $1. Nice job!
            ADD_GAME $intentos $id_user
            break
        elif [ "$numero" -lt "$objetivo" ]; then
            echo "It's higher than that, guess again:"
        else
            echo "It's lower than that, guess again:"
        fi
    done 
   
}

CONSULTAR_USER(){
    local RESULT=$($PSQL "SELECT id_user, name_user FROM users WHERE name_user='$1'")
   
    if [[ ! -z $RESULT ]]
    then
       read ID_USER NAME_USER <<< $(echo $RESULT | sed 's/[|]/ /g')
        echo $ID_USER
    else
           
        echo "" 
  fi   
}
CONSULTAR_GAMER_USER(){
     local RESULT=$($PSQL "SELECT COUNT(*) AS cantidad FROM games WHERE id_user=$1")
     local NAME=$($PSQL "SELECT name_user FROM users WHERE id_user=$1")
     local BEST_GAME=$($PSQL "SELECT MIN(num_int) AS bestgame FROM games WHERE id_user=$1")

     read GAMES_PLAYED <<< $(echo $RESULT | sed 's/[|]/ /g')
     read NAME_PLAYED <<< $(echo $NAME | sed 's/[|]/ /g')
     read BEST <<< $(echo $BEST_GAME | sed 's/[|]/ /g')
     echo "Welcome back, $NAME_PLAYED! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses., with $NAME_PLAYED"
}
ADD_USE(){
   local add_user=$($PSQL "INSERT INTO users(name_user) VALUES('$1')")   
   echo Welcome, $1! It looks like this is your first time here.  
}
ADD_GAME(){
  local add_game=$($PSQL "INSERT INTO games(num_int, id_user) VALUES($1,$2)") 
}
# Validar que el nombre de usuario tenga 22 caracteres o menos

if [ ${#username} -le 22 ]; then
    resultado=$(CONSULTAR_USER $username)
    if [ -z "$resultado" ]; then
      ADD_USE $username
      ADIVINAR_NUMERO  $(( (RANDOM % 1000) + 1)) $(CONSULTAR_USER $username)  
    else
      CONSULTAR_GAMER_USER $resultado
      ADIVINAR_NUMERO  $(( (RANDOM % 1000) + 1)) $(CONSULTAR_USER $username)  
    fi
      
else
    echo "Error: El nombre de usuario no debe tener más de 22 caracteres."
fi

