module Volume

import IO;
import lang::java::m3::Core;
import List;

//M3 helloWorldModel = createM3FromDirectory(|project://smallsql0.21_src|);
//list[loc] helloWorldMethods = [ e | e <- helloWorldModel.containment[|java+class:///CommandLine|], e.scheme == "java+method"];

void printModel() {
    iprintln(helloWorldMethods);
}

void numberOfMethods() {
    int size = size(helloWorldMethods);
    println(size);
}

void printC() {
    println("hello");
}
