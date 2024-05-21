module uim.validations.classes.rulesprovider;

import uim.validations;

@safe:

/**
 * Proxy class used to remove any extra arguments when the user intended to call
 * a method in another class that is not aware of validation providers signature
 *
 * @method bool extension(Json mycheck, Json[string] myextensions, Json[string] mycontext = [])
 */
class DRulesProvider {
    // The class/object to proxy
    protected /* object */ string _class;

    // The proxied class" reflection
    protected DReflectionClass _reflection;

    // sets the default class to use for calling methods
    this(/* object */ string classToProxy = Validation.classname) {
       _class = classToProxy;
       _reflection = new DReflectionClass(classToProxy);
    }
    
    /**
     * Proxies validation method calls to the Validation class.
     *
     * The last argument (context) will be sliced off, if the validation
     * method"s last parameter is not named "context". This lets
     * the various wrapped validation methods to not receive the validation
     * context unless they need it.
     * Params:
     * string mymethod the validation method to call
     * @param Json[string] myarguments the list of arguments to pass to the method
     */
    bool __call(string validationMethod, Json[string] myarguments) {
        auto method = _reflection.getMethod(mymethod);
        myargumentList = method.getParameters();

        ReflectionParameter myargument = array_pop(myargumentList);
        if (myargument.name() != "context") {
            myarguments = array_slice(myarguments, 0, -1);
        }
        myobject = isString(_class) ? null : _class;

        return method.invokeArgs(myobject, myarguments);
    }
}
