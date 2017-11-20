module main::Maintainability

import List;
import Map;

public str calculateMaintainabilityCharacteristic(list[str] metricScores) {
	total = sum([metricScoreIntVals()[metricScore] | metricScore <- metricScores ]) / size(metricScores);
	return getScoreFromIntVal(total);
}

private map[str, int] metricScoreIntVals() = ("++":2, "+":1, "o":0, "-":-1, "--":-2);

private str getScoreFromIntVal(int val) {
	if (val > 2) return "++";
	if (val < -2) return "--";
	return invertUnique(metricScoreIntVals())[val];
}