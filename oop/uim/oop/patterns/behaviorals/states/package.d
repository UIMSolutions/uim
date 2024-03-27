/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.behaviorals.states;

import uim.oop;
@safe:

/// Create an interface.
interface IState {
  void doAction(Context context);
  string toString();
}

/// Create concrete classes implementing the same interface.
class DStartState : IState {
  void doAction(Context context) {
    writeln("Player is in start state");
    context.state(this);	
  }

  override string toString() {
    return "Start State";
  }
}

class DStopState : IState {
  void doAction(Context context) {
    writeln("Player is in stop state");
    context.state(this);	
  }

  override string toString() {
    return "Stop State";
  }
}

/// Create Context Class.
class DContext {
  this() {
    _state = null; }

  mixin(OProperty!("IState", "state")); 
}

/// Use the Context to see change in behaviour when State changes.
version(test_uim_oop) { unittest {
    writeln("\nStatePatternDemo");
    
    auto context = new DContext();

    auto startState = new StartState();
    startState.doAction(context);

    writeln(context.state);

    auto stopState = new StopState();
    stopState.doAction(context);

    writeln(context.state);
  }
}