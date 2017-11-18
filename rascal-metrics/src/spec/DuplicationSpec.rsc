module spec::DuplicationSpec

import main::Duplication;
import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

test bool duplicationTest() {
    M3 model = createM3FromEclipseProject(|project://example|);
    int result = duplicationPercentageOfModel(model);
    println(result);
    return true;
}

test bool slidingWindow() {
	lrel[int, int] result = slidingWindow(7);
	return result == [<0,6>, <1,6>];
}