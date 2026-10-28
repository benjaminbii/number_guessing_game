#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read -r USERNAME
SQL_USERNAME=${USERNAME//\'/\'\'}
# Check whether the username exists.
USER_INFO=$($PSQL "SELECT games_played, best_game FROM users WHERE username='$SQL_USERNAME'")

if [[ -z "$USER_INFO" ]]; then
  # Create a new user.
  INSERT_USERNAME=$($PSQL "INSERT INTO users (username) VALUES ('$SQL_USERNAME')")

  if [[ "$INSERT_USERNAME" == "INSERT 0 1" ]]; then
    echo "Welcome, $USERNAME! It looks like this is your first time here."
  else
    echo "There was a problem creating your user."
    exit 1
  fi
else
  # Welcome back an existing user.
  IFS='|' read -r GAMES_PLAYED BEST_GAME <<< "$USER_INFO"

  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Generate a random secret number between 1 and 1000.
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))

echo "Guess the secret number between 1 and 1000:"

NUMBER_OF_GUESSES=1
read -r GUESS

# Keep asking until the user enters the correct integer.
while [[ ! "$GUESS" =~ ^[0-9]+$ ]] || (( GUESS != SECRET_NUMBER )); do
  if [[ ! "$GUESS" =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
  elif (( GUESS > SECRET_NUMBER )); then
    echo "It's lower than that, guess again:"
  else
    echo "It's higher than that, guess again:"
  fi

  read -r GUESS
  ((NUMBER_OF_GUESSES++))
done

echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

# Update the user's statistics.
UPDATE_RESULT=$($PSQL "UPDATE users
SET games_played = games_played + 1,
    best_game = CASE
      WHEN best_game IS NULL OR best_game > $NUMBER_OF_GUESSES
      THEN $NUMBER_OF_GUESSES
      ELSE best_game
    END
WHERE username = '$SQL_USERNAME'")
