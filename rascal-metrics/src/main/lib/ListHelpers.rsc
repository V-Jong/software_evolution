module main::lib::ListHelpers

import List;
import IO;
import main::lib::MapHelpers;

public list[&T] zipWithIndex(list[&L] genericList) {
	return zip(genericList, [0..size(genericList)]);
}

public void printStringList(list[str] source) {
	for(line <- source) {
		println(line);
	}
}

public list[&T] flatten(list[list[&T]] elems) {
	return [elem | subElems <- elems, elem <- subElems];
}

public map[&K, list[&E]] groupBy(list[&E] elems, fn) {
	set[&K] keys = { fn(elem) | elem <- elems };
	return toMapUnique([<key, [elem | elem <- elems, fn(elem) == key]> | key <- keys]);
}

public bool forall([]) = true;
public default bool forall(list[bool] elems) {
	if (elems[0]) { 
		return forall(elems[1..]);
	}
	return false;
}