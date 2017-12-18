module spec::lib::ListHelpersSpec

import main::lib::ListHelpers;

test bool zipWithIndex() {
	return zipWithIndex(["a", "b", "c"]) == [<"a", 0>, <"b", 1>, <"c", 2>];
}

test bool flatten() {
	return flatten([["a"],["b"],["c"]]) == ["a", "b", "c"];
}

test bool groupBy() {
	return groupBy([1,2,3,4], isEven) == (true: [2,4], false: [1,3]);
}

test bool forall() {
	return forall([true, true, true]) == true;
}

test bool forall() {
	return forall([true, false, true]) == false;
}

bool isEven(int i) {
	return i % 2 == 0;
}
