module uim.databases.classes.expressions.expression;

import uim.databases;
@safe:

version (test_uim_databases) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DExpression : UIMObject, IExpression {
    mixin(ExpressionThis!());
}