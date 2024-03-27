/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.patterns.behavioral.interpreters;

import uim.oop;
@safe:

interface Expression {
   bool interpret(string context);
}

class DContainsExpression : Expression {
   private string _data;

   this(string newData) {
      _data = newData; 
   }

  override bool interpret(string checkData) {
    return checkData.indexOf(_data) >= 0;
  }
}

class OrExpression : Expression {
	 
   private Expression _expr1 = null;
   private Expression _expr2 = null;

   this(Expression expr1, Expression expr2) { 
      _expr1 = expr1;
      _expr2 = expr2;
   }

  override bool interpret(string context) {		
      return _expr1.interpret(context) || _expr2.interpret(context);
   }
}

class AndExpression : Expression {
   private Expression _expr1 = null;
   private Expression _expr2 = null;

   this(Expression expr1, Expression expr2) { 
      _expr1 = expr1;
      _expr2 = expr2;
   }

  override bool interpret(string context) {		
      return _expr1.interpret(context) && _expr2.interpret(context);
   }
}

version(test_uim_oop) { unittest { 
      writeln("\nInterpreterPatternDemo");

   //Rule: Robert and John are male
   static Expression maleExpression() {
      Expression robert = new ContainsExpression("Robert");
      Expression john = new ContainsExpression("John");
      return new OrExpression(robert, john);		
   }

   //Rule: Julie is a married women
   static Expression marriedWomanExpression() {
      Expression julie = new ContainsExpression("Julie");
      Expression married = new ContainsExpression("Married");
      return new AndExpression(julie, married);		
   }

  Expression isMale = maleExpression();
  Expression isMarriedWoman = marriedWomanExpression();

  writeln("John is male? ", isMale.interpret("John"));
  writeln("Julie is a married women? ", isMarriedWoman.interpret("Married Julie"));
}}