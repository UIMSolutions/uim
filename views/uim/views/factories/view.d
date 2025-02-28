module uim.views.factories.view;

import uim.views;
@safe:

version (test_uim_views) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
} 


class DViewFactory : DFactory!DView {
    static DViewFactory factory;
}

auto ViewFactory() {
    return DViewFactory.factory is null
        ? DViewFactory.factory = new DViewFactory() : DViewFactory.factory;
}

unittest {

}
