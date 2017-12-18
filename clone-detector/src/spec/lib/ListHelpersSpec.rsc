module spec::lib::ListHelpersSpec

import main::lib::ListHelpers;

test bool flatten() {
	return flatten([["a"],["b"],["c"]]) == ["a", "b", "c"];
}
