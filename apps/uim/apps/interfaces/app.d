/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.apps.interfaces.app;

import uim.apps;

@safe:
interface IApp : IObject {
    // #region controllers
    IController[] controllers();
    
    IController controller(string key);
    IApp controller(string key, IController newController);
    // #endregion controllers

    // #region models
    IModel[] models();

    IModel model(string key);
    IApp model(string key, IModel newModel);
    // #endregion models

    // #region views
    IView[] views();

    IView view(string key);
    IApp view(string key, IView newView);
    // #endregion views
}