/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.observers;

import uim.oop;
@safe:

/// Create Subject class.
class DSubject {

  private DObserver[] observers;
  private int _state;

  @property int state() {
    return _state; }

  @property void state(int state) {
    _state = state;
    notifyAllObservers(); }

  void attach(DObserver observer) {
    observers ~= observer; }

  void notifyAllObservers() {
    observers.each!(observer => observer.update()); 
  }

  void notifyAllObservers(Json info) {
    observers.each!(a => a.update(info)); } 	
}

/// Create Observer class.
 abstract class DObserver {
   protected DSubject _subject;
    abstract void update(Json info = Json(null));
}

/// Create concrete observer classes
class DBinaryObserver : DObserver{

  this(DSubject subject) {
    _subject = subject;
    _subject.attach(this);
  }

  override void update(Json info = Json(null)) {
    writeln("Binary String: Integer.toBinaryString(subject.getState() )"); 
  }
}

class DOctalObserver : DObserver{

  this(DSubject subject) {
    _subject = subject;
    _subject.attach(this);
  }

  override void update(Json info = Json(null)) {
    writeln("Octal String: Integer.toOctalString(subject.getState() )" ); 
  }
}

class DHexaObserver : DObserver{

  this(DSubject subject) {
    _subject = subject;
    _subject.attach(this);
  }

  override void update(Json info = Json(null)) {
    writeln("Hex String: Integer.toHexString(subject.getState() ).upperCase()" ); 
  }
}

/// Use Subject and concrete observer objects.
version(test_uim_oop) { unittest {
  debug writeln("ObserverPatternDemo");

    DSubject subject = new DSubject();

    new DHexaObserver(subject);
    new DOctalObserver(subject);
    new DBinaryObserver(subject);

    debug writeln("First state change: 15");	
    subject.state(15);
    debug writeln("Second state change: 10");	
    subject.state(10);
  }
}