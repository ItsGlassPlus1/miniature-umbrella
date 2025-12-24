#Requires -Version 5.1

BeforeAll {
    . "$PSScriptRoot/Scoop-Bucket.Tests.ps1"
}

Describe 'Manifest Array Validation' {
    BeforeAll {
        $bucketDir = "$PSScriptRoot/bucket"
        $manifests = Get-ChildItem $bucketDir -Filter '*.json' -File | Where-Object { $_.Name -notmatch '\.template$' }
    }

    Context 'URL and Hash Array Support' {
        It 'Manifests with multiple URLs should use array format' {
            foreach ($manifest in $manifests) {
                $json = Get-Content $manifest.FullName -Raw | ConvertFrom-Json
                
                # Check architecture-specific URLs and hashes
                if ($json.architecture) {
                    foreach ($arch in $json.architecture.PSObject.Properties) {
                        $archData = $arch.Value
                        
                        # If URL exists and is an array, validate it
                        if ($archData.url) {
                            if ($archData.url -is [Array]) {
                                $archData.url.Count | Should -BeGreaterThan 0
                                # Each URL should be a string
                                foreach ($url in $archData.url) {
                                    $url | Should -BeOfType [String]
                                }
                                
                                # If there are multiple URLs, there should be corresponding hashes
                                if ($archData.url.Count -gt 1 -and $archData.hash) {
                                    $archData.hash | Should -BeOfType [Array]
                                    $archData.hash.Count | Should -Be $archData.url.Count
                                }
                            }
                        }
                        
                        # If hash exists and is an array, validate it
                        if ($archData.hash -is [Array]) {
                            $archData.hash.Count | Should -BeGreaterThan 0
                            # Each hash should be a string
                            foreach ($hash in $archData.hash) {
                                $hash | Should -BeOfType [String]
                                $hash | Should -Match '^[a-fA-F0-9]{64}$|^[a-fA-F0-9]{128}$|^md5:[a-fA-F0-9]{32}$|^sha1:[a-fA-F0-9]{40}$|^sha256:[a-fA-F0-9]{64}$|^sha512:[a-fA-F0-9]{128}$'
                            }
                        }
                    }
                }
                
                # Check top-level URLs and hashes (non-architecture-specific)
                if ($json.url) {
                    if ($json.url -is [Array]) {
                        $json.url.Count | Should -BeGreaterThan 0
                        foreach ($url in $json.url) {
                            $url | Should -BeOfType [String]
                        }
                        
                        if ($json.url.Count -gt 1 -and $json.hash) {
                            $json.hash | Should -BeOfType [Array]
                            $json.hash.Count | Should -Be $json.url.Count
                        }
                    }
                }
                
                if ($json.hash -is [Array]) {
                    $json.hash.Count | Should -BeGreaterThan 0
                    foreach ($hash in $json.hash) {
                        $hash | Should -BeOfType [String]
                        $hash | Should -Match '^[a-fA-F0-9]{64}$|^[a-fA-F0-9]{128}$|^md5:[a-fA-F0-9]{32}$|^sha1:[a-fA-F0-9]{40}$|^sha256:[a-fA-F0-9]{64}$|^sha512:[a-fA-F0-9]{128}$'
                    }
                }
            }
        }

        It 'Multiple URLs and hashes should have matching counts' {
            foreach ($manifest in $manifests) {
                $json = Get-Content $manifest.FullName -Raw | ConvertFrom-Json
                
                # Check architecture-specific
                if ($json.architecture) {
                    foreach ($arch in $json.architecture.PSObject.Properties) {
                        $archData = $arch.Value
                        
                        if ($archData.url -is [Array] -and $archData.url.Count -gt 1) {
                            if ($archData.hash) {
                                $archData.hash | Should -BeOfType [Array]
                                $archData.hash.Count | Should -Be $archData.url.Count -Because "Each URL should have a corresponding hash in $($manifest.Name) [$($arch.Name)]"
                            }
                        }
                    }
                }
                
                # Check top-level
                if ($json.url -is [Array] -and $json.url.Count -gt 1) {
                    if ($json.hash) {
                        $json.hash | Should -BeOfType [Array]
                        $json.hash.Count | Should -Be $json.url.Count -Because "Each URL should have a corresponding hash in $($manifest.Name)"
                    }
                }
            }
        }
    }
}
