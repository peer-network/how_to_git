#basic hello world code
echo "hello world first"

# Usage: Hello World Bash Shell Script Using Variables
var="Hello world second"

var1="Hello world third"

echo "$var"

printf "%s\n" "$var1"

# Run date and hostname command and store output to shell variables

var2="Hello World with time"

#
# print it or use the variable
# Variable names are case sensitive $now and $NOW are different names
#

now="$(date)"
computer_name="$(hostname)"

echo "$var2"
echo "current date and time : $now"
echo "computer name : $computer_name"
echo ""

# Read input using read command

read -p "May I know your name please?" name
echo "Hello $name, let us be friend"
echo ""

