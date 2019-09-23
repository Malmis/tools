#!/bin/bash
# Shellscript för nedladdning av filmer eller tv-serier med hjälp av svtplay-dl
# kristoffer@malmstrom.xyz, 2019

for arg in "$@"
do
  if  [ "$arg" == "-h" ]
  then
        echo "Kör ´./svtplay filmer.txt´ eller ´./svtplay serier.txt´ för att ladda ned innehållet från textfil."
  else
   if [ "$arg" == "filmer.txt" ] || [ "$arg" == "serier.txt" ]
    then
        if [ ! -f "$arg" ]
         then
                echo "Filen $arg existerar inte."
         else
          if [ ! -s "$arg" ]
           then
                echo "Filen $arg har inget innehåll."
            elif [ "$arg" == "filmer.txt" ]
            then
                 xargs -l svtplay-dl -S -M < "$arg"
            elif [ "$arg" == "serier.txt" ]
            then
                 xargs -l svtplay-dl -S -M -A < "$arg"
            fi
         fi
    fi
  fi
done