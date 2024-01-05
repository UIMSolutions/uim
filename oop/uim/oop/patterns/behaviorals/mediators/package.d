/***********************************************************************************
*	Copyright: ©2015-2023 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.behavioral.mediators;

import uim.oop;

@safe:
/// Create mediator class.
class ChatRoom {
  static void showMessage(User user, string message) {
    writeln(new Date(), " [", user.name, "] : ", message);
  }
}

/// Create user class
class User {
  this(string name) {
    this.name  = name;
  }

  mixin(OProperty!("string", "name"));

  void sendMessage(string message) {
    ChatRoom.showMessage(this,message);
  }
}

/// Use the User object to show communications between them.
version(test_uim_oop) { unittest {
    writeln("MediatorPatternDemo"); 

    User robert = new User("Robert");
    User john = new User("John");

    robert.sendMessage("Hi! John!");
    john.sendMessage("Hello! Robert!");
  }
}