module main::lib::MapHelpers

import Set;
import Map;

public map[&V, set[&K]] groupByValue(map[&K, &V] genericMap) {
	&V getValue(&K key) = genericMap[key];
	return classify(domain(genericMap), getValue);
}

public list[&V] values(map[&K, &V] genericMap) {
	return [genericMap[key] | key <- genericMap];
}