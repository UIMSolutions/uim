/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.behaviorals.commands.version2;

import uim.oop;

@safe:

class MoveFileCommand {
private:
  string source;
  string destination;
  void action(string source, string destination) {
    writefln("renaming %s to %s", source, destination);
    rename(source, destination);
  }

public:
  this(string source, string destination) {
    this.source = source;
    this.destination = destination;
  }

  void execute() {
    this.action(source, destination);
  }

  void undo() {
    this.action(this.destination, this.source);
  }
}

version (test_uim_oop) {
  unittest {
    MoveFileCommand[] commandStack;
    auto firstCommand = new MoveFileCommand("foo.txt", "bar.txt");
    auto secondCommand = new MoveFileCommand("bar.txt", "baz.txt");
    commandStack ~= firstCommand;
    commandStack ~= secondCommand;
    assert(exists("foo.txt") == false);
    auto file = File("foo.txt", "w");
    commandStack
      .each!(command => command.execute());
    reverse(commandStack);
    commandStack.each!(command => command.undo());

    std.file.remove("foo.txt");
  }
}
