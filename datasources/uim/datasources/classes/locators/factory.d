/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.datasources.classes.locators.factory;

import uim.datasources;

@safe:

class DFactoryLocator {
    // A list of model factory functions.
    protected static ILocator[string] _modelFactories;

    // Register a callable to generate repositories of a given type.
    static void add(string repositoryType, ILocator factory) {
        if (cast(ILocator)factory) {
            _modelFactories[repositoryType] = factory;

            return;
        }

        if (is_callable(factory)) {
            deprecationWarning(
                "Using a callable as a locator has been deprecated."
                ~ " Use an instance of uim\Datasource\Locator\ILocatorinstead."
           );

            _modelFactories[repositoryType] = factory;

            return;
        }

        throw new DInvalidArgumentException("`factory` must be an instance of uim\Datasource\Locator\ILocator a callable. Got type `%s` instead."
            .format(getTypeName(factory)
       ));
    }

    /**
     * Drop a model factory.
     * aRepositoryTypeName - The name of the repository type to drop the factory for.
     */
    static void drop(string aRepositoryTypeName) {
        _modelFactories.removeByKey(aRepositoryTypeName));
    }

    // Get the factory for the specified repository type.
    static ILocator get(string repositoryType) {
        if ("Table"  !in _modelFactories) {
            _modelFactories.set("Table", new DTableLocator());
        }

        if (!_modelFactories.hasKey(repositoryType)) {
            throw new DInvalidArgumentException(
                "Unknown repository type '%s'. Make sure you register a type before trying to use it."
                .format(repositoryType)
           );
        }

        return _modelFactories[repositoryType];
    } 
}
