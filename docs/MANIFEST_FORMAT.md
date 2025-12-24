# Manifest Format Guide

This guide documents the manifest format conventions used in this Scoop bucket, particularly for advanced features like multiple URLs and hashes.

## Multiple URLs and Hashes

Scoop manifests support downloading multiple files for a single package installation. This is useful when you need:
- A main application archive
- Additional scripts or configuration files
- Helper utilities

### Syntax

When specifying multiple URLs and hashes, use JSON array syntax:

```json
{
    "architecture": {
        "64bit": {
            "url": [
                "https://example.com/app-v1.0.0.zip",
                "https://example.com/helper-script.ps1"
            ],
            "hash": [
                "abc123...",
                "def456..."
            ]
        }
    }
}
```

### Requirements

1. **Array Format**: Both `url` and `hash` must be arrays (use `[]`, not `{}`)
2. **Count Matching**: The number of URLs must match the number of hashes
3. **Hash Format**: Hashes can be:
   - Plain SHA-256 (64 hex characters) - default
   - Plain SHA-512 (128 hex characters)
   - Prefixed format: `md5:...`, `sha1:...`, `sha256:...`, `sha512:...`
4. **Autoupdate Consistency**: When using autoupdate, ensure all URLs are included in the autoupdate section

### Example: suwayomi-server-preview.json

```json
{
    "version": "2.1.2038",
    "architecture": {
        "64bit": {
            "url": [
                "https://github.com/Suwayomi/Suwayomi-Server-preview/releases/download/v$version/Suwayomi-Server-v$version-windows-x64.zip",
                "https://github.com/ScoopInstaller/Extras/raw/master/scripts/suwayomi-server/suwayomi.ps1"
            ],
            "hash": [
                "ff86f6fe69a61281a7946a855b0fe195fd6c587836a875a3f9daddc4105d4cc3",
                "f7d32050ace8bcb05005a65da1dae174e3eeca86a370e769639f5c0d03e61629"
            ]
        }
    },
    "autoupdate": {
        "architecture": {
            "64bit": {
                "url": [
                    "https://github.com/Suwayomi/Suwayomi-Server-preview/releases/download/v$version/Suwayomi-Server-v$version-windows-x64.zip",
                    "https://github.com/ScoopInstaller/Extras/raw/master/scripts/suwayomi-server/suwayomi.ps1"
                ]
            }
        }
    }
}
```

In this example:
- The first URL downloads the main application archive
- The second URL downloads a PowerShell script used to run the application
- Each URL has a corresponding hash for integrity verification
- The autoupdate section maintains the same array structure

## Testing

The bucket includes `Manifest-Array-Validation.Tests.ps1` which validates:
- Array format correctness
- Type checking (arrays contain strings)
- Hash format validation
- Count matching between URLs and hashes
- Both architecture-specific and top-level arrays

Run tests with:
```powershell
.\bin\test.ps1
```

## References

- [Scoop App Manifests Wiki](https://github.com/ScoopInstaller/Scoop/wiki/App-Manifests)
- [Scoop Contributing Guide](https://github.com/ScoopInstaller/.github/blob/main/.github/CONTRIBUTING.md)
