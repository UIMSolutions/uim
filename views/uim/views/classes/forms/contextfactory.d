module uim.views.classes.forms.contextfactory;

import uim.views;

@safe:

// Factory for getting form context instance based on provided data.
class DContextFactory {
    /*
    // DContext providers.
    protected array<string, array> myproviders = null;

    /**
     * Constructor.
     * Params:
     * array myproviders Array of provider callables. Each element should
     *  be of form `["type": "a-string", "callable": ..]`
     * /
    this(array myproviders = []) {
        foreach (myproviders as myprovider) {
            this.addProvider(myprovider["type"], myprovider["callable"]);
        }
    }
    
    /**
     * Create factory instance with providers "array", "form" and "orm".
     * Params:
     * array myproviders Array of provider callables. Each element should
     *  be of form `["type": "a-string", "callable": ..]`
     * /
    static static createWithDefaults(array myproviders = []) {
        auto myproviders = [
            [
                "type": "orm",
                "callable": auto (myrequest, mydata) {
                    if (cast(IEntity)mydata["entity"]) {
                        return new DEntityContext(mydata);
                    }
                    if (isSet(mydata["table"])) {
                        return new DEntityContext(mydata);
                    }
                    if (is_iterable(mydata["entity"])) {
                        mypass = (new DCollection(mydata["entity"])).first() !isNull;
                        if (mypass) {
                            return new DEntityContext(mydata);
                        } else {
                            return new DNullContext(mydata);
                        }
                    }
                },
            ],
            [
                "type": "form",
                "callable": auto (myrequest, mydata) {
                    if (cast(DForm)mydata["entity"]) {
                        return new DFormContext(mydata);
                    }
                },
            ],
            [
                "type": "array",
                "callable": auto (myrequest, mydata) {
                    if (isArray(mydata["entity"]) && isSet(mydata["entity"]["schema"])) {
                        return new ArrayContext(mydata["entity"]);
                    }
                },
            ],
            [
                "type": "null",
                "callable": auto (myrequest, mydata) {
                    if (mydata["entity"] is null) {
                        return new DNullContext(mydata);
                    }
                },
            ],
        ] + myproviders;

        return new static(myproviders);
    }
    
    /**
     * Add a new context type.
     *
     * Form context types allow FormHelper to interact with
     * data providers that come from outside UIM. For example
     * if you wanted to use an alternative ORM like Doctrine you could
     * create and connect a new context class to allow FormHelper to
     * read metadata from doctrine.
     * Params:
     * string typeOfContext The type of context. This key can be used to overwrite existing providers.
     * @param callable mycheck A callable that returns an object
     *  when the form context is the correct type.
     * /
    void addProvider(string typeOfContext, callable mycheck) {
        this.providers = [typeOfContext: ["type": typeOfContext, "callable": mycheck]]
            + this.providers;
    }
    
    /**
     * Find the matching context for the data.
     *
     * If no type can be matched a NullContext will be returned.
     * Params:
     * \UIM\Http\ServerRequest serverRequest Request instance.
     * @param IData[string] mydata The data to get a context provider for.
     * /
    IFormContext get(ServerRequest serverRequest, array data = []) {
        mydata += ["entity": null];

        foreach (this.providers as myprovider) {
            mycheck = myprovider["callable"];
            mycontext = mycheck(serverRequest, mydata);
            if (mycontext) {
                break;
            }
        }
        if (!isSet(mycontext)) {
            throw new UimException(
                "No context provider found for value of type `%s`."
                ~ " Use `null` as 1st argument of FormHelper.create() to create a context-less form."
                .format(get_debug_type(mydata["entity"])
            ));
        }
        return mycontext;
    } */
}
