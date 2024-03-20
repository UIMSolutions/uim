module uim.views.mixins.widget;

import uim.views;

@safe:

string widgetThis(string name) {
    string fullName = name ~ "Widget";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(string name) {
        super(); this.name(name);
    }
    `;
}

template WidgetThis(string name) {
    const char[] WidgetThis = widgetThis(name);
}

string widgetCalls(string name) {
    string fullName = name ~ "Widget";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template WidgetCalls(string name) {
    const char[] WidgetCalls = widgetCalls(name);
}