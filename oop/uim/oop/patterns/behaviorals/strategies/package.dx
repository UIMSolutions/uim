/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.behavioral.strategies;

import uim.oop;
@safe:

/// Create an interface.
interface IStrategy {
  int doOperation(int num1, int num2);
}

/// Create concrete classes implementing the same interface.
class DOperationAdd : IStrategy{
  override int doOperation(int num1, int num2) {
    return num1 + num2;
  }
}

class DOperationSubstract : IStrategy{
  override int doOperation(int num1, int num2) {
    return num1 - num2;
  }
}

class DOperationMultiply : IStrategy{
  override int doOperation(int num1, int num2) {
    return num1 * num2;
  }
}

/// Create DContext Class.
class DContext {
  private IStrategy _strategy;

  this(IStrategy strategy) {
    _strategy = strategy;
  }

  int executeStrategy(int num1, int num2) {
    return _strategy.doOperation(num1, num2);
  }
}

/// Use the DContext to see change in behaviour when it changes its Strategy.
version(test_uim_oop) { unittest {
    DContext context = new DContext(new DOperationAdd());		
    writeln("10 + 5 = ", context.executeStrategy(10, 5));

    context = new DContext(new DOperationSubstract());		
    writeln("10 - 5 = ", context.executeStrategy(10, 5));

    context = new DContext(new DOperationMultiply());		
    writeln("10 * 5 = ", context.executeStrategy(10, 5));
  }
}