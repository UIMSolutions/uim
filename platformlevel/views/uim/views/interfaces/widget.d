/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.interfaces.widget;

import uim.views;
@safe:

// Interface for input widgets.
interface IWidget {
    // Converts the data into one or many HTML elements.
    string render(Json[string] dataToRender, IFormContext context = null);

    // Returns a list of fields that need to be secured for this widget.
    string[] secureFields(Json[string] dataToRender);
}