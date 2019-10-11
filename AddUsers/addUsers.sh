#!/bin/bash
# ======================
# Bash script program to add multiple users in batch mode
#
#      STUDENT: Phuong Cam
# DATE CREATED: March 26, 2018
################################################################################

################################################################################
# Empty users array -- use with an input file. 
# Use when manual array is not in use 

# Index for inputting users into the users array
i=0

# Read files direct as an argument
file="$1"

#  Two-way conditional: if the "file" exists, read each line, add the user to
# the users array and lastly redirect the file stdin to done
if [ -e "$file" ]
then
     # while-loop
     while read -r line
     do
          # while line exists add to users array according the index number
          users[i]="$line"
          # increment by 1
          i=$(( i+1 ))

     done < "$file"

else
     #If input file doesn't exist exit this program with exit status 1
     exit 1
fi

##################################################################################
# Go through the users array and check is each user exists and if not, add to the
# system

# Variable that counts the number of total users added to the system
totalUsers=0

#foreach-loop
for user in ${users[@]}
do
     # function to check if userid is present in system
     # Redirect the stdout and stderr into /dev/null 
     user_exists=$(id -u $user > /dev/null 2>&1; echo $?)

     # if user already exists
     if [ $user_exists -eq 0 ]
     then
          # print the userid that already exists
          echo "$user already exists"
     else
          # add user with an assigned home directory under /home and 
          # assigned bash as default shell login
          sudo useradd -m -s /bin/bash $user
          # see the default password the same as userid
          echo $user:$user | sudo chpasswd
          # print "Added a user, <userid>" after users added
          echo "Added a user, $user"
          # increment by 1 when a user is added
          totalUsers=$(( totalUsers+1 ))
          # print the total amount of users added
          echo "Total $totalUsers users added"

     fi
done
