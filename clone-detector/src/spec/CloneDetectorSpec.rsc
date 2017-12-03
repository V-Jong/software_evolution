module spec::CloneDetectorSpec

import main::Main;

test bool memberOfSetSpec() {
	set[set[str]] someSet = {{"a", "b", "c"}};
	
	return memberOfSet({"a"}, someSet);
}

test bool memberOfSetSpec() {
	set[set[str]] someSet = {{"a", "b", "c"}};
	
	return !memberOfSet({"d"}, someSet);
}