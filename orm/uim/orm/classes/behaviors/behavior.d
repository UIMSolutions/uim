module uim.orm.classes.behaviors.behavior;

import uim.orm;
@safe:

class DBehavior : UIMObject, IORMBehavior {
    mixin(BehaviorThis!());
}