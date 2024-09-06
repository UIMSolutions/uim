module uim.apps.interfaces.app;

import uim.apps;
@safe:

interface IApp : IApplication, IMVCObject, IRequestHandler, IControllerManager, ISessionManager, IViewManager, IRouteManager {
  IEntityBase entityBase();
  IAppManager manager();
  void manager(IAppManager aManager);
}
