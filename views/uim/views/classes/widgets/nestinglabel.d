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

    override bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    // The template to use.
    protected string _labelTemplate = "nestingLabel";
}
mixin(WidgetCalls!("NestingLabel"));
