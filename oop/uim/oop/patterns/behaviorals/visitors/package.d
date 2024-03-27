/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.behavioral.visitors;

import uim.oop;
@safe:

/// Define an interface to represent element.
interface IComputerPart {
  void accept(IComputerPartVisitor computerPartVisitor);
}

/// Create concrete classes extending the above class.
class Keyboard : IComputerPart {
  override void accept(IComputerPartVisitor computerPartVisitor) {
    computerPartVisitor.visit(this);
  }
}

class DComputerPartMonitor : IComputerPart {
  override void accept(IComputerPartVisitor computerPartVisitor) {
    computerPartVisitor.visit(this);
  }
}

class Mouse : IComputerPart {
  override void accept(IComputerPartVisitor computerPartVisitor) {
    computerPartVisitor.visit(this);
  }
}

class DComputer : IComputerPart {	
  IComputerPart[] parts;

  this() {
    parts ~= new Mouse();
    parts ~= new Keyboard();
    parts ~= new ComputerPartMonitor(); 		
  } 


  override void accept(IComputerPartVisitor computerPartVisitor) {
    for (int i = 0; i < parts.length; i++) {
        parts[i].accept(computerPartVisitor);
    }
    computerPartVisitor.visit(this);
  }
}

/// Define an interface to represent visitor.
interface IComputerPartVisitor {
	void visit(Computer computer);
	void visit(Mouse mouse);
	void visit(Keyboard keyboard);
  void visit(ComputerPartMonitor monitor);
}

/// Create concrete visitor implementing the above class.
class DComputerPartDisplayVisitor : IComputerPartVisitor {
  override void visit(Computer computer) {
    writeln("Displaying Computer.");
  }

  override void visit(Mouse mouse) {
    writeln("Displaying Mouse.");
  }

  override void visit(Keyboard keyboard) {
    writeln("Displaying Keyboard.");
  }

  override void visit(ComputerPartMonitor monitor) {
    writeln("Displaying Monitor.");
  }
}

/// Use the ComputerPartDisplayVisitor to display parts of Computer.
version(test_uim_oop) { unittest {
    IComputerPart computer = new Computer();
  computer.accept(new ComputerPartDisplayVisitor());
}
}