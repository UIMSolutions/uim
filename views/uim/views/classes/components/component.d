module uim.views.classes.components.component;

import uim.views;

@safe: 
class DViewComponent : UIMObject, IViewComponent { 
    mixin(ViewThis!());

    string render(string[string] data) {
        return "";
    }
}
