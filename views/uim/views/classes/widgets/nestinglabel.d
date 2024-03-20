module uim.views.classes.widgets.nestinglabel;

import uim.views;

@safe:

/* * Form "widget" for creating labels that contain their input.
 *
 * Generally this element is used by other widgets,
 * and FormHelper itself.
 */
class DNestingLabelWidget : DLabelWidget {
    mixin(WidgetThis!("NestingLabel"));

    // The template to use.
    protected string _labelTemplate = "nestingLabel";
}

mixin(WidgetCalls!("NestingLabel"));
