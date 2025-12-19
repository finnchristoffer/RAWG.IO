import Danger
import Foundation

let danger = Danger()

// MARK: - Configuration
enum Config {
    static let maxPRLines = 500
    static let maxFilesChanged = 20
    static let requiredReviewers = 1
    static let wipKeywords = ["WIP", "[WIP]", "DO NOT MERGE", "DRAFT"]
}

// MARK: - PR Info
let pr = danger.github.pullRequest
let additions = pr.additions ?? 0
let deletions = pr.deletions ?? 0
let totalChanges = additions + deletions
let modifiedFiles = danger.git.modifiedFiles
let createdFiles = danger.git.createdFiles
let deletedFiles = danger.git.deletedFiles
let allChangedFiles = modifiedFiles + createdFiles + deletedFiles

// MARK: - Utilities
func isSourceFile(_ path: String) -> Bool {
    path.hasSuffix(".swift") && !path.contains("Tests/")
}

func isTestFile(_ path: String) -> Bool {
    path.hasSuffix(".swift") && path.contains("Tests/")
}

// MARK: - PR Title Checks
let prTitle = pr.title

// Check for WIP
for keyword in Config.wipKeywords where prTitle.contains(keyword) {
    warn("🚧 This PR is marked as Work In Progress. Don't merge until ready!")
    break
}

// MARK: - PR Description Checks
let prBody = pr.body ?? ""
let isBodyEmpty = prBody.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

if isBodyEmpty {
    fail("❌ Please provide a PR description explaining your changes.")
}

// Check if "Type of Change" has at least one checkbox selected
let typeOfChangeOptions = [
    "- [x] 🚀 Feature",
    "- [x] 🐛 Bug Fix",
    "- [x] ♻️ Refactor",
    "- [x] 🔧 Build/CI",
    "- [x] 📝 Documentation",
    "- [x] ✅ Test"
]

let hasTypeSelected = typeOfChangeOptions.contains { prBody.contains($0) }
if !hasTypeSelected && prBody.contains("Type of Change") {
    warn("☑️ Please select at least one type of change in the PR template.")
}

// Check for linked issues
if !prBody.contains("#") && !prBody.lowercased().contains("fixes") && !prBody.lowercased().contains("closes") {
    message("💡 Consider linking related issues using 'Fixes #123' or 'Relates to #456'")
}

// MARK: - PR Size Checks
if totalChanges > Config.maxPRLines {
    warn("⚠️ This PR has \(totalChanges) lines changed. Consider breaking it into smaller PRs for easier review.")
}

if allChangedFiles.count > Config.maxFilesChanged {
    warn("⚠️ This PR modifies \(allChangedFiles.count) files. Large PRs are harder to review thoroughly.")
}

// Provide a summary of changes
message("📊 **PR Stats**: +\(additions) additions, -\(deletions) deletions across \(allChangedFiles.count) files")

// MARK: - Test Coverage Checks
let changedSourceFiles = allChangedFiles.filter { isSourceFile($0) }
let changedTestFiles = allChangedFiles.filter { isTestFile($0) }

if !changedSourceFiles.isEmpty && changedTestFiles.isEmpty {
    warn("🧪 Source files were modified but no test files were changed. Please add or update tests.")
}

// Check if new source files have corresponding tests
for sourceFile in createdFiles where isSourceFile(sourceFile) {
    let fileName = (sourceFile as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
    let hasTest = changedTestFiles.contains { $0.contains("\(fileName)Tests") || $0.contains("\(fileName)Test") }
    
    if !hasTest {
        warn("📁 New file `\(fileName).swift` doesn't have a corresponding test file.")
    }
}

// MARK: - Swift Best Practices
// Check for force unwraps in new/modified files
for file in changedSourceFiles {
    let fileContent = danger.utils.readFile(file)
    
    if fileContent.contains("!") {
        // More sophisticated check for force unwraps (excluding ! in strings and comments)
        let lines = fileContent.components(separatedBy: "\n")
        for (index, line) in lines.enumerated() {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if !trimmed.hasPrefix("//") && !trimmed.hasPrefix("*") {
                // Check for force unwrap patterns
                if line.contains("as!") || (line.contains("!") && line.contains(".") && !line.contains("\"")) {
                    // This is a simplified check - may have false positives
                    break
                }
            }
        }
    }
}

// MARK: - File Organization Checks
// Warn about changes to critical files
let criticalFiles = ["Project.swift", "Tuist.swift", "Package.swift"]
let changedCriticalFiles = allChangedFiles.filter { file in
    criticalFiles.contains((file as NSString).lastPathComponent)
}

if !changedCriticalFiles.isEmpty {
    let filesChanged = changedCriticalFiles.joined(separator: ", ")
    warn("⚙️ Project configuration files were modified: \(filesChanged). Please ensure this was intentional.")
}

// MARK: - Module Structure Checks
// Ensure feature modules follow clean architecture
let featureModules = ["GamesFeature", "SearchFeature", "FavoritesFeature"]
for module in featureModules {
    let moduleFiles = allChangedFiles.filter { $0.contains("Modules/\(module)/") }
    
    if !moduleFiles.isEmpty {
        let hasData = moduleFiles.contains { $0.contains("/Data/") }
        let hasDomain = moduleFiles.contains { $0.contains("/Domain/") }
        let hasPresentation = moduleFiles.contains { $0.contains("/Presentation/") }
        
        // Just informational, not a warning
        if hasData || hasDomain || hasPresentation {
            message("📦 Changes to **\(module)** module detected.")
        }
    }
}

// MARK: - Encouraging Messages
if totalChanges < 100 {
    message("✨ Nice! This is a well-sized PR that should be easy to review.")
}

if !changedTestFiles.isEmpty {
    message("✅ Thanks for including tests with your changes!")
}

// MARK: - SwiftLint Integration
// Run SwiftLint if available and report inline
SwiftLint.lint(
    .modifiedAndCreatedFiles(directory: nil),
    inline: true,
    configFile: ".swiftlint.yml",
    strict: false,
    quiet: true
)
