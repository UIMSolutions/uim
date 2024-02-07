module uim.oop.mixins.data;

template DataThis() {
	const char[] DataThis = 
	`this() { super(); }`;
}

template DataCalls(string shortName) {
	const char[] DataCalls = `
	auto `~shortName~`() { return new D`~shortName~`(); }
	`;
}