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

public map[&V, set[&K]] categorize(map[&K, &V] genericMap, category) {
	&V getCategory(&K key) = category(key);
	return classify(domain(genericMap), getCategory);
}

public map[&K, &V2] mapValues(map[&K, &V] genericMap, fn) {
	return (key: fn(genericMap[key]) | key <- genericMap);
}