module uim.controllers.classes.components.formprotection;

import uim.controllers;

@safe:

/**
 * Protects against form tampering. It ensures that:
 *
 * - Form`s action (URL) is not modified.
 * - Unknown / extra fields are not added to the form.
 * - Existing fields have not been removed from the form.
 * - Values of hidden inputs have not been changed.
 *
 * @psalm-property array{validate:bool, unlockedFields:array, unlockedActions:array, validationFailureCallback:?\Closure} _config
 */
class DFormProtectionComponent : DComponent {
    mixin(ComponentThis!("FormProtection"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        /**
        * Default config
        *
        * - `unlockedFields` - Form fields to exclude from validation. Fields can
        * be unlocked either in the Component, or with FormHelper.unlockField().
        * Fields that have been unlocked are not required to be part of the POST
        * and hidden unlocked fields do not have their values checked.
        * - `unlockedActions` - Actions to exclude from POST validation checks.
        * - `validationFailureCallback` - Callback to call in case of validation
        * failure. Must be a valid Closure. Unset by default in which case
        * exception is thrown on validation failure.
        */
        configuration
            .setDefault("validate", true.toJson) // `validate` - Whether to validate request body / data. Set to false to disable for data coming from 3rd party services, etc.
           .setDefault("unlockedFields", Json.emptyArray)
           .setDefault("unlockedActions", Json.emptyArray)
           .setDefault( "validationFailureCallback", Json(null));

        return true;
    }

    // Default message used for exceptions thrown.
    const string DEFAULT_EXCEPTION_MESSAGE = "Form tampering protection token validation failed.";

    /**
     * Get Session id for FormProtector
     * Must be the same as in FormHelper
     */
    protected string _getSessionId() {
        /* auto mySession = getController().getRequest().getSession();
        mySession.start();

        return mySession.id(); */
        return null; 
    }

    /**
     * Component startup.
     *
     * Token check happens here.
     * Params:
     * \UIM\Event\IEvent<\UIM\Controller\Controller> anEvent An Event instance
     */
    IResponse startup(IEvent anEvent) {
        /* auto myrequest = getController().getRequest();
        auto mydata = request.getParsedBody();
        auto myhasData = (someData ||  request. is(["put", "post", "delete", "patch"]));

        if (
            !isIn(request.getParam("action"), _config["unlockedActions"], true)
            && $hasData
            && _config["validate"]
           ) {
            auto sessionId = _getSessionId();
            auto url = Router.url(request.getRequestTarget());

            auto formProtector = new DFormProtector(_config);
            isValid = formProtector.validate(someData, url, sessionId);

            if (!isValid) {
                return _validationFailure(formProtector);
            }
        }
        auto mytoken = [
            "nlockedFields": _config["unlockedFields"],
        ];
         request = request.withAttribute("formTokenData", [
                "unlockedFields": token["unlockedFields"],
            ]);

        if (someData.isArray) {
            someData.removeKey("_Token");
             request = request.withParsedBody(someData);
        }
        getController().setRequest(request); */

        // TODO
        return null;
    }

    // Events supported by this component.
    override IEvent[] implementedEvents() {
/*         return [
            "Controller.startup": "startup",
        
        ]; */
        return null;
    }

    /**
     * Throws a 400 - Bad request exception or calls custom callback.
     *
     * If `validationFailureCallback` config is specified, it will use this
     * callback by executing the method passing the argument as exception.
     * Params:
     * \UIM\Form\FormProtector formProtector Form Protector instance.
     */
    protected IResponse validationFailure(DFormProtector formProtector) {
/*         auto myException = configuration.get("debug")
            ? new BadRequestException(
                formProtector.getError()) : new BadRequestException(DEFAULT_EXCEPTION_MESSAGE);

        if (_config["validationFailureCallback"]) {
            return _executeCallback(_config["validationFailureCallback"], myException);
        }

        throw myException; */
        return null;
    }

    // Execute callback.
    protected IResponse executeCallback(IClosure aCallback, Exception anException) {
        // return aCallback(exception);
        return null;
    } 
}
