module spec::CloneDetectorSpec

import main::Main;

test bool isSubsumptedSpec() {
	set[set[str]] someSet = {{"a", "b", "c"}};
	
	return isSubsumpted({"a"}, someSet);
}

test bool isSubsumptedSpec() {
	set[set[str]] someSet = {{"a", "b", "c"}};
	
	return !isSubsumpted({"d"}, someSet);
}

test bool getSiblingsSpec() {
	set[set[str]] someSet = {{"a", "b", "c"}, {"d", "e", "f"}};
	
	return getSiblings("a", someSet) == {{"b", "c"}};
}