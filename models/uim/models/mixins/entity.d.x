module uim.models.mixins.entity;

// #region EntityThis
  string entityThis(string shortName, string className = null) {
    string clName = className.length > 0 ? className : "D"~shortName;
    return `
      this() { super(); this.className("`~shortName~`"); }
      this(UUID myId) { this().id(myId).name("`~shortName~`-"~this.id.toString); }
      this(string myName) { this().name(myName); }
      this(UUID myId, string myName) { this(myId).name(myName); }
      this(Json aJson) { this().fromJson(aJson); }

      override DEntity create() { return new `~clName~`; }
    `;
  }

  template EntityThis(string shortName, string className = null) {
    const char[] EntityThis = entityThis(shortName, className);
  }
// #endregion EntityThis

// #region EntityCalls
  string entityCalls(string shortName, string className = null) {
    string clName = className.length > 0 ? className : "D"~shortName;
    return `
      auto `~shortName~`() { return new `~clName~`; } 
      auto `~shortName~`(UUID myId) { return new `~clName~`(myId); } 
      auto `~shortName~`(string myName) { return new `~clName~`(myName); } 
      auto `~shortName~`(UUID myId, string myName) { return new `~clName~`(myId, myName); } 
      auto `~shortName~`(Json json) { return new `~clName~`(json); } 
    `;
  }

  template EntityCalls(string shortName, string className = null) {
    const char[] EntityCalls = entityCalls(shortName, className);
  }
// #endregion EntityCalls
