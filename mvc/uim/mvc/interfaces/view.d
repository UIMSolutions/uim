module uim.mvc.interfaces.view;

import uim.mvc;

@safe: 
interface IView {
    string render(string[string] data);
}

