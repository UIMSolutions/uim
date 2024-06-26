module uim.views.interfaces.widget;

import uim.views;

@safe:

// Interface for input widgets.
interface IWidget {
    // Converts the data into one or many HTML elements.
    string render(Json[string] dataToRender, IContext formContext);

    // Returns a list of fields that need to be secured for this widget.
    string[] secureFields(Json[string] dataToRender);
}