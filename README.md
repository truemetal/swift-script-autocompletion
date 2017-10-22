### Hey there

Did you ever have a need to make a tiny `.swift` script to do some stuff, but struggled to code it without xcode's autocompletion?

Yeah, obviously you can make a command-line application in xcode but then it's not tiny anymore. You have to keep the whole project folder, and you can't put it in `/usr/local/bin` unless you compile. 

Tiny swift scripts are cool. You can `chmod +x file.swift; mv file.swift /usr/local/bin/` and then you can just run `file.swift` in terminal, you can even drop `.swift` extension and still edit the script in place if you need to tweak something.


### editSwiftScript.swift

This (small and very hackable) script kinda allows to have best of both worlds: 
- from terminal run `./editSwiftScript.swift existingScriptName.swift` and it will:
  - check that file exists, and if not - it will suggest to create one and set executable file permission
  - create a folder in `/tmp`, and copy a template xcode project there as well as your script to project's `main.swift`
  - run xcode for you 
- after you done, you hit `enter` and script:
  - copies contents of `main.swift` to your script
  - removes folder in `/tmp`
  
### install.sh
  
To use this tool on more or less permanent basis, there's `install.sh` which would: 
- copy script (and supporting xcode project) to `/usr/local/opt`
- add symlink to `/usr/local/bin`

After that you can run tool from terminal just by `editSwiftScript fileName.swift`

### uninstall.sh

This script just removes what `install.sh` created
