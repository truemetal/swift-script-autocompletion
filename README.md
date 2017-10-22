Did you ever have a need to make a tiny `.swift` script to do some stuff, but struggled to code it without xcode's autocompletion? 

Yeah, obviously you can make a command-line application in xcode but then it's not tiny anymore. You have to keep the whole project file, and you can't put it in `/usr/local/bin` unless you compile. 

Compare it with `chmod +x file.swift; mv file.swift /usr/local/bin/` and you can just run `file.swift` whenever you need, you can even drop `.swift` extension and still edit it in place if you need to hack something.

This (small and very hackable) script kinda allows to have best of both worlds: 
- `./editSwiftScript.swift existingScriptName.swift` and it will:
- - create a folder in `/tmp`
- - copy a template xcode project there
- - copy your script to project's `main.swift`
- - run xcode for you 
- after you done, you hit `enter` and script:
- - copies contents of `main.swift` to your script
- - removes folder in `/tmp`
