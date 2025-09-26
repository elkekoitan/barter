param(
    [Parameter(Mandatory=$true)]
    [string]$Repo
)

$issueFiles = Get-ChildItem -Path "docs/issues" -Filter "*.md" | Sort-Object Name
if (-not $issueFiles) {
    Write-Error "docs/issues klasöründe issue dosyası bulunamadı."
    exit 1
}

foreach ($file in $issueFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    if ($content -match "^# (.*)$") {
        $title = $matches[1].Trim()
    } else {
        Write-Warning "${file.Name} dosyasında başlık bulunamadı, atlanıyor."
        continue
    }

    Write-Host "Creating issue: $title" -ForegroundColor Cyan
    gh issue create --repo $Repo --title $title --body-file $file.FullName
}
