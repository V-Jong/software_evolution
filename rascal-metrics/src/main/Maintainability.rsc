module main::Maintainability

import List;
import Map;

public str calculateMaintainabilityCharacteristic(list[str] metricScores) {
	total = sum([metricScoreIntVals()[metricScore] | metricScore <- metricScores ]) / size(metricScores);
	return getScoreFromIntVal(total);
}

private map[str, int] metricScoreIntVals() = ("++":4, "+":3, "o":2, "-":1, "--":0);

private str getScoreFromIntVal(int val) {
	return invertUnique(metricScoreIntVals())[val];
}