module uim.views.mixins.widget;

import uim.views;

@safe:

string widgetThis(string name) {
    string fullName = name ~"Widget";
    return 
    `this() {
        super(); this.name("`~fullName~`");
    }`;
}

template WidgetThis(string name) {
    const char[] WidgetThis = widgetThis(name);
}

string widgetCalls(string name) {
    string fullName = name ~"Widget";
    return 
    `auto `~fullName~`() { return new D`~fullName~`(); }`;
}

template WidgetCalls(string name) {
    const char[] WidgetCalls = widgetChis(name);
}
