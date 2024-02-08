/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.behaviorals.memento.history;

import uim.oop;
@safe:

class DMementoHistory {
  private DMementoState[] _states;

  public void push(DMementoState newState) {
    _states ~= newState;
  }

  public DMementoState pop() {
    DMementoState lastState;
    
    if (!_states.isEmpty) {
      lastState = _states[-1];
      _states = _states[0..-1];
    } 

    return lastState;
  }
}