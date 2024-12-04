module uim.orm.classes.behaviors.behavior;

import uim.orm;
@safe:

class DORMBehavior : UIMObject, IORMBehavior {
    mixin(ORMBehaviorThis!());
}