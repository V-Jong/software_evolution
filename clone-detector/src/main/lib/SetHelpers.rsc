module main::lib::SetHelpers

public set[&T] flatten(set[set[&T]] elems) {
	return {elem | subElems <- elems, elem <- subElems};
}