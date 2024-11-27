module uim.orm.classes.behaviors.behavior;

import uim.orm;
@safe:

class DBehavior : UIMObject, IBehavior {
    mixin(BehaviorThis!());
}