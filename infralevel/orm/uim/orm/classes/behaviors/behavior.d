module uim.orm.classes.behaviors.behavior;

import uim.orm;
@safe:

version (test_uim_orm) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DORMBehavior : UIMObject, IORMBehavior {
    mixin(ORMBehaviorThis!());
}