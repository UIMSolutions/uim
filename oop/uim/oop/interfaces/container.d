module oop.uim.oop.interfaces.container;

import uim.oop;

@safe:

/**
 * Interface for the Dependency Injection Container in UIM applications
 *
 * This interface : the PSR-11 container interface and adds
 * methods to add services and service providers to the container.
 *
 * The methods defined in this interface use the conventions provided
 * by league/container as that is the library that UIM uses.
 */
interface IContainer : IDefinitionContainer {
    // @param \Psr\Container\IContainer container The container instance to use as delegation
    IPsrContainer delegate(IPsrContainer container);
}
