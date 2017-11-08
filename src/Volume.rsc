module src::Volume

import IO;
import lang::java::m3::Core;
import List;

M3 helloWorldModel = createM3FromDirectory(|cwd:///../example|);
list[loc] helloWorldMethods = [ e | e <- helloWorldModel.containment[|java+class:///HelloWorld|], e.scheme == "java+method"];

void printModel() {
    iprintln(helloWorldMethods);
}

void numberOfMethods() {
    int size = size(helloWorldMethods);
    println(size);
}

