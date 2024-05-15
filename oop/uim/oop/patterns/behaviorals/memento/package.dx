/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.behaviorals.memento;

import uim.oop;

public {
  import uim.oop.patterns.behaviorals.memento.history;
  import uim.oop.patterns.behaviorals.memento.obj;
  import uim.oop.patterns.behaviorals.memento.state;
}

/* @safe:

/// Create DMemento class.
class DMemento {
  private string _state;

  this(string state) {
    _state = state;
  }

  @property string state() {
    return _state;
  }	
}

/// Create Originator class
class DOriginator {
  private string _state;

  @property void state(string newState) {
    _state = state; }

  @property string state() {
    return _state; }

  DMemento saveStateToMemento() {
    return new DMemento(state); }

  void stateFromMemento(DMemento memento) {
    state = memento.state; }
}

/// Create DCareTaker class
class DCareTaker {
  private DMemento[] _mementoList;

  void add(DMemento state) {
    _mementoList ~= state;
  }

  DMemento get(size_t index) {
    return _mementoList[index];
  }
}

/// Use CareTaker and Originator objects.
   version(test_uim_oop) { unittest {
    writeln("\nMementoPatternDemo");
  
    DOriginator originator = new DOriginator();
    DCareTaker careTaker = new DCareTaker();
        
    originator.state("State #1");
    originator.state("State #2");
    careTaker.add(originator.saveStateToMemento());
        
    originator.state("State #3");
    careTaker.add(originator.saveStateToMemento());

    originator.state("State #4");
    writeln("Current State: ", originator.state);		

    originator.stateFromMemento(careTaker.get(0));
    writeln("First saved State: ", originator.state());
    originator.stateFromMemento(careTaker.get(1));
    writeln("Second saved State: ", originator.state);
  }
} */