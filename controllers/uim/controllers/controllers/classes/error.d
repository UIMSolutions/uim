module uim.controllers.classes.error;

import uim.controllers;

@safe:

/**
 * Error Handling Controller
 *
 * Controller used by ErrorHandler to render error views.
 */
class ErrorController : Controller {
    // Get alternate view classes that can be used in content-type negotiation.
    string[] viewClasses() {
        return [JsonView.classname];
    }
    
    // Initialization hook method.
    bool initialize(IData[string] initData = null) {
        super.initialize(initData);
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
    }
}
