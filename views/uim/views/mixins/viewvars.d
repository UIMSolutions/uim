module uim.views.mixins.viewvars;

import uim.views;

@safe:

/**
 * Provides the set() method for collecting template context.
 *
 * Once collected context data can be passed to another object.
 * This is done in Controller, TemplateTask and View for example.
 */
mixin template TViewVars() {
    // The view builder instance being used.
    protected DViewBuilder _viewBuilder = null;

    // Get the view builder being used.
    DViewBuilder viewBuilder() {
        return !_viewBuilder.isNull ? _viewBuilder : new DViewBuilder();
    }
    
    /**
     * Constructs the view class instance based on the current configuration.
     * Params:
     * string namespacedclassname Optional namespaced class name of the View class to instantiate.
     */
    View createView(string namespacedclassname = null) {
        auto mybuilder = viewBuilder();
        if (namespacedclassname) {
            mybuilder.setclassname(namespacedclassname);
        }

        ["name", "plugin"].each!((prop) {
            if (this.{prop} !is null) {
                auto mymethod = "set" ~ capitalize(prop);
                mybuilder.{mymethod}(this.{prop});
            }
        });
        
        return mybuilder.build(
            _request.ifNull(null),
            this.response ?? null,
            cast(IEventDispatcher)this ? getEventManager(): null
       );
    }
    
    // Saves a variable or an associative array of variables for use inside a template.
void set(string viewName, Json aValue = null) {
        auto mydata = [views: myvalue];
        viewBuilder().setData(mydata);
    }
    void set(string[] views, Json aValue = null) {
        auto mydata = myvalue.isArray
                ? combine(views, myvalue)
                : views;
     
        viewBuilder().setData(mydata);
    }
} 
