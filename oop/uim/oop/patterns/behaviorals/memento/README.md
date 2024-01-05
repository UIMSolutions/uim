# \# Package 📦 uim.oop.patterns.behaviorals.memento

This package contains classes for the **Memento Pattern**. This pattern is suitable for depicting the undo mechanism of an application. If the user has changed something, for example deleted a circle from a graphic, this can be undone with an undo.

The undo mechanism uses a list of changes made. Each new change is appended to the end of the list. With an undo, the last element of the list is taken and the corresponding change is undone.

The creation of a _redo mechanism_ would also be possible. Such a function does not take the last element from a list but sets a pointer to the previous element. Each undo only moves the pointer but does not delete any element. If a redo is to take place, the pointer is moved in the other direction. The corresponding change is made and the previous undo is corrected.

There are three central actors in the Memento Pattern:

- The **Originator** whose internal state should be saved.
- The **Memento** that saves the current internal state.
- The **CareTaker**, who holds a list of Mementos.
