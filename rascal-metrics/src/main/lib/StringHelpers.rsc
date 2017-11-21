module main::lib::StringHelpers

import String;

public list[str] toList(str input) {
  return [input[i] | i <- [0..size(input)]];
}

public str head(input) = input[0];

public str tail(input) = input[1..];

public str padLeft(str input, int length, str padChar) {
	if (size(input) >= length) {
		return input;
	}
	return padLeft(padChar + input, length, padChar);
}