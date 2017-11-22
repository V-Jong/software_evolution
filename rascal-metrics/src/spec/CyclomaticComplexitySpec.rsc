module spec::CyclomaticComplexitySpec

import main::CyclomaticComplexity;
import IO;

test bool CyclomaticComplexitySpec() {
	loc location = |project://rascal-metrics/src/spec/resources/CyclomaticComplexity.java|;
	result = ccPerProjectFiles({location});
	
	return result[0][0] == 2;
}
