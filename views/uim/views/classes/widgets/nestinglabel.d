module uim.views.classes.widgets.nestinglabel;

import uim.views;

@safe:

 unittest {
  writeln("-----  ", __MODULE__ , "\t  -----");
}

/* * Form "widget" for creating labels that contain their input.
 *
 * Generally this element is used by other widgets,
 * and FormHelper it
 */
class DNestingLabelWidget : DLabelWidget {
    mixin(WidgetThis!("NestingLabel"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    // The template to use.
    protected string _labelTemplate = "nestingLabel";
}
mixin(WidgetCalls!("NestingLabel"));
