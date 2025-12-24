# Manifest Format Guide

This guide documents the manifest format conventions used in this Scoop bucket.

## Downloading Multiple Files

When your application requires multiple files (e.g., an archive plus additional scripts), use the appropriate Scoop manifest fields:

### Using pre_install for Additional Files

When you need to download a helper script or additional file alongside your main archive:

```json
{
    "architecture": {
        "64bit": {
            "url": "https://example.com/app-v1.0.0.zip",
            "hash": "abc123..."
        }
    },
    "pre_install": [
        "Invoke-WebRequest -Uri 'https://example.com/helper-script.ps1' -OutFile \"$dir\\helper-script.ps1\""
    ]
}
```

### Mirror URLs (Redundancy)

If you have multiple URLs pointing to the **same file** (mirrors for redundancy), use an array:

```json
{
    "architecture": {
        "64bit": {
            "url": [
                "https://mirror1.example.com/app-v1.0.0.zip",
                "https://mirror2.example.com/app-v1.0.0.zip"
            ],
            "hash": "abc123..."
        }
    }
}
```

**Note**: All URLs in the array must point to the same file and share the same hash.

### Example: suwayomi-server-preview.json

```json
{
    "version": "2.1.2038",
    "architecture": {
        "64bit": {
            "url": "https://github.com/Suwayomi/Suwayomi-Server-preview/releases/download/v$version/Suwayomi-Server-v$version-windows-x64.zip",
            "hash": "ff86f6fe69a61281a7946a855b0fe195fd6c587836a875a3f9daddc4105d4cc3"
        }
    },
    "pre_install": [
        "Invoke-WebRequest -Uri 'https://github.com/ScoopInstaller/Extras/raw/master/scripts/suwayomi-server/suwayomi.ps1' -OutFile \"$dir\\suwayomi.ps1\""
    ]
}
```

In this example:
- The main application archive is downloaded via the standard `url` field
- The PowerShell wrapper script is downloaded during `pre_install`
- Hash verification is applied to the main archive

## Hash Format

Hashes can be specified in several formats:
- Plain SHA-256 (64 hex characters) - default and recommended
- Plain SHA-512 (128 hex characters)
- Prefixed format: `md5:...`, `sha1:...`, `sha256:...`, `sha512:...`

## Testing

The standard Scoop bucket tests will validate your manifests. Run tests with:
```powershell
.\bin\test.ps1
```

## References

- [Scoop App Manifests Wiki](https://github.com/ScoopInstaller/Scoop/wiki/App-Manifests)
- [Scoop Contributing Guide](https://github.com/ScoopInstaller/.github/blob/main/.github/CONTRIBUTING.md)
