/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.mixins.widget;

import uim.views;

@safe:

string widgetThis(string name = null) {
    string fullName = name ~ "Widget";
    return objThis(fullName);
}

template WidgetThis(string name = null) {
    const char[] WidgetThis = widgetThis(name);
}

string widgetCalls(string name) {
    string fullName = name ~ "Widget";
    return objCalls(fullName);
}

template WidgetCalls(string name) {
    const char[] WidgetCalls = widgetCalls(name);
}
