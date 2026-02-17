# SSH Key Generation Script for ISE Deployment
# Run this script to generate an SSH key pair

Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║           ISE SSH Key Generator                                ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$keyPath = "ise-key"
$pubKeyPath = "ise-key.pub"

# Check if key already exists
if (Test-Path $keyPath) {
    Write-Host "⚠️  SSH key already exists!" -ForegroundColor Yellow
    Write-Host ""
    $overwrite = Read-Host "Do you want to overwrite it? (yes/no)"
    if ($overwrite -ne "yes") {
        Write-Host "Cancelled. Using existing key." -ForegroundColor Yellow
        exit
    }
}

Write-Host "🔑 Generating SSH key pair..." -ForegroundColor Green

# Generate SSH key using ssh-keygen
ssh-keygen -t rsa -b 4096 -f $keyPath -N '""' -C "ise-azure-deployment"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ SSH key pair generated successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📁 Files created:" -ForegroundColor Cyan
    Write-Host "   Private key: $keyPath" -ForegroundColor White
    Write-Host "   Public key:  $pubKeyPath" -ForegroundColor White
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
    Write-Host "║                    IMPORTANT - READ THIS                       ║" -ForegroundColor Yellow
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "📋 Your SSH PUBLIC KEY:" -ForegroundColor Cyan
    Write-Host ""
    
    # Read and display the public key
    $publicKey = Get-Content $pubKeyPath -Raw
    Write-Host $publicKey -ForegroundColor White
    
    Write-Host ""
    Write-Host "📝 NEXT STEP:" -ForegroundColor Yellow
    Write-Host "   1. Copy the SSH public key shown above" -ForegroundColor White
    Write-Host "   2. Open terraform.tfvars in a text editor" -ForegroundColor White
    Write-Host "   3. Replace 'PASTE_YOUR_SSH_PUBLIC_KEY_HERE' with your public key" -ForegroundColor White
    Write-Host "   4. Save the file" -ForegroundColor White
    Write-Host ""
    Write-Host "⚠️  SECURITY NOTE:" -ForegroundColor Red
    Write-Host "   - Keep the private key ($keyPath) SECURE" -ForegroundColor White
    Write-Host "   - DO NOT share or commit it to Git" -ForegroundColor White
    Write-Host "   - The .gitignore file will prevent accidental commits" -ForegroundColor White
    Write-Host ""
    
} else {
    Write-Host "❌ Failed to generate SSH key" -ForegroundColor Red
    Write-Host "Make sure OpenSSH is installed on your system" -ForegroundColor Yellow
}
