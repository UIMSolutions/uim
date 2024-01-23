/***********************************************************************************
*	Copyright: ©2015 - 2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.behaviorals.memento.obj;

import uim.oop;
@safe:

class DMementoObj(DMementoState) {
  this() {}

  DMementoState createState() {
    return null;
  }

  void restoreState(DMementoState aState) {
    return null;
  }
}