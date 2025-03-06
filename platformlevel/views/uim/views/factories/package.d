module uim.views.factories;

public {
  import uim.views.factories.context;
  import uim.views.factories.view;
  import uim.views.factories.widget;
}

static this() {
  import uim.views;
  WidgetFactory.set("button", (Json[string] options = null) @safe {
    return new DButtonWidget(options);
  });

  WidgetFactory.set("checkbox", (Json[string] options = null) @safe {
    return new DCheckboxWidget(options);
  });

  WidgetFactory.set("datetime", (Json[string] options = null) @safe {
    return new DDateTimeWidget(options);
  });

  WidgetFactory.set("file", (Json[string] options = null) @safe {
    return new DFileWidget(options);
  });

  WidgetFactory.set("label", (Json[string] options = null) @safe {
    return new DLabelWidget(options);
  });

  WidgetFactory.set("multicheckbox", (Json[string] options = null) @safe {
    return new DMultiCheckboxWidget(options);
  });

  WidgetFactory.set("nestinglabel", (Json[string] options = null) @safe {
    return new DNestingLabelWidget(options);
  });

  WidgetFactory.set("radio", (Json[string] options = null) @safe {
    return new DRadioWidget(options);
  });

  WidgetFactory.set("selectbox", (Json[string] options = null) @safe {
    return new DSelectBoxWidget(options);
  });

  WidgetFactory.set("textarea", (Json[string] options = null) @safe {
    return new DTextareaWidget(options);
  });

  WidgetFactory.set("year", (Json[string] options = null) @safe {
    return new DYearWidget(options);
  });
}
