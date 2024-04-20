module uim.views.tests.form;

import uim.views;

@safe:

bool testForm(IForm formToTest) {
    assert(formToTest !is null, "In testForm: form to test is null");

    return true;
}