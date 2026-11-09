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

    # Get the task title
    local title="$*"

    # Check if the user entered a title
    [ -n "$title" ] || die "Please provide a task title."

    # Find the highest ID and add 1
    local next_id
    next_id=$(awk -F'|' '
        BEGIN { max=0 }
        $1 > max { max=$1 }
        END { print max+1 }
    ' "$DATA_FILE")

    # Save the new task
    echo "$next_id|todo|medium|$title" >> "$DATA_FILE" || die "Cannot save task."

    # Tell the user the task was added
    echo "Added task $next_id"
}

# Function to display all tasks
cmd_list() {

    # Print the table headings
    printf "%-4s %-8s %-10s %s\n" "ID" "STATUS" "PRIORITY" "TITLE"

    # Read the file and display each task
    awk -F'|' '{
        printf "%-4s %-8s %-10s %s\n", $1, $2, $3, $4
    }' "$DATA_FILE"
}

# Function to mark a task as done
cmd_done() {

    # Get the task ID
    local id="$1"

    # Check if the task ID exists
    if ! awk -F'|' -v id="$id" '$1 == id { found=1 } END { exit !found }' "$DATA_FILE"; then
        die "Task ID $id not found."
    fi

    # Create a temporary file
    local temp_file
    temp_file=$(mktemp)

    # Find the matching task and change its status to done
    awk -F'|' -v OFS='|' -v id="$id" '
        $1 == id {
            $2 = "done"
        }
        {
            print
        }
    ' "$DATA_FILE" > "$temp_file"

    # Replace the old file with the updated temporary file
    mv "$temp_file" "$DATA_FILE"

    # Tell the user the task is done
    echo "Task $id done"
}

# Create the storage before running commands
init_storage

# Check the first command entered by the user
case "$1" in

    # Add a new task
    add)
        shift
        cmd_add "$@"
        ;;

    # Display all tasks
    list)
        cmd_list
        ;;

    # Mark a task as done
    done)
        shift
        cmd_done "$1"
        ;;

    # Display help information
    help)
        echo "Usage: ./todo.sh {add|list|done|delete|help}"
        ;;

    # Display an error for an unknown command
    *)
        echo "Unknown command"
        ;;
esac