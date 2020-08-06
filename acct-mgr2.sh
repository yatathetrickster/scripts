#!/bin/bash

# Need a main menu allows user to choose different account management functions
# Needs a main menu
# Need to take input from user
# Need to have logic that uses user input as driving force to move to that specific function
# Need to check for admin rights 

##########################################################################
#FUNCTIONS
##########################################################################

add_rem() {

# Add user functionality
# Remove user functionality
# Check for pre-existing user
# Jump to main menu function
# Exit program

clear

echo "

Add/Remove Users
*****************

1) Add User
2) Remove User
3) List Users

M) Main Menu
X) Exit Program

"

read -p "Please choose option   ...>" add_rem_opt

if [ $add_rem_opt = "1" ]; then 
        read -p "Enter first name...> " add_rem_first
        read -p "Enter last name...>" add_rem_last
        add_rem_name="$add_rem_first $add_rem_last"
        add_rem_chk=$(grep "add_rem_name" /etc/passwd | awk -F: '{print $5}' | cut -d "," -f1)
        if [ "$add_rem_name" != "$add_rem_chk" ]; then
            echo "User $add_rem_name is good to use"
            read -p "Enter username for $add_rem_name ...>" add_rem_username
            /usr/sbin/useradd -c "$add_rem_name" -m -s /bin/bash -d /home/$add_rem_username -U $add_rem_username
            echo "User $add_rem_username successfully added."
            read -p "Press Enter to continue"
            add_rem
        elif [ "$add_rem_name" = "$add_rem_chk"]; then
                echo "User $add_rem_name already exists"
                read -p "Press ENTER to continue"
                add_rem 
        fi
elif [ $add_rem_opt = "2" ]; then
       read -p "Enter username to remove...>" add_rem_username
       read -p "Remove $add_rem_username? [y/n]...>" rem_conf
       case $rem_conf in
            y|Y)    userdel -r $add_rem_username
                    read -p "$add_rem_username successfully removed. Press ENTER to continue"
                    add_rem
                    ;;
            n|N)    add_rem
                    ;;
            *)      read -p "That is not a valid option. Press ENTER to continue" 
                    add_rem
                    ;;
        esac
elif [ $add_rem_opt = "3" ]; then
        var1=$(cat /etc/passwd | awk -F: '{print $1}')
        echo $var1
        read -p "Press ENTER to continue"
        add_rem
elif [[ $add_rem_opt = [mM]    ]]; then
        main_menu
elif [[ $add_rem_opt = [xX] ]; then
        exit
else
        echo "Soemthing went wrong"
fi

}

def_shell() {
# Find the given user's current default shell
# Print usable shells
# change shell functionality

clear

echo "
Default Shell Change
********************

-----------------
| bash zsh  csh |
| xiki tcsh ksh |
-----------------

1) Change Shell

M) Main Menu
X) Exit Program

"
read -p "Please choose option...>" def_shell_opt

if [ "$def_shell_opt" = "1" ]; then
        read -p "Enter the username...>" def_shell_user
        read -p "Desired default shell...>" def_shell_shell
        curernt_shell=$(grep ^$def_shell_user /etc/passwd | gawk -F: '{print $7}')
        echo "Current Shell: " $current_shell
        sed -i '/'"$def_shell_user"'/s,'"$current_shell"',\/bin/'"$def_shell_shell"',' /etc/passwd 
        echo "Default shell changed from $current_shell to /bin/$def_shell_shell"
        new_shell=$(grep ^$def_shell_user /etc/passwd | gawk -F: '{print $1,$7}')
        echo $new_shell
        read -p "Press ENTER to continue"
        def_shell
elif [[ "$def_shell_opt" = [mM] ]]; then
        main_menu
elif [[ "def_shell_opt" = [xX] ]]; then
        exit
else
        echo "Invalid Option: $def_shell_opt"
        read -p "Press ENTER to continue"
        def_shell
fi
}

reset_pass() {
clear

echo "
Password Reset Tool
*******************

1) Check Password Status
2) Change Password
3) Remove Password

M) Main Menu
X) Exit Program
"
read -p "Please choose option...>" reset_pass_opt

case $reset_pass_opt in
        1)      echo
                read -p "Enter username...>" uzr
                passwd -S $uzr
                read -p "Press ENTER to continue"
                reset_pass
                ;;
        2)      echo
                read -p "Enter username...>" uzr
                passwd $uzr
                read -p "Press ENTER to continue"
                reset_pass
                ;;
        3)      echo
                read -p "Enter username...>" uzr
                passwd -d $uzr
                read -p "Press ENTER to continue"
                reset_pass
                ;;
        m|M)    main_menu ;;
        x|X)    clear
                exit ;;
        *)      echo
                read -p "Invalid option: $reset_pass_opt . Press ENTER to continue"
                reset_pass
                ;;
esac

}

acct_lock() {

# Lock functionality
# Unlock functionality
# Lock status check
# main menu function
# exit function

clear

echo "
Account (un)Lock Tool
*********************

1) Lock Account
2) Unlock Account
3) Check Account Lock Status

