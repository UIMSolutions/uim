module uim.forms.tests.form;

import uim.forms;

@safe:

bool testForm(IForm formToTest) {
    assert(formToTest !is null, "In testForm: form to test is null");

    return true;
}