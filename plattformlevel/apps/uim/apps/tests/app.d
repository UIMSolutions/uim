module uim.apps.tests.app;

import uim.apps;

@safe:

bool testApp(IApp app) {
    assert(app !is null);

    return true;
}