# TicTacToe.sh

#!/usr/bin/bash

player_one="X"
player_two="O"

turn=1
game_on=true
winner_found=false

moves=( 1 2 3 4 5 6 7 8 9 )

display_board () {
  clear
  echo " ${moves[0]} | ${moves[1]} | ${moves[2]} "
  echo "-----------"
  echo " ${moves[3]} | ${moves[4]} | ${moves[5]} "
  echo "-----------"
  echo " ${moves[6]} | ${moves[7]} | ${moves[8]} "
  echo "-----------"
  echo "Write 'save' to save game"
  echo "Write 'load' to load game"
}

player_pick() {
  if [[ $(($turn % 2)) == 0 ]]
  then
     play=$player_two
     echo -n "${player_two} PICK A SQUARE: "
  else
     echo -n "${player_one} PICK A SQUARE: "
     play=$player_one
  fi
  read input
  
  if [[ $input == "save" ]]
  then
     echo "${moves[@]}" > GameSave.txt
  return
  fi
  
  if [[ $input == "load" ]]
  then
     read -r -a characters <GameSave.txt || (( ${#characters[@]} ))
     n=0
     for character in "${characters[@]}"; do
        moves[$n]=$character
        n=$n+1
     done
     
     return
  fi
  
  index=$((input-1))
  if [[ ! $input =~ ^-?[0-9]+$ ]] || [[ "${moves[$index]}" == "X" ]] || [[ "${moves[$index]}" == "O" ]]
  then 
     echo "Not a valid square."
     player_pick
  else
     moves[($input - 1)]=$play
     turn=$((turn + 1))
  fi
}

check_winner() {
  for i in 0 3 6
  do
     check_match i i+1 i+2
  done

  check_match 0 4 8
  check_match 2 4 6
  check_match 0 3 6
  check_match 1 4 7
  check_match 2 5 8

  if [ $turn -gt 9 ]; then 
     $game_on=false
     echo "Its a draw!"
  fi
}

check_match() {
  if [ $winner_found == true ] 
  then
      return
  else
    if  [[ ${moves[$1]} == ${moves[$2]} ]]&& \
        [[ ${moves[$2]} == ${moves[$3]} ]]; then
      game_on=false
    fi
    if [ $game_on == false ]; then
      if [ ${moves[$1]} == "X" ] && [ ${moves[$2]} == "X" ] && [ ${moves[$3]} == "X" ]
      then
         echo "${player_one} wins!"
         $winner_found = true
         return 
      fi
      if [ ${moves[$1]} == "O" ] && [ ${moves[$2]} == "O" ] && [ ${moves[$3]} == "O" ]
      then
         echo "${player_two} wins!"
         $winner_found = true
         return 
      fi
    fi
  fi
}

display_board
while $game_on
do
  player_pick
  display_board
  check_winner
done
