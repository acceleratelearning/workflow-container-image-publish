#!/usr/bin/env pwsh


[string[]]$markdown = Get-Content ./doc-parts/header.md

$workflow_definition = Get-Content ./.github/workflows/shared-workflow.yaml | ConvertFrom-Yaml
$inputs = $workflow_definition["on"]["workflow_call"]["inputs"]
$secrets = $workflow_definition["on"]["workflow_call"]["secrets"]

$markdown += "## Inputs"
$markdown += ""
$markdown += "| Name | Type | Required | Description |"
$markdown += "| ---- | ---- | -------- | ----------- |"

$markdown += $inputs.Keys | Sort-Object | ForEach-Object {
    [pscustomObject]@{
        Name        = $_
        Type        = $inputs[$_].type
        Required    = if ($inputs[$_].required) { ":heavy_check_mark:" } else { "" }
        Description = $inputs[$_].description
    }
} | ForEach-Object {
    "| $($_.Name) | $($_.Type) | $($_.Required) | $($_.Description) |"
}

if ($secrets) {
    $markdown += "## Secrets"
    $markdown += ""
    $markdown += "| Name | Required | Description |"
    $markdown += "| ---- | -------- | ----------- |"

    $markdown += $secrets.Keys | Sort-Object | ForEach-Object {
        [pscustomObject]@{
            Name        = $_
            Required    = if ($secrets[$_].required) { ":heavy_check_mark:" } else { "" }
            Description = $secrets[$_].description
        }
    } | ForEach-Object {
        "| $($_.Name) | $($_.Required) | $($_.Description) |"
    }
}

$markdown += Get-Content ./doc-parts/content.md

$markdown | Set-Content -Path "README.md"