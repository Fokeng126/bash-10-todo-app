
#!/bin/bash

# Store the location of our todo file
# Use TODO_FILE if provided, otherwise use the default location
DATA_FILE="${TODO_FILE:-$HOME/.local/share/todo/todo.txt}"

# Function to display an error and stop the program
die() {
    echo "Error: $1" >&2
    exit "${2:-1}"
}

# Function to create the storage folder and file
init_storage() {

    # Get the folder where the todo file will be stored
    local data_dir
    data_dir=$(dirname "$DATA_FILE")

    # Create the folder if it does not exist
    mkdir -p "$data_dir" || die "Cannot create storage folder."

    # Create the todo file if it does not exist
    touch "$DATA_FILE" || die "Cannot create todo file."
}

# Function to add a new task
cmd_add() {

    # Read the task title from the command line
    local title="$*"

    # Check if the user provided a title
    [ -n "$title" ] || die "Please provide a task title."

    # Find the highest task ID and add 1
    local next_id
    next_id=$(awk -F'|' 'BEGIN { max=0 } $1 > max { max=$1 } END { print max+1 }' "$DATA_FILE")

    # Save the new task in the file
    echo "$next_id|todo|medium|$title" >> "$DATA_FILE" || die "Cannot save task."

    # Tell the user the task was added
    echo "Added task $next_id"
}

# Initialize storage before running commands
init_storage

# Check the first argument entered by the user
case "$1" in

    # Run when the user enters add
    add)
        shift
        cmd_add "$@"
        ;;

    # Run when the user enters list
    list)
        echo "List command"
        ;;

    # Run when the user enters help
    help)
        echo "Usage: ./todo.sh {add|list|done|delete|help}"
        ;;

    # Run for unknown commands
    *)
        echo "Unknown command"
        ;;
esac

