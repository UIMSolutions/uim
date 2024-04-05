module uim.views.mixins.viewvars;

import uim.views;

@safe:

/**
 * Provides the set() method for collecting template context.
 *
 * Once collected context data can be passed to another object.
 * This is done in Controller, TemplateTask and View for example.
 */
mixin template ViewVarsTemplate {
    // The view builder instance being used.
    protected DViewBuilder _viewBuilder = null;

    // Get the view builder being used.
    DViewBuilder viewBuilder() {
        return !_viewBuilder.isNull ? _viewBuilder : new DViewBuilder();
    }
    
    /**
     * Constructs the view class instance based on the current configuration.
     * Params:
     * string|null namespacedClassname Optional namespaced class name of the View class to instantiate.
     * /
    View createView(string namespacedClassname = null) {
        auto mybuilder = this.viewBuilder();
        if (namespacedClassname) {
            mybuilder.setClassName(namespacedClassname);
        }

        ["name", "plugin"].each!((prop) {
            if (isSet(this.{prop})) {
                auto mymethod = "set" ~ ucfirst(prop);
                mybuilder.{mymethod}(this.{prop});
            }
        });
        
        return mybuilder.build(
            this.request.ifNull(null),
            this.response ?? null,
            cast(IEventDispatcher)this ? this.getEventManager(): null
        );
    }
    
    /**
     * Saves a variable or an associative array of variables for use inside a template.
     * Params:
     * string[] views A string or an array of data.
     * @param IData aValue Value in case views is a string (which then works as the key).
     *  Unused if views is an associative array, otherwise serves as the values to views"s keys.
     * /
    void set(string[] views, IData aValue = null) {
        if (views.isArray) {
            if (myvalue.isArray) {
                mydata = array_combine(views, myvalue);
            } else {
                mydata = views;
            }
        } else {
            mydata = [views: myvalue];
        }
        this.viewBuilder().setData(mydata);
    } */
} 
