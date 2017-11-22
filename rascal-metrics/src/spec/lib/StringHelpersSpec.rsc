module spec::lib::StringHelpersSpec

import main::lib::StringHelpers;

test bool toList() {
	return toList("Hello") == ["H", "e", "l", "l", "o"];
}

test bool head() {
	return head("Hello") == "H";
}

test bool tail() {
	return tail("Hello") == "ello";
}

test bool padLeft() {
	return padLeft("55555", 6, "0") == "055555";
}
