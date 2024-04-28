module uim.controllers.classes.controllers.error;

import uim.controllers;

@safe:

/**
 * Error Handling Controller
 *
 * Controller used by ErrorHandler to render error views.
 */
class DErrorController : DController {
    mixin(ControllerThis!("Error"));

    // Initialization hook method.
    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData))  {
            return false;
        }

        return true;
    }

    /* 
    // Get alternate view classes that can be used in content-type negotiation.
    string[] viewClasses() {
        return [JsonView.classname];
    }
    

    // beforeRender callback.
    Response beforeRender(IEvent anEvent) {
        auto viewBuilder = this.viewBuilder();
        string templatePath = "Error";

        if (
            this.request.getParam("prefix") &&
            viewBuilder.getTemplate().has(["error400", "error500"])
        ) {
            string parts = split(DIRECTORY_SEPARATOR, (string)viewBuilder.templatePath, -1);
            templatePath = parts.join(DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR ~ "Error";
        }

        viewBuilder.templatePath(templatePath);
        return null;
    } */
}
