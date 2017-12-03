module main::lib::ListHelpers

public list[&T] flatten(list[list[&T]] elems) {
	return [elem | subElems <- elems, elem <- subElems];
}