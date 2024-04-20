module uim.forms.interfaces.form;

import uim.forms;

@safe:

interface IForm : INamed {
    mixin(IProperty!("IData[string]", "data"));
}