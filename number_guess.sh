#!/bin/bash

numero_aleatorio=$(( (RANDOM % 1000) + 1))


# Solicitar al usuario que ingrese un nombre de usuario
echo "Enter your username:"
read username

# Validar que el nombre de usuario tenga 22 caracteres o menos
if [ ${#username} -le 22 ]; then
    echo "Nombre de usuario aceptado: $username"
    # Imprimir el número aleatorio (opcional)
    echo "El número aleatorio generado es: $numero_aleatorio"
    echo "Guess the secret number between 1 and 1000:"
    read number
else
    echo "Error: El nombre de usuario no debe tener más de 22 caracteres."
fi

