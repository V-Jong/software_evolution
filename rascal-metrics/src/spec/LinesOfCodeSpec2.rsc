module spec::LinesOfCodeSpec2

import main::LinesOfCode2;
import IO;

test bool shouldEmptyStrings() {
	str input = readFile(|home:///dev/courses/mse/software-evolution/software_evolution/rascal-metrics/src/spec/resources/Strings.java|);
    int result = stringProcessor(input, false, false, false, false, 0);
    println(result);
   
    return  result == 4;
}