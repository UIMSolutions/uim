module uim.views.classes.widgets;

public {
    import uim.views.classes.widgets.widget;
    import uim.views.classes.widgets.collection;
    import uim.views.classes.widgets.factory;
    import uim.views.classes.widgets.registry;
}

public {
    import uim.views.classes.widgets.button;
    import uim.views.classes.widgets.checkbox;
    import uim.views.classes.widgets.datetime;
    import uim.views.classes.widgets.file;
    import uim.views.classes.widgets.label;
    import uim.views.classes.widgets.locator;
    import uim.views.classes.widgets.multicheckbox;
    import uim.views.classes.widgets.nestinglabel;
    import uim.views.classes.widgets.radio;
    import uim.views.classes.widgets.selectbox;
    import uim.views.classes.widgets.textarea;
    import uim.views.classes.widgets.year;
}

static this() {
    WidgetRegistry.register("Button", ButtonWidget);
    WidgetRegistry.register("Checkbox", CheckboxWidget);
}