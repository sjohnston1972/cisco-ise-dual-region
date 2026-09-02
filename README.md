# ISE Dual-Region Azure Deployment with Terraform 

This Terraform configuration deploys Cisco Identity Services Engine (ISE) 3.3 in a dual-region High Availability configuration on Azure.

## Architecture

**Primary Node (UK South)**
- Region: UK South
- VNet: 10.10.0.0/16
- ISE Subnet: 10.10.1.0/24
- Static IP: 10.10.1.10
- VM: ise-pri-uks

**Secondary Node (UK West)**
- Region: UK West
- VNet: 10.20.0.0/16
- ISE Subnet: 10.20.1.0/24
- Static IP: 10.20.1.10
- VM: ise-sec-ukw

**What Gets Deployed:**
- 2x Resource Groups (one per region)
- 2x Virtual Networks (one per region)
- 2x Subnets (one per region)
- 2x Network Security Groups (management restricted to `var.allowed_mgmt_cidrs`)
- 2x Route Tables
- 2x Public IPs (for management access)
- 2x Network Interfaces
- 2x ISE VMs (Standard_D8s_v4 - 8 vCPU, 32GB RAM)

## Prerequisites

✅ Windows machine with PowerShell
✅ Terraform installed (you have v1.14.5)
✅ Azure CLI installed and authenticated
✅ Azure subscription with Contributor access
✅ ISE marketplace image terms accepted

## Deployment Steps

### Step 1: Generate SSH Key Pair

Run the PowerShell script to generate your SSH keys:

```powershell
cd C:\terraform\ise
.\generate-ssh-key.ps1
```

This creates:
- `ise-key` (private key - keep this secure!)
- `ise-key.pub` (public key - you'll paste this into terraform.tfvars)

### Step 2: Update terraform.tfvars

Open `terraform.tfvars` in a text editor (Notepad, VS Code, etc.)

Find this line:
```
ssh_public_key = "PASTE_YOUR_SSH_PUBLIC_KEY_HERE"
```

Replace `PASTE_YOUR_SSH_PUBLIC_KEY_HERE` with the SSH public key from Step 1.

The public key looks like:
```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC... ise-azure-deployment
```

**Save the file.**

### Step 3: Initialize Terraform

In PowerShell:

```powershell
cd C:\terraform\ise
terraform init
```

This downloads the Azure provider and sets up Terraform.

### Step 4: Review the Deployment Plan

See what Terraform will create:

```powershell
terraform plan
```

This shows you all the resources that will be created. Review it to make sure everything looks correct.

### Step 5: Deploy!

Run the deployment:

```powershell
terraform apply
```

Type `yes` when prompted.

**Deployment time:** ~10-15 minutes

### Step 6: Wait for ISE to Boot

After Terraform completes, the VMs are created but ISE takes additional time to boot:

**Wait 15-20 minutes** before accessing ISE.

### Step 7: Configure VNet Peering

Terraform outputs will show you the VNet IDs. You need to create peering between UK South and UK West VNets.

**Option A: Azure Portal**
1. Go to Azure Portal → Virtual Networks
2. Select `vnet-ise-uks`
3. Click "Peerings" → "Add"
4. Name: `uks-to-ukw`
5. Remote VNet: Select `vnet-ise-ukw`
6. Allow traffic: Yes
7. Create the peering

**Repeat for the reverse direction** (ukw-to-uks)

**Option B: Azure CLI**

```powershell
# Get VNet IDs from Terraform outputs
$uksVnetId = terraform output -raw uks_vnet_id
$ukwVnetId = terraform output -raw ukw_vnet_id

# Create peering from UK South to UK West
az network vnet peering create `
  --name uks-to-ukw `
  --resource-group rg-ise-pri-uks `
  --vnet-name vnet-ise-uks `
  --remote-vnet $ukwVnetId `
  --allow-vnet-access

# Create peering from UK West to UK South
az network vnet peering create `
  --name ukw-to-uks `
  --resource-group rg-ise-sec-ukw `
  --vnet-name vnet-ise-ukw `
  --remote-vnet $uksVnetId `
  --allow-vnet-access
```

### Step 8: Access ISE Setup Wizard

Get the public IPs from Terraform outputs:

```powershell
terraform output
```

Access ISE in your browser:
- **Primary:** `https://<uks_ise_public_ip>`
- **Secondary:** `https://<ukw_ise_public_ip>`

**Initial credentials:**
- Username: `iseadmin`
- Password: whatever value you supplied for `var.ise_admin_password` at apply time

> **Security note:** An earlier version of this README and `main.tf`
> hardcoded and documented a literal example admin password in this
> **public** repository. That exact value must be treated as permanently
> compromised - **never reuse it for anything.** It has been removed from
> the current source, but it still exists in this repo's git history (which
> cannot be altered here). If any real ISE node was ever deployed with that
> password, rotate its admin credentials immediately.

