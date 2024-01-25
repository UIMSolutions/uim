module uim.oop.mixins.configdata;

template ConfigDataThis() {
	const char[] ConfigDataThis = 
	`this() { super(); }`;
}

template ConfigDataCalls(string shortName) {
	const char[] ConfigDataCalls = `
	auto `~shortName~`() { return new D`~shortName~`(); }
	`;
}