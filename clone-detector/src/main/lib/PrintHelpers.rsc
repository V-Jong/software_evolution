module main::lib::PrintHelpers

private void printSource(loc source) {
	println(readFile(source));
}

private void printGroup(map[node, set[node]] group) {
	for (key <- group) {
		println(key);
		println("##########");			
		for (cloneClass <- group[key]) {
			println(cloneClass);
		}
		println("");
		println("");
	}
}

private void printCloneClasses(map[node, set[node]] cloneClasses) {
	set[set[node]] cloneGroups = range(cloneClasses);
	
	for(cloneGroup <- cloneGroups) {
		for(clone <- cloneGroup) {
			switch (clone) {
				case Declaration x: {
					println(x.src);
					//println(readFile(x.src));
				}
				case Expression x: {
					println(x.src);
					//println(readFile(x.src));
				}
				case Statement x: {
					println(x.src);
					//println(readFile(x.src));
				} 
			}
		}
	}
}