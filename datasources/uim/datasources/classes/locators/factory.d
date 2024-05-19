/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.datasources.classes.locators.factory;

import uim.datasources;

@safe:

class DFactoryLocator {
    // A list of model factory functions.
    protected static ILocator[string] _modelFactories;

    /**
     * Register a callable to generate repositories of a given type.
     *
     * @param string type The name of the repository type the factory bool is for.
     */
    static void add(string repositoryType, ILocator factory) {
        if (factory instanceof ILocator) {
            _modelFactories[type] = factory;

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
        _modelFactories.remove(aRepositoryTypeName));
    }

    /**
     * Get the factory for the specified repository type.
     *
     * @param string type The repository type to get the factory for.
     * @throws \InvalidArgumentException If the specified repository type has no factory.
     */
    static ILocator get(string type) {
        if ("Table"  !in _modelFactories) {
            _modelFactories["Table"] = new DTableLocator();
        }

        if (!isset(_modelFactories[type])) {
            throw new DInvalidArgumentException(
                "Unknown repository type '%s'. Make sure you register a type before trying to use it."
                .format(type)
            );
        }

        return _modelFactories[type];
    } 
}
