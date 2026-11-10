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
    local data_dir
    data_dir=$(dirname "$DATA_FILE")

    mkdir -p "$data_dir" || die "Cannot create storage folder."
    touch "$DATA_FILE" || die "Cannot create todo file."
}

# Function to check if a task ID exists
task_exists() {
    local id="$1"

    awk -F'|' -v id="$id" '
        $1 == id {
            found=1
        }
        END {
            exit !found
        }
    ' "$DATA_FILE"
}

# Function to add a new task
cmd_add() {
    local priority="medium"

    if [ "$1" = "-p" ]; then
        priority="$2"
        shift 2
    fi

    local title="$*"

    [ -n "$title" ] || die "Please provide a task title."

    # Reject | because it is used as the data separator
    case "$title" in
        *"|"*)
            die "Task title cannot contain |."
            ;;
    esac

    case "$priority" in
        low|medium|high)
            ;;
        *)
            die "Priority must be low, medium, or high."
            ;;
    esac

    local next_id
    next_id=$(awk -F'|' '
        BEGIN {
            max=0
        }
        $1 > max {
            max=$1
        }
        END {
            print max+1
        }
    ' "$DATA_FILE")

    echo "$next_id|todo|$priority|$title" >> "$DATA_FILE" ||
        die "Cannot save task."

    echo "Added task $next_id"
}

# Function to display all tasks
cmd_list() {
    printf "%-4s %-8s %-10s %s\n" "ID" "STATUS" "PRIORITY" "TITLE"

    awk -F'|' '
        $3 == "high" {
            print
        }
    ' "$DATA_FILE" |
        while IFS='|' read -r id status priority title; do
            printf "%-4s %-8s %-10s %s\n" \
                "$id" "$status" "$priority" "$title"
        done

    awk -F'|' '
        $3 == "medium" {
            print
        }
    ' "$DATA_FILE" |
        while IFS='|' read -r id status priority title; do
            printf "%-4s %-8s %-10s %s\n" \
                "$id" "$status" "$priority" "$title"
        done

    awk -F'|' '
        $3 == "low" {
            print
        }
    ' "$DATA_FILE" |
        while IFS='|' read -r id status priority title; do
            printf "%-4s %-8s %-10s %s\n" \
                "$id" "$status" "$priority" "$title"
        done
}

# Function to mark a task as done
cmd_done() {
    local id="$1"

    [ -n "$id" ] || die "Please provide a task ID."

    task_exists "$id" || die "Task ID $id not found."

    local temp_file
    temp_file=$(mktemp) || die "Cannot create temporary file."

    awk -F'|' -v OFS='|' -v id="$id" '
        $1 == id {
            $2 = "done"
        }
        {
            print
        }
    ' "$DATA_FILE" > "$temp_file" || die "Cannot update task."

    mv "$temp_file" "$DATA_FILE" || die "Cannot update task."

    echo "Task $id done"
}

# Function to delete a task
cmd_delete() {
    local id="$1"

    [ -n "$id" ] || die "Please provide a task ID."

    task_exists "$id" || die "Task ID $id not found."

    local temp_file
    temp_file=$(mktemp) || die "Cannot create temporary file."

    awk -F'|' -v id="$id" '
        $1 != id {
            print
        }
    ' "$DATA_FILE" > "$temp_file" || die "Cannot delete task."

    mv "$temp_file" "$DATA_FILE" || die "Cannot delete task."

    echo "Task $id deleted"
}

# Create the storage before running commands
init_storage

# Check the command entered by the user
case "${1:-list}" in
    add)
        shift
        cmd_add "$@"
        ;;

    list)
        cmd_list
        ;;

    done)
        shift
        cmd_done "$1"
        ;;

    delete)
        shift
        cmd_delete "$1"
        ;;

    help)
        echo "Usage: ./todo.sh {add|list|done|delete|help}"
        ;;

    *)
        echo "Unknown command"
        exit 1
        ;;
esac