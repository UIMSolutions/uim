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

    override bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
        return false;
        }

        /**
        * Default config
        *
        * - `validate` - Whether to validate request body / data. Set to false to disable
        *  for data coming from 3rd party services, etc.
        * - `unlockedFields` - Form fields to exclude from validation. Fields can
        *  be unlocked either in the Component, or with FormHelper.unlockField().
        *  Fields that have been unlocked are not required to be part of the POST
        *  and hidden unlocked fields do not have their values checked.
        * - `unlockedActions` - Actions to exclude from POST validation checks.
        * - `validationFailureCallback` - Callback to call in case of validation
        *  failure. Must be a valid Closure. Unset by default in which case
        *  exception is thrown on validation failure.
        */
        configuration.updateDefaults([
            "validate": BooleanData(true),
            "unlockedFields": ArrayData,
            "unlockedActions": ArrayData,
            "validationFailureCallback": NullData,
        ]);

        return true;
    }
    
    // Default message used for exceptions thrown.
    const string DEFAULT_EXCEPTION_MESSAGE = "Form tampering protection token validation failed.";



    /**
     * Get Session id for FormProtector
     * Must be the same as in FormHelper
     * /
    protected string _getSessionId() {
        auto mySession = this.getController().getRequest().getSession();
        mySession.start();

        return mySession.id();
    }

    /**
     * Component startup.
     *
     * Token check happens here.
     * Params:
     * \UIM\Event\IEvent<\UIM\Controller\Controller> anEvent An Event instance
     * /
    DResponse startup(IEvent anEvent) {
        auto myrequest = this.getController().getRequest();
        auto mydata = request.getParsedBody();
        auto myhasData = (someData ||  request. is(["put", "post", "delete", "patch"]));

        if (
            !in_array(request.getParam("action"), _config["unlockedActions"], true)
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
            someData.remove("_Token");
             request = request.withParsedBody(someData);
        }
        this.getController().setRequest(request);

        return null;
    }

    // Events supported by this component.
    IEvent[] implementedEvents() {
        return [
            "Controller.startup": "startup",
        ];
    }

    /**
     * Throws a 400 - Bad request exception or calls custom callback.
     *
     * If `validationFailureCallback` config is specified, it will use this
     * callback by executing the method passing the argument as exception.
     * Params:
     * \UIM\Form\FormProtector formProtector Form Protector instance.
     * /
    protected DResponse validationFailure(FormProtectorformProtector) {
        auto myException = Configure.read("debug")
            ? new BadRequestException(
                formProtector.getError()) : new BadRequestException(DEFAULT_EXCEPTION_MESSAGE);

        if (_config["validationFailureCallback"]) {
            return _executeCallback(_config["validationFailureCallback"], myException);
        }

        throw myException;
    }

    /**
     * Execute callback.
     * Params:
     * \Closure aCallback Callback
     * @param \UIM\Http\Exception\BadRequestException anException = Exception instance.
     * /
    protected DResponse executeCallback(Closure aCallback, BadRequestException anException) {
        return aCallback(exception);
    } */
}
