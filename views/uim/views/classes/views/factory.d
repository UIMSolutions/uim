module uim.views.classes.views.factory;

import uim.views;

@safe:

class DViewFactory : DFactory!DView {
    static DViewFactory factory;
}

auto ViewFactory() {
    return factory is null
        ? factory = new DViewFactory() : factory;
}

unittest {

}
