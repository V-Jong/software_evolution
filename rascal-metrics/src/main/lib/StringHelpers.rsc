module main::lib::StringHelpers


public void printStringList(list[str] source) {
	for(line <- source) {
		println(line);
	}
}
