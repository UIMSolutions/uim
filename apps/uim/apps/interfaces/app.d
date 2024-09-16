/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.apps.interfaces.app;import uim.apps;@safe:interface IApp : IApplication, IMVCObject, IRequestHandler, IControllerManager, ISessionManager, IViewManager, IRouteManager {  IEntityBase entityBase();  IAppManager manager();  void manager(IAppManager aManager);}