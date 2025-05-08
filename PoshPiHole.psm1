# Load private functions (not exported)
Get-ChildItem -Path "$PSScriptRoot/Private/*.ps1" | ForEach-Object {
    . $_.FullName
}

# Load and export public functions
Get-ChildItem -Path "$PSScriptRoot/Public/*.ps1" | ForEach-Object {
    . $_.FullName
    Export-ModuleMember -Function $_.BaseName
}