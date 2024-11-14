module uim.views.classes.views.view;

import uim.views;

@safe: 
class DView : UIMObject, IView { 
    mixin(ViewThis!());

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    string render(string[string] data) {
        return "";
    }
}
