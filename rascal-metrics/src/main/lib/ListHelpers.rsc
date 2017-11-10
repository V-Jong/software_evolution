module main::lib::ListHelpers

import List;

public list[&T] zipWithIndex(list[&L] genericList) {
	return zip(genericList, [1..size(genericList)+1]);
}
