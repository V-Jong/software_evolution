module main::LinesOfCode

import IO;
import List;
import String;
import Set;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import main::lib::StringHelpers;
import main::lib::ListHelpers;
import main::CommentRemover;

public int totalLines(map[loc, list[str]] locationLines) {
 	return sum([size(locationLines[location])|location <- locationLines]);
}
