module uim.views.classes.views.factory;

import uim.views;

@safe:

class DViewFactory : DFactory!DView {
    static DViewFactory factory;
}

auto ViewFactory() {
    return DViewFactory.factory is null
        ? DViewFactory.factory = new DViewFactory() : DViewFactory.factory;
}

unittest {

}
