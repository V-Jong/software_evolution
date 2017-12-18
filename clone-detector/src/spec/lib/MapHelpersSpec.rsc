module spec::lib::MapHelpersSpec

import main::lib::MapHelpers;

test bool groupByValue() {
	return groupByValue(("ana" : "teacher", "riemer": "teacher", "vincent": "student", "rocco": "student")) == ("student": {"vincent", "rocco"}, "teacher": {"riemer", "ana"}) ;
}

test bool values() {
	return values(("key": "value")) == ["value"];
}

test bool mapValues() {
	return mapValues(("a": 1), double) == ("a": 2);
}

int double(int x) {
	return x * 2;
}
