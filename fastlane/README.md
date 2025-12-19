# Fastlane Configuration for RAWG.IO

This directory contains the Fastlane configuration for automating iOS development tasks including testing, code signing, screenshots, and App Store deployment.

## Prerequisites

```bash
# Install Fastlane
brew install fastlane

# Or via Ruby gems
gem install fastlane
```

## Available Lanes

### Development

| Lane | Description | Command |
|------|-------------|---------|
| `lint` | Run SwiftLint | `fastlane lint` |
| `test` | Run all unit tests | `fastlane test` |
| `ci` | Run lint + tests | `fastlane ci` |
| `clean` | Clean derived data | `fastlane clean` |

### Code Signing (Showcase)

| Lane | Description | Command |
|------|-------------|---------|
| `match_dev` | Sync development certs | `fastlane match_dev` |
| `match_prod` | Sync production certs | `fastlane match_prod` |
| `register_devices` | Register new devices | `fastlane register_devices` |

### Screenshots

| Lane | Description | Command |
|------|-------------|---------|
| `screenshots` | Capture all screenshots | `fastlane screenshots` |
| `upload_screenshots` | Upload to App Store Connect | `fastlane upload_screenshots` |

### Distribution

| Lane | Description | Command |
|------|-------------|---------|
| `beta` | Upload to TestFlight | `fastlane beta` |
| `release` | Submit to App Store | `fastlane release` |
| `bump` | Increment version | `fastlane bump type:patch` |

## Setup for Production Use

### 1. Configure App Store Connect API

Create `fastlane/AuthKey.json`:
```json
{
  "key_id": "YOUR_KEY_ID",
  "issuer_id": "YOUR_ISSUER_ID",
  "key_filepath": "./AuthKey_XXXXXX.p8"
}
```

### 2. Configure Match

1. Create a private git repository for certificates
2. Update `Matchfile` with your repository URL
3. Run `fastlane match init` to set up encryption

### 3. Environment Variables

Set these in your CI environment:
```bash
MATCH_PASSWORD=your-encryption-password
FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD=xxxx-xxxx-xxxx-xxxx
FASTLANE_SESSION=your-session-cookie  # For 2FA
```

## CI/CD Integration

Example GitHub Actions usage:
```yaml
- name: Run Fastlane Tests
  run: bundle exec fastlane test
  env:
    MATCH_PASSWORD: ${{ secrets.MATCH_PASSWORD }}
```

## File Structure

```
fastlane/
├── Appfile           # App Store Connect configuration
├── Fastfile          # Lane definitions
├── Matchfile         # Code signing configuration
├── Snapfile          # Screenshot configuration
├── README.md         # This file
├── screenshots/      # Generated screenshots
└── test_output/      # Test results
```

## Notes

> ⚠️ This is a **showcase configuration** demonstrating Fastlane capabilities.
> Actual App Store deployment requires an Apple Developer account and proper configuration of secrets.

## Resources

- [Fastlane Documentation](https://docs.fastlane.tools)
- [Match Guide](https://docs.fastlane.tools/actions/match)
- [Deliver Guide](https://docs.fastlane.tools/actions/deliver)
- [Snapshot Guide](https://docs.fastlane.tools/actions/snapshot)
