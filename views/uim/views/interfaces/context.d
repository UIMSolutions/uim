module uim.views.interfaces.context;

import uim.views;

@safe: 
interface IFormContext {
    bool isRequired(string fieldName);
    /* void set(string key, string value);
    string get(string key);
    void remove(string key);
    void clear(); */
}