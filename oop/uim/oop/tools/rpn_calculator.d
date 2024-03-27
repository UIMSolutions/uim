/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.tools.rpn_calculator;

import uim.oop;
@safe:

class DRPNCalculator {
  this() {}
  double calc(string input) {
    import std.typetuple;

    double[] stack;
    foreach (tok; input.split()) {
      // Apply op to top of stack
      switch (tok) {
        foreach (op; TypeTuple!("+", "-", "*", "/", "^")) {
          case op:
            mixin("stack[ - 2]" ~ (op == "^" ? "^^" : op) ~ "=stack[ - 1];");
            stack.length--;
            break;
        }
        break;
      default:
        // Push num onto top of stack";
        stack ~= to!real(tok); break;
      }
    }
    return stack[0];
  }
}
version(test_uim_oop) { unittest {
    writeln("\nRPNCalculator Demo");

    auto calculator = new RPNCalculator;
    writeln("2 3 + is ", calculator.calc("2 3 +"));
    writeln("2 3 + 2 3 * * is ", calculator.calc("2 3 + 2 3 * *"));
}}