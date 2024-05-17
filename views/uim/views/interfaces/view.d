module uim.views.interfaces.view;

import uim.views;

@safe:

interface IView : INamed {
    string currentType(); 

    string[] blockNames(); 
}