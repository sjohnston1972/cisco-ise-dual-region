# ISE Deployment Checklist
# Run this to verify you're ready to deploy

Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║           ISE Deployment Pre-Flight Checklist                  ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$allGood = $true

# Check 1: Terraform installed
Write-Host "🔍 Checking Terraform installation..." -NoNewline
try {
    $tfVersion = terraform version
    Write-Host " ✅" -ForegroundColor Green
    Write-Host "   Version: $($tfVersion[0])" -ForegroundColor Gray
} catch {
    Write-Host " ❌" -ForegroundColor Red
    Write-Host "   Terraform not found. Install with: choco install terraform" -ForegroundColor Yellow
    $allGood = $false
}

# Check 2: Azure CLI installed
Write-Host "🔍 Checking Azure CLI installation..." -NoNewline
try {
    $azVersion = az version --query '\"azure-cli\"' -o tsv
    Write-Host " ✅" -ForegroundColor Green
    Write-Host "   Version: $azVersion" -ForegroundColor Gray
} catch {
    Write-Host " ❌" -ForegroundColor Red
    Write-Host "   Azure CLI not found. Install with: choco install azure-cli" -ForegroundColor Yellow
    $allGood = $false
}

# Check 3: Azure authentication
Write-Host "🔍 Checking Azure authentication..." -NoNewline
try {
    $account = az account show --query name -o tsv 2>$null
    if ($account) {
        Write-Host " ✅" -ForegroundColor Green
        Write-Host "   Logged in as: $account" -ForegroundColor Gray
    } else {
        Write-Host " ❌" -ForegroundColor Red
        Write-Host "   Not logged in. Run: az login" -ForegroundColor Yellow
        $allGood = $false
    }
} catch {
    Write-Host " ❌" -ForegroundColor Red
    Write-Host "   Not logged in. Run: az login" -ForegroundColor Yellow
    $allGood = $false
}

# Check 4: SSH key exists
Write-Host "🔍 Checking SSH key..." -NoNewline
if (Test-Path "ise-key.pub") {
    Write-Host " ✅" -ForegroundColor Green
    $keyContent = Get-Content "ise-key.pub" -Raw
    Write-Host "   Key generated: $($keyContent.Substring(0,50))..." -ForegroundColor Gray
} else {
    Write-Host " ❌" -ForegroundColor Red
    Write-Host "   SSH key not found. Run: .\generate-ssh-key.ps1" -ForegroundColor Yellow
    $allGood = $false
}

# Check 5: terraform.tfvars configured
Write-Host "🔍 Checking terraform.tfvars..." -NoNewline
if (Test-Path "terraform.tfvars") {
    $tfvars = Get-Content "terraform.tfvars" -Raw
    if ($tfvars -match "PASTE_YOUR_SSH_PUBLIC_KEY_HERE") {
        Write-Host " ⚠️ " -ForegroundColor Yellow
        Write-Host "   File exists but SSH key not configured!" -ForegroundColor Yellow
        Write-Host "   Edit terraform.tfvars and paste your SSH public key" -ForegroundColor Yellow
        $allGood = $false
    } else {
        Write-Host " ✅" -ForegroundColor Green
        Write-Host "   Configured with SSH key" -ForegroundColor Gray
    }
} else {
    Write-Host " ❌" -ForegroundColor Red
    Write-Host "   terraform.tfvars not found" -ForegroundColor Yellow
    $allGood = $false
}

# Check 6: ISE marketplace terms
Write-Host "🔍 Checking ISE marketplace terms..." -NoNewline
try {
    $terms = az vm image terms show --publisher cisco --offer cisco-ise-virtual --plan cisco-ise_3_3 --query accepted -o tsv 2>$null
    if ($terms -eq "true") {
        Write-Host " ✅" -ForegroundColor Green
        Write-Host "   Terms accepted" -ForegroundColor Gray
    } else {
        Write-Host " ⚠️ " -ForegroundColor Yellow
        Write-Host "   Terms not accepted. Run:" -ForegroundColor Yellow
        Write-Host "   az vm image terms accept --publisher cisco --offer cisco-ise-virtual --plan cisco-ise_3_3" -ForegroundColor White
        $allGood = $false
    }
} catch {
    Write-Host " ⚠️ " -ForegroundColor Yellow
    Write-Host "   Could not verify. You may need to accept terms." -ForegroundColor Yellow
}

# Check 7: Required files exist
Write-Host "🔍 Checking Terraform files..." -NoNewline
$requiredFiles = @("main.tf", "variables.tf", "outputs.tf")
$missingFiles = @()
foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        $missingFiles += $file
    }
}
if ($missingFiles.Count -eq 0) {
    Write-Host " ✅" -ForegroundColor Green
    Write-Host "   All required files present" -ForegroundColor Gray
} else {
    Write-Host " ❌" -ForegroundColor Red
    Write-Host "   Missing files: $($missingFiles -join ', ')" -ForegroundColor Yellow
    $allGood = $false
}

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan

if ($allGood) {
    Write-Host "║                  ✅ READY TO DEPLOY! ✅                        ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. terraform init" -ForegroundColor White
    Write-Host "  2. terraform plan" -ForegroundColor White
    Write-Host "  3. terraform apply" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "║              ⚠️  NOT READY - FIX ISSUES ABOVE  ⚠️              ║" -ForegroundColor Red
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Fix the issues above, then run this script again." -ForegroundColor Yellow
    Write-Host ""
}
