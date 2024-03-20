module uim.views.classes.widgets.nestinglabel;

import uim.views;

@safe:

/* * Form "widget" for creating labels that contain their input.
 *
 * Generally this element is used by other widgets,
 * and FormHelper itself.
 */
class NestingLabelWidget : LabelWidget {
    mixin(WidgetThis!("NestingLabel"));

    // The template to use.
    protected string _labelTemplate = "nestingLabel";
}

mixin(WidgetCalls!("NestingLabel"));
