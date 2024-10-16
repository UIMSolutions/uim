/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.validations.classes.rulesprovider;

import uim.validations;

@safe:

/**
 * Proxy class used to remove any extra arguments when the user intended to call
 * a method in another class that is not aware of validation providers signature
 *
 * @method bool extension(Json mycheck, Json[string] myextensions, Json[string] mycontext= null)
 */
class DRulesProvider {
    // The class/object to proxy
    protected /* object */ string _proxyclassname;
    protected Object _proxyObject;

    // The proxied class" reflection
    protected /* DReflectionClass */ Object _reflection;

    // sets the default class to use for calling methods
    this(/* object */ string classToProxy = (new DValidation).classname) {
       _proxyclassname = classToProxy;
       /* _reflection = new DReflectionClass(classToProxy); */
    }
    
    /**
     * Proxies validation method calls to the Validation class.
     *
     * The last argument (context) will be sliced off, if the validation
     * method"s last parameter is not named "context". This lets
     * the various wrapped validation methods to not receive the validation
     * context unless they need it.
     */
    bool __call(string validationMethod, Json[string] methodArguments) {
        /* auto method = _reflection.getMethod(mymethod);
        myargumentList = method.getParameters();

        ReflectionParameter myargument = methodArguments.pop();
        if (myargument.name() != "context") {
            methodArguments = methodArguments.slice(0, -1);
        }
        myobject = _proxyclassname.isString ? null : _proxyclassname;

        return method.invokeArgs(myobject, methodArguments); */
        return false; 
    }
}
