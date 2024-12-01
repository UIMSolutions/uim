module uim.i18n.classes.loaders.messagefile;

import uim.i18n;

@safe:

/**
 * A generic translations catalog factory that will load translations files
 * based on the file extension and the catalog name.
 *
 * This class is a callable, so it can be used as a catalog loader argument.
 */
class DMessagesFileLoader : UIMObject {
    this() {
        super();
    }

    // The catalog (domain) name.
    protected string _name;

    // The catalog (domain) plugin
    protected string _plugin = null;

    // The locale to load for the given catalog.
    protected string _locale;

    // The extension name.
    protected string _extension;

    /**
     * Loads the translation file and parses it. Returns an instance of a translations
     * catalog containing the messages loaded from the file.
     */
    DMessageCatalog catalog() {
        auto folders = translationsFolders();
        auto file = translationFile(folders, _name, _extension);
        if (file.isEmpty) { // No file to load
            return null;
        }
        // ...
        return null; // TODO
    }

    /**
     * Returns the folders where the file should be looked for according to the locale
     * and catalog name.
     */
    string[] translationsFolders() {
        return null; // TODO 
    }

    protected string translationFile(string[] folders, string fileName, string fileExtension) {
        fileName = fileName.replace("/", "_");
        foreach(folder; folders) {
            string filePath = folder ~ fileName ~ "." ~ fileExtension;
            if (filePath.isFile) {
                return filePath;
                // TODO ist always false because "_";
            }
        }

        return null;
    }
}