4) Main Menu
5) Exit

"
read -p "Please Choose Option...>" acct_lock_opt

case $acct_lock_opt in
        1)      echo 
                read -p "Enter username...>" uzr
                chage -E 0 $uzr
                read -p "Press ENTER to continue"
                acct_lock
                ;;
        2)      echo
                read -p "Enter username...>" uzr
                chage -E -1 $uzr
                read -p "Press ENTER to continue"
                acct_lock
                ;;
        3)      echo 
                read -p "Enter username...>" uzr
                ch_date=$(chage -l $uzr | grep ^Account | gawk -F: '{print $2}' | gawk '{print $1,$2,$3}' | sed 's/,//')
                if [ "$ch_date" = "never" ] || [ "$ch_date" = "never " ]; then
                        echo "!!! Account is UNLOCKED!!!"
                        echo "Password expiration date: $ch_date"
                        read -p "Press ENTER to continue"
                        acct_lock
                else
                        ch_date_convert=$(date -d "$ch_date" "+%Y-%m-%d")
                        ch_date_seconds=$(date -d $ch_date_convert +%s)
                        tday=$(date +%F)
                        tday_seconds=$(date -d $tday +%s)
                        if [ "$ch_date_seconds" -le "$tday_seconds" ]; then
                                echo "!!! Account is LOCKED"
                                echo "Password expiration date: $ch_date"
                                read -p "Press ENTER to continue"
                                acct_lock
                        else
                                echo "!!! Account is UNLOCKED!!!"
                                echo "Password expiration date: $ch_date"
                                read -p "Press ENTER to continue"
                                acct_lock
                fi
                ;;
        m|M)    main_menu ;;
        x|X)    exit ;;
        *)


}

ch_name() {

# Change usernames
# Change Full names
# Main menu function
# exit program function

clear

echo "

Change Name Tool
****************

1) Change Username
2) Change Full Name

M) Main Menu
X) Exit Program

"
read -p "Please choose option...>" ch_name_opt

case $ch_name_opt in 
        1)      echo
                read -p "Please enter username...>" uzr
                read -p "Please enter desired username...>" usr_new
                usermod -l $uzr_new $uzr_new
                read -p "Press Enter to continue"
                ch_name
                ;;
        2)      echo
                read -p "Please enter username...>" uzr
                echo $uzr
                full_name=$(grep "$uzr": /etc/passwd | gawk -F: '{print $5}' | cut -d "," -f1)
                echo "The current full name associated with $uzr is: $full_name"
                first_name=$(echo $full_name | gawk '{print $1}')
                last_name=$(echo $full_name | gawk '{print $2}')
                read -p "
                Change Name Options
                1) First Name
                2) Last Name
                3) None
                " fname_opt
                cast $fname_opt in
                        1)  read -p "Enter new FIRST name...>" new_first_name
                            sed -i '/'"$uzr"':/s,'"$first_name"','"$new_first_name"',' /etc/passwd
                            vrfy_name=$(grep "$uzr": /etc/passwd | gawk -F: '{print $5}' | cut -d "," -f1)
                            echo $vrfy_name
                            read -p "Press ENTER to continue"
                            ch_name
                            ;;
                        2)  read -p "Enter new LAST name...>" new_last_name
                            sed -i '/'"$uzr"':/s,'"$last_name"','"$new_last_name"',' /etc/passwd
                            vrfy_name=$(grep "$uzr": /etc/passwd | gawk -F: '{print $5}' | cut -d "," -f1)
                            echo $vrfy_name
                            read -p "Press ENTER to continue"
                            ch_name
                            ;;
                        3)  ch_name ;;
                        *)  echo
                            read -p "Invalid Option. Press ENTER to continue"
                            ch_name
                            ;;
                esac
                ;;
        m|M)    main_menu ;;
        x|X)    exit ;;
        *)      echo
                read -p "Invalid Option. Press ENTER to continue."
                ch_name
                ;;
esac



}



##########################################################################
# Main Menu
##########################################################################

main_menu() {
# Create main menu graphic
# create menu logic

clear
echo "
Welcome to the Linux User Admin Toolkit
***************************************

1) Add/Remove Users
2) Change User's Default Shell
3) Reset Password
4) Lock/Unlock User Account
5) Change Username

X) Exit Program

"

read -p "Please enter your choice  ...> " main_menu_opt

case $main_menu_opt in 
    1) add_rem ;;
    2) def_shell ;;
    3) reset_pass ;;
    4) acct_lock ;;
    5) ch_name ;;
    x|X) read -p "Really exit? [y/n]  ...> " exit_wish
            case $exit_opt in
            y|Y) clear
                    exit ;;
            n|N) main_menu ;;
            *)   read -p "That is not a valid option. Press ENTER to continue"
                    main_menu
                    ;;
            esac
            ;;
    *)  read -p "That is not a valid option. Press ENTER to continue"
            main_menu ;;
esac


}
rooted=$(whoami)
if [[ "$rooted" != "root" ]]; then
    echo "You are not running with root priveileges."
    echo "Try sudo"
else
main_menu
fi