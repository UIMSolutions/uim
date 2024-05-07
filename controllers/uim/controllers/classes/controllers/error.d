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
    DResponse beforeRender(IEvent anEvent) {
        auto viewBuilder = viewBuilder();
        string templatePath = "Error";

        if (
            _request.getParam("prefix") &&
            viewBuilder.getTemplate().has(["error400", "error500"])
        ) {
            string[] parts = viewBuilder.templatePath, -1).toString.split(DIRECTORY_SEPARATOR);
            templatePath = parts.join(DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR ~ "Error";
        }

        viewBuilder.templatePath(templatePath);
        return null;
    } */
}
