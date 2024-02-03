module uim.oop.interfaces.consoleapplication;

import uim.oop;

@safe:

// An interface defining the methods that the console runner depend on.
interface IConsoleApplication {
    /**
     * Load all the application configuration and bootstrap logic.
     *
     * Override this method to add additional bootstrap logic for your application.
     */
    void bootstrap();

    // Define the console commands for an application.
    // TODO CommandCollection console(CommandCollection addCollection);
}
