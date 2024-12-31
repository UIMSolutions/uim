module uim.http.enumerations.samesite;

enum SAMESITE : string {
    NONE = "None",
    LAX = "Lax",
    STRICT = "Strict"
}

SAMESITE toSamesite(string name) {
    /* switch(name.toLower) {
        case "lax": return SAMESITE.LAX;
        case "strict": return SAMESITE.STRICT;
        default: return SAMESITE.NONE;
    } */
    return SAMESITE.NONE;
}

/* Using vive.d

Enum Cookie.SameSite

enum SameSite : int { 
    default_,	
    lax,	
    strict
}	

Or?
enum SameSiteEnum : string {
    LAX = "Lax",
    STRICT = "Strict",
    NONE = "None"
}
*/