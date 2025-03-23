module uim.views.interfaces.component;

import uim.views;
@safe: 
interface IViewComponent {
    string render(string[string] data); 
}