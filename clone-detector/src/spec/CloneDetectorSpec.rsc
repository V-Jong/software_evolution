module spec::CloneDetectorSpec

import main::Main;
import IO;

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

test bool filterNonDuplicatesSpec() {
	map[&T, set[&T]] someMap = (1: {1}, 2: {1,2}, 3:{1,2,3});
	
	return filterNonDuplicates(someMap) == (2: {1,2}, 3:{1,2,3});
}