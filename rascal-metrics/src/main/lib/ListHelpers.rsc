module main::lib::ListHelpers

import List;
import IO;

public list[&T] zipWithIndex(list[&L] genericList) {
	return zip(genericList, [0..size(genericList)]);
}

public str toStringHash(list[str] lines) {
	result = "";
	for(line <- lines) {
		result = result + line;
	}
	return result;
}

public void printStringList(list[str] source) {
	for(line <- source) {
		println(line);
	}
}

public list[&T] flatten(list[list[&T]] elems) {
	return [elem | subElems <- elems, elem <- subElems];
}