# Software Evolution Series 2
Software Evolution UvA

Rascal Clone Detector


How to use:

Register the language and contributions:

```rascal>import main::IDEIntegration;
rascal>register();
Registered the language Clone Detection with file extension java
Registered contributions
```

Then right click on a java file from an Eclipse project and click on "Detect Clones". The clone detector will run and show a visualisation of the detected clones. In addition clones in files are annotated and shown in the outline. By ctrl+clicking (cmd+click on Mac) you can jump to other clones in the detected clone class.

A log file with clone classes is printed to src/clone_log.txt
