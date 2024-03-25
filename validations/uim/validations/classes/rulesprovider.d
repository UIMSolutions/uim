module uim.validations.classes.rulesprovider;

import uim.validations;

@safe:

/**
 * Proxy class used to remove any extra arguments when the user intended to call
 * a method in another class that is not aware of validation providers signature
 *
 * @method bool extension(Json mycheck, array myextensions, array mycontext = [])
 */
class DRulesProvider {
    /*
    // The class/object to proxy
    protected object|string my_class;

    // The proxied class" reflection
    protected ReflectionClass my_reflection;

    /**
     * Constructor, sets the default class to use for calling methods
     * Params:
     * object|string myclass the default class to proxy
     * @throws \ReflectionException
     * @psalm-param object|class-string myclass
     * /
    this(object|string myclass = Validation.classname) {
       _class = myclass;
       _reflection = new ReflectionClass(myclass);
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
     * @param array myarguments the list of arguments to pass to the method
     * /
    bool __call(string validationMethod, array myarguments) {
        auto method = _reflection.getMethod(mymethod);
        myargumentList = method.getParameters();

        ReflectionParameter myargument = array_pop(myargumentList);
        if (myargument.name() != "context") {
            myarguments = array_slice(myarguments, 0, -1);
        }
        myobject = isString(_class) ? null : _class;

        return method.invokeArgs(myobject, myarguments);
    } */
}
