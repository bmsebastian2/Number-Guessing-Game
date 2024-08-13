#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess_game --no-align --tuples-only -c"

# Solicitar al usuario que ingrese un nombre de usuario
echo "Enter your username:"
read username

ADIVINAR_NUMERO(){     
    objetivo=$1
    id_user=$2
    echo $id_user
     # Imprimir el número aleatorio (opcional)
    intentos=0
    while true; do
        read -p "Guess the secret number between 1 and 1000:" numero
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
      # else notify the absence of the symbol       
        echo "" 
  fi   
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
      ADIVINAR_NUMERO  $(( (RANDOM % 1000) + 1)) $(CONSULTAR_USER $username)  
    fi
      
else
    echo "Error: El nombre de usuario no debe tener más de 22 caracteres."
fi

