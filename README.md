# Todo

### Motivation
A todo manager with the following properties:

1. Is no-frills.
2. Does not require me leaving my shell.
3. Can manage todo lists from day-to-day.
4. Leaves behind logs of per-day activity so that
   I can track my productivity.

### Todo

1. Add subtasks. This shouldn't be too hard, but will require
   rearchitecting.
2. Possibly show more information (created_at?) in the display.
3. Interface to calculate productivity stats.

### Usage

Clone the repository:

    $ git clone git://github.com/siddarth/todo.git
    $ cd todo

Create the log directory (where logs of past todo lists are stored):

    $ mkdir log
    $ ./todo

### Output

    -------------- TodoManager (v.1.0) ---------------
    [ ] Drink coffee
    [x] Buy milk
    [ ] Write code
    --------------------------------------------------
    [a] Add task
    [w] Key up
    [x] Toggle task
    [d] Delete task
    [q] Quit
    [s] Key down
    --------------------------------------------------
