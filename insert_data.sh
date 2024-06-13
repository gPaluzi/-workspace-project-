#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YR RD WN OP WG OG
do
  if [[ $WN != "winner" ]]
  then
    WN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WN'")
  
    # if does not exist
    if [[ -z $WN_ID ]]
    then
      # insert that exist
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WN')")
      
      # get new id
      WN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WN'")
    fi

    OP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OP'")
  
    # if does not exist
    if [[ -z $OP_ID ]]
    then
      # insert that exist
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OP')")

      # get new id
      OP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OP'")
    fi

  INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YR', '$RD', $WN_ID, $OP_ID, '$WG', '$OG')")   
fi
done