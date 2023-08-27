#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

MAKE_QUERY() {
  # Get the properties of the element depending on the argument
  SELECTED_ELEMENT=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE $1 = '$2'")
}

OUTPUT() {
  # Output the message only if the element is in the database
  if [[ -z $2 ]]; then
    # no argument has been provided
    echo "Please provide an element as an argument."
  
  elif [[ -z $1 ]]; then
    echo "I could not find that element in the database."
  
  else
    echo "$1" | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done

  fi
}


if [[ $1 =~ ^[0-9]+$ ]]; then
  # argument is a number
  MAKE_QUERY 'atomic_number' $1

elif [[ $(echo "$1" | wc -m) -le 3 ]]; then
  # argument is a single letter
  MAKE_QUERY 'symbol' $1

else
  # argument is a word
  MAKE_QUERY 'name' $1

fi

OUTPUT "$SELECTED_ELEMENT" $1
