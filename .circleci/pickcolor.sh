PIPELINE_NUMBER=$1

# Define the list as an array
my_list=("red" "orange" "yellow" "green" "blue" "purple")

# Get the length of the list
list_length=${#my_list[@]}

# Use a loop to demonstrate picking multiple items using modulo
index=$(( ${PIPELINE_NUMBER} % list_length ))

# Select the item
export APP_COLOR="${my_list[index]}"


echo $APP_COLOR
