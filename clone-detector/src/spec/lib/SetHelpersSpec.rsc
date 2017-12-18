module spec::lib::SetHelpersSpec

import main::lib::SetHelpers;

test bool flatten() {
	return flatten({{"a"},{"b"},{"c"}}) == {"a", "b", "c"};
}