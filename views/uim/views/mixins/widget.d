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
