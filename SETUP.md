# Setup Guide 

## 1. Create GitHub Repository

```bash
# Create new repo on GitHub with name: win-network-config
# Description: Advanced Windows Network Configuration Tool
# Public repository
# Initialize with README: NO (we'll add our own)
```

## 2. Clone and Setup Local Repository

```bash
git clone https://github.com/hugle2012/win-network-config.git
cd win-network-config
```

## 3. Add Files

Create these files in the repository root:

**install.ps1** - Main script file (copy from artifact)
**README.md** - Documentation (copy from artifact)  
**USER-GUIDE.md** - Detailed user guide (copy from artifact)

## 4. Initialize and Push

```bash
# Add all files
git add .

# Commit
git commit -m "Initial release: Advanced Windows Network Configuration Tool"

# Push to GitHub
git push origin main
```

## 5. Test Installation

After pushing, test the one-liner:

```powershell
irm https://raw.githubusercontent.com/hugle2012/win-network-config/main/install.ps1 | iex
```

## Repository Structure

```
win-network-config/
├── README.md          # Main documentation
├── USER-GUIDE.md      # Detailed user guide  
├── install.ps1        # Main script
└── SETUP.md          # This setup guide
```

## Important Notes

- Repository must be **PUBLIC** for raw.githubusercontent.com access
- File name must be exactly **install.ps1** 
- Test the URL after push to ensure it works
- Admin privileges required for execution

## Usage After Setup

Users can run:
```powershell
irm https://raw.githubusercontent.com/hugle2012/win-network-config/main/install.ps1 | iex
```

The tool will launch with full GUI menu for network configuration.