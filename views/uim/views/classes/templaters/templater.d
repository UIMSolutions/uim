module uim.views.classes.templaters.templater;

import uim.views;

@safe:
 unittest {
  writeln("-----  ", __MODULE__ , "\t  -----");
}
 class DTemplater : UIMObject {
    mixin(ObjThis!("Templater"));
}
mixin(ObjCalls!("Templater"));
