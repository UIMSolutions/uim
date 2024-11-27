/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.apps.interfaces.application;

import uim.apps;

@safe:
interface IApplication : INamed {
    // #region controllers
    IControllers[string] controllers();
    
    IController controller(string key);
    IApplication controller(string key, IController newController);
    // #endregion controllers

    // #region models
    IModels[string] models();

    IModel model(string key);
    IApplication model(string key, IModel newModel);
    // #endregion models

    // #region views
    IView[string] views();

    IView view(string key);
    IApplication view(string key, IView newView);
    // #endregion views
}