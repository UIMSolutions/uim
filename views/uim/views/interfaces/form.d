module uim.views.interfaces.form;

import uim.views;

@safe:

interface IForm : INamed {
    mixin(IProperty!("IData[string]", "data"));
}