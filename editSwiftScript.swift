#!/usr/bin/swift
import Foundation

// MARK: shell()

@discardableResult
func shell(_ args: String...) -> Int32 {
    var args = args
    args.insert("-c", at: 0)

    let task = Process()
    task.launchPath = "/bin/sh"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

// MARK: project template dir location

let currentDirUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let templateProjectName = "script-edit-xcode-project"

func getTemplateProjectUrl() -> URL {
	let urlInCurrentDir = currentDirUrl.appendingPathComponent(templateProjectName)
	if FileManager.default.fileExists(atPath: urlInCurrentDir.path) { return urlInCurrentDir }
	
	let urlInOpt = URL(fileURLWithPath: "/usr/local/opt/editSwiftScript").appendingPathComponent(templateProjectName)
	if FileManager.default.fileExists(atPath: urlInOpt.path) { return urlInOpt }
	
	print("❌ template project is not found")
	exit(-1)
}

// MARK: check inputs

guard CommandLine.arguments.count == 2 else {
	let executableName = (CommandLine.arguments.first! as NSString).lastPathComponent
	print("❌ usage \(executableName) existingScriptName.swift")
	exit(0)
}

// MARK: check script exists or offer to create it

let originalScriptName = CommandLine.arguments[1]
let originalScriptUrl = currentDirUrl.appendingPathComponent(originalScriptName)

if FileManager.default.fileExists(atPath: originalScriptUrl.path) == false { 
	print("❗ file does not exist: \(originalScriptUrl.path), create? y/Y")
	let res = readLine()
	guard res?.lowercased() == "y" else { print("❌  aborting"); exit(0) }
	
	let newFileContents = """
#!/usr/bin/swift
import Foundation


""".data(using: .utf8)

	// 0o755 is -rwxr-xr-x file attributes
	FileManager.default.createFile(atPath: originalScriptUrl.path, contents: newFileContents, attributes: [.posixPermissions : 0o755])
	if FileManager.default.fileExists(atPath: originalScriptUrl.path) == false {
		print("❌  could not create a file")
		exit(0)
	}
}

// - MARK: main logic

let xcodeTemplateUrl = getTemplateProjectUrl()
let projectSandbox = URL(fileURLWithPath: "/tmp").appendingPathComponent(UUID().uuidString)
let projectFolder = projectSandbox.appendingPathComponent(templateProjectName)
let xcodeprojUrl = projectFolder.appendingPathComponent(templateProjectName).appendingPathExtension("xcodeproj")
let mainFileUrl = projectFolder.appendingPathComponent(templateProjectName).appendingPathComponent("main.swift")

// MARK: copy template project to /tmp

print("creating sandbox at: \(projectSandbox.path)")
try! FileManager.default.createDirectory(at: projectSandbox, withIntermediateDirectories: true, attributes: nil)
try! FileManager.default.copyItem(at: xcodeTemplateUrl, to: projectFolder)
try? FileManager.default.removeItem(at: mainFileUrl)
try! FileManager.default.copyItem(at: originalScriptUrl, to: mainFileUrl)

_ = shell("open -a xcode \(xcodeprojUrl.path)")

let greenRightArrow = "\u{001B}[0;32m➤\u{001B}[0m"

print(
"""

\(greenRightArrow) When you're done editing:
	- close xcode CMD + w (otherwise xcode will crash after sandbox project is deleted)
	- hit enter
After that, the file at following path will be removed and replaced with edited contents: \(originalScriptUrl.path)

""")
_ = readLine()

// MARK: copy edited script back

print("removing file at \(originalScriptUrl.path)")
try! FileManager.default.removeItem(at: originalScriptUrl)
print("copying modified file back")
try! FileManager.default.copyItem(at: mainFileUrl, to: originalScriptUrl)
print("removing sandbox at: \(projectSandbox.path)")
try! FileManager.default.removeItem(at: projectSandbox)
print("✅ done")
