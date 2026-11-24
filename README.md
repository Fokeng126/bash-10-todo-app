# Bash Todo App

## Problem Statement

I realised many People have many tasks to complete every day, and it can be difficult to keep track of them. This project provides a simple command-line application that allows users to manage their daily tasks using the terminal.

## Project Goals

The goal of this project is to create a simple Todo application using Bash that allows users to:

- Add tasks
- Set task priorities
- View tasks
- Mark tasks as done
- Delete tasks
- Handle invalid input with clear error messages

## Tech Stack

- Bash
- Linux Terminal
- Git
- GitHub

## Screenshot

Screenshots of the application can be added here to show how the Todo App works.

## Features

- Add a new task
- Set task priority to `low`, `medium`, or `high`
- Use `medium` as the default priority
- List all tasks
- Sort tasks by priority
- Mark tasks as done
- Delete tasks using their ID
- Display clear error messages for invalid input
- Show a help message

## Installation and Setup

### 1. Clone the repository

```bash
git clone <repository-url>
```

### 2. Move into the project folder

```bash
cd bash-10-todo-app
```

### 3. Make the script executable

```bash
chmod +x todo.sh
```

### 4. Run the application

Add a task:

```bash
./todo.sh add "Study Bash"
```

Add a task with high priority:

```bash
./todo.sh add -p high "Finish assignment"
```

List tasks:

```bash
./todo.sh list
```

Mark a task as done:

```bash
./todo.sh done 1
```

Delete a task:

```bash
./todo.sh delete 1
```

## Challenges Faced

Some challenges faced during this project included:

- Managing task IDs correctly
- Sorting tasks by priority
- Updating and deleting tasks safely
- Handling missing or invalid user input
- Understanding how to work with files in Bash

These challenges were solved by using Bash functions, conditions, `awk`, temporary files, and clear error handling.

## What I Learnt

Through this project, I learnt how to:

- Create a command-line application using Bash
- Use functions to organize code
- Work with command-line arguments
- Store and read data from files
- Use `awk` to process text
- Handle errors and exit codes
- Use temporary files safely
- Manage a project using Git and GitHub

## Author

**Joshua Kroos**
