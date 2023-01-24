#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

MAIN_MENU(){
  for (( i = 1; i < 4; i++ ))
  do
    NUMBER_SERVICE=$($PSQL "SELECT service_id FROM services WHERE service_id = $i;")
    NAME_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $i;")
    echo "$NUMBER_SERVICE) $NAME_SERVICE"
  done

  read SERVICE_ID_SELECTED
  SERVICE_ID_SELECTED=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED;")

  if [[ -z $SERVICE_ID_SELECTED ]]
  then
    MAIN_MENU 
  else
    echo -e "\nEnter your phone number: "
    read CUSTOMER_PHONE
    VERIFICATE_NUMBER=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")
  
    if [[ -z $VERIFICATE_NUMBER ]]
    then
        echo -e "\nEnter your name: "
        read CUSTOMER_NAME
        INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
        VERIFICATE_NUMBER=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")
    fi
    
    echo -e "\nEnter your service time: "
    read SERVICE_TIME
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', $VERIFICATE_NUMBER, $SERVICE_ID_SELECTED);")
    if [[ $INSERT_APPOINTMENT = "INSERT 0 1" ]]
    then
      SERVICE_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
      NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $VERIFICATE_NUMBER;")
      echo "I have put you down for a $SERVICE_SELECTED at $SERVICE_TIME, $NAME."
    fi
  fi

}

MAIN_MENU
