/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.routings.middlewares.asset;

import uim.routings;

@safe:
/**
 * Handles serving plugin assets in development mode.
 *
 * This should not be used in production environments as it
 * has sub-optimal performance when compared to serving files
 * with a real webserver.
 */
class DAssetMiddleware : UIMObject, IRoutingMiddleware {
    // The amount of time to cache the asset.
    protected string _cacheTime = "+1 day";

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

      if (options.hasKey("cacheTime")) {
          _cacheTime = options.getString("cacheTime");
      }
    }
    
    // Serve assets if the path matches one.
    IResponse process(IServerRequest serverRequest, IRequestHandler requestHandler) {
        auto url = serverRequest.getUri().getPath();
        
        if (url.contains("..") || !url.contains(".")) {
            return requestHandler.handle(serverRequest);
        }
        if (url.contains("/.")) {
            return requestHandler.handle(serverRequest);
        }
        
        auto assetFile = _getAssetFile(url);
        if (assetFile.isNull || !isFile(assetFile)) {
            return requestHandler.handle(serverRequest);
        }
        
        auto file = new DFileInfo(assetFile);
        auto modifiedTime = file.getMTime();
        if (this.isNotModified(serverRequest, file)) {
            return (new DResponse())
                .withStringBody("")
                .withStatus(304)
                .withHeader(
                    "Last-Modified",
                    date(DATE_RFC850, modifiedTime)
               );
        }
        return _deliverAsset(serverRequest, file);
    }
    
    // Check the not modified header.
    protected bool isNotModified(IServerRequest serverRequest, SplFileInfo file) {
        auto modifiedSince = serverRequest.getHeaderLine("If-Modified-Since");
        if (!modifiedSince) {
            return false;
        }
        return strtotime(modifiedSince) == file.getMTime();
    }
    
    // Builds asset file path based off url
    /*
    protected string _getAssetFile(string assetUrl) {
        string[] someParts = stripLeft(assetUrl, "/").split("/");
        auto pluginPart = null;
        for (index = 0;  index < 2;  index++) {
            if (someParts.isNull(index)) {
                break;
            }
            string[] pluginPart ~= someParts[index].camelize
            string plugin = pluginPart.join("/");
            if (Plugin.isLoaded(plugin)) {
                someParts =someParts.slice(index + 1);
                fileFragment = someParts.join(DIRECTORY_SEPARATOR);
                pluginWebroot = Plugin.path(plugin) ~ "webroot" ~ DIRECTORY_SEPARATOR;

                return pluginWebroot ~ fileFragment;
            }
        }
        return null;
    } */

    // Sends an asset file to the client
    protected IResponse deliverAsset(IServerRequest serverRequest, DFileInfo file) {
        auto resource = fopen(file.getPathname(), "rb");
        if (resource == false) {
            throw new UIMException("Cannot open resource `%s`".format(file.getPathname()));
        }
        autstream = new DStream(resource);

        auto response = new DResponse(["stream": stream]);

        auto contentType =  /* (array) */ response.getMimeType(file.getExtension()) ? response.getMimeType(
                file.getExtension()) : "application/octet-stream";
        auto modified = file.getMTime();
        auto expire = strtotime(this.cacheTime);
        if (expire == false) {
            throw new UIMException("Invalid cache time value `%s`".format(this.cacheTime));
        }
        auto maxAge = expire - time();

        return response
            .withHeader("Content-Type", contentType[0])
            .withHeader("Cache-Control", "public,max-age=" ~ maxAge)
            .withHeader("Date", gmdate(DATE_RFC7231, time()))
            .withHeader("Last-Modified", gmdate(DATE_RFC7231, modified))
            .withHeader("Expires", gmdate(DATE_RFC7231, expire));
    }
}
