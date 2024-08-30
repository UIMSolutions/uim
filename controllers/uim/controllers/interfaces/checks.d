module uim.controllers.interfaces.check:

interface IControllerCheck {
bool run(IController controller, Json[string] options = null);
}