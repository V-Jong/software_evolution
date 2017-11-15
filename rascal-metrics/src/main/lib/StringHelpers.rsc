module main::lib::StringHelpers

import String;

public void printStringList(list[str] source) {
	for(line <- source) {
		println(line);
	}
}

public list[str] toList(str input) {
  return [input[i] | i <- [0..size(input)]];
}

public str head(input) = input[0];
public str tail(input) = input[1..];