### Step 9: Configure ISE

1. **Configure Primary Node First:**
   - Access the Primary ISE (UK South)
   - Complete the setup wizard:
     - Hostname: `ise-pri-uks`
     - DNS Domain: `test.com`
     - Primary DNS: `8.8.8.8`
     - NTP Server: `time.windows.com`
     - Timezone: `Etc/UTC`
     - Set admin password (value of `var.ise_admin_password`, i.e. whatever you supplied via `terraform.tfvars` / `TF_VAR_ise_admin_password` / your secret store)
     - ERS API: No
     - pxGrid: No
     - pxGrid Cloud: No

2. **Configure Secondary Node:**
   - Access the Secondary ISE (UK West)
   - Complete the setup wizard with similar settings
   - Hostname: `ise-sec-ukw`

3. **Register Secondary to Primary:**
   - From Primary ISE GUI: Administration → System → Deployment
   - Register the Secondary node using its private IP: `10.20.1.10`

## File Structure

```
ise-terraform/
├── main.tf              # Main infrastructure code
├── variables.tf         # Variable definitions
├── terraform.tfvars     # YOUR specific values (contains SSH key)
├── outputs.tf           # Output information after deployment
├── generate-ssh-key.ps1 # SSH key generation script
├── README.md           # This file
└── .gitignore          # Prevents committing secrets
```

## Important Files

**DO NOT COMMIT TO GIT:**
- `ise-key` (private SSH key)
- `terraform.tfvars` (contains your SSH public key)
- `*.tfstate` (Terraform state files)

The `.gitignore` file is configured to prevent accidental commits of these files.

## Troubleshooting

### Issue: Terraform can't find SSH key
**Solution:** Make sure you ran `generate-ssh-key.ps1` and updated `terraform.tfvars` with the public key.

### Issue: Marketplace image terms not accepted
**Solution:** Run:
```powershell
az vm image terms accept --publisher cisco --offer cisco-ise-virtual --plan cisco-ise_3_3
```

### Issue: ISE GUI not loading
**Solution:** ISE takes 15-20 minutes to fully boot. Wait longer, then check VM status in Azure Portal.

### Issue: Can't SSH to VMs
**Solution:** 
- Check NSG allows SSH (port 22)
- Verify you're using the correct private key: `ssh -i ise-key iseadmin@<public_ip>`

### Issue: Nodes can't communicate
**Solution:** 
- Verify VNet peering is configured in both directions
- Check NSGs allow traffic between VNets

## Useful Terraform Commands

```powershell
# View outputs again
terraform output

# Show current state
terraform show

# Destroy everything (CAREFUL!)
terraform destroy

# Re-format Terraform files
terraform fmt

# Validate configuration
terraform validate

# See what changed
terraform plan
```

## Cost Considerations

**Approximate monthly costs:**
- 2x Standard_D8s_v4 VMs: ~£400-500/month
- 2x Public IPs: ~£4/month
- 2x Premium SSD (600GB each): ~£180/month
- VNet peering data transfer: Variable

**Total: ~£600-700/month**

## Next Steps After Deployment

1. ✅ Configure VNet peering
2. ✅ Access ISE setup wizard
3. ✅ Configure Primary node
4. ✅ Configure Secondary node
5. ✅ Register Secondary to Primary
6. Configure ISE policies and network devices
7. Test ISE HA failover
8. Review `allowed_mgmt_cidrs` and narrow it further if your admin source networks change
9. Configure UDRs if needed for routing

## Learning Resources

**Terraform:**
- [Terraform Azure Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Language](https://developer.hashicorp.com/terraform/language)

**ISE:**
- [ISE Installation Guide](https://www.cisco.com/c/en/us/support/security/identity-services-engine/products-installation-guides-list.html)
- [ISE Admin Guide](https://www.cisco.com/c/en/us/support/security/identity-services-engine/products-maintenance-guides-list.html)

## Questions or Issues?

If you run into problems, check:
1. Azure Portal for VM/network status
2. Terraform error messages
3. ISE logs (after it boots)

---

**Created by:** Steven
**Date:** February 2026
**Terraform Version:** 1.14.5
**ISE Version:** 3.3
