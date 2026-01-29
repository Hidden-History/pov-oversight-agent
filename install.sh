#!/bin/bash
# Parzival Module Installer for Mac/Linux
# Version: 1.1.0

set -e

echo "========================================"
echo "  PARZIVAL MODULE INSTALLER v1.1.0"
echo "  For BMAD Method"
echo "========================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Get project directory from argument or prompt
if [ -n "$1" ]; then
    PROJECT_DIR="$1"
else
    echo "Where is your BMAD project located?"
    echo "(This is the folder containing the _bmad directory)"
    echo ""
    read -p "Enter full path [or press Enter for current directory]: " PROJECT_DIR

    if [ -z "$PROJECT_DIR" ]; then
        PROJECT_DIR="$(pwd)"
    fi
fi

# Expand ~ to home directory
PROJECT_DIR="${PROJECT_DIR/#\~/$HOME}"

# Validate path doesn't contain traversal
if [[ "$PROJECT_DIR" == *".."* ]]; then
    echo -e "${RED}ERROR: Path cannot contain '..' for security${NC}"
    exit 1
fi

# Verify project directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}ERROR: Directory does not exist: $PROJECT_DIR${NC}"
    exit 1
fi

# Verify BMAD is installed (optional - Parzival can work standalone)
if [ ! -d "$PROJECT_DIR/_bmad" ]; then
    echo -e "${YELLOW}WARNING: BMAD not found in $PROJECT_DIR${NC}"
    echo "Parzival can work standalone or with BMAD Method"
    read -p "Continue installation anyway? (y/n): " CONTINUE
    if [ "$CONTINUE" != "y" ] && [ "$CONTINUE" != "Y" ]; then
        echo "Installation cancelled."
        exit 0
    fi
fi

echo ""
echo -e "${GREEN}Found BMAD installation at: $PROJECT_DIR${NC}"
echo ""

# Confirm installation (skip if argument provided)
if [ -z "$1" ]; then
    read -p "Install Parzival module to this location? (y/n): " CONFIRM
    if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
        echo "Installation cancelled."
        exit 0
    fi
else
    echo "Installing Parzival module to: $PROJECT_DIR"
fi

echo ""
echo "Installing Parzival module..."
echo ""

# Step 1: Copy POV module
echo "[1/5] Copying POV module files..."
mkdir -p "$PROJECT_DIR/pov"
# Preserve user's config.yaml if it exists
if [ -f "$PROJECT_DIR/pov/config.yaml" ]; then
    CONFIG_BACKUP=$(cat "$PROJECT_DIR/pov/config.yaml")
    cp -r "$SCRIPT_DIR/pov/"* "$PROJECT_DIR/pov/"
    echo "$CONFIG_BACKUP" > "$PROJECT_DIR/pov/config.yaml"
    echo -e "${GREEN}  Done (preserved existing config.yaml)${NC}"
else
    cp -r "$SCRIPT_DIR/pov/"* "$PROJECT_DIR/pov/"
    echo -e "${GREEN}  Done${NC}"
fi

# Step 2: Copy slash commands
echo "[2/5] Copying slash commands..."
mkdir -p "$PROJECT_DIR/.claude/commands/pov/commands"
mkdir -p "$PROJECT_DIR/.claude/commands/pov/agents"
cp -rn "$SCRIPT_DIR/.claude/commands/pov/commands/"* "$PROJECT_DIR/.claude/commands/pov/commands/"
cp -rn "$SCRIPT_DIR/.claude/commands/pov/agents/"* "$PROJECT_DIR/.claude/commands/pov/agents/"
echo -e "${GREEN}  Done${NC}"

# Step 3: Update manifest.yaml
echo "[3/5] Updating BMAD manifest..."
MANIFEST_FILE="$PROJECT_DIR/_bmad/_config/manifest.yaml"
if [ -f "$MANIFEST_FILE" ]; then
    # Add pov to manifest if not already present
    if ! grep -q "^  - pov$" "$MANIFEST_FILE" 2>/dev/null; then
        # Check if modules: section exists
        if grep -q "^modules:" "$MANIFEST_FILE" 2>/dev/null; then
            # Use awk for reliable cross-platform YAML insertion
            awk '/^modules:/{found=1; print; next} found && /^[^ ]/{print "  - pov"; found=0} {print} END{if(found) print "  - pov"}' "$MANIFEST_FILE" > "${MANIFEST_FILE}.tmp" && mv "${MANIFEST_FILE}.tmp" "$MANIFEST_FILE"
        else
            # No modules section - append it
            echo -e "\nmodules:\n  - pov" >> "$MANIFEST_FILE"
        fi
        echo -e "${GREEN}  Added 'pov' to manifest${NC}"
    else
        echo -e "${YELLOW}  'pov' already in manifest${NC}"
    fi
else
    echo -e "${RED}  WARNING: manifest.yaml not found${NC}"
fi

# Step 4: Update agent-manifest.csv
echo "[4/5] Updating agent manifest..."
AGENT_MANIFEST="$PROJECT_DIR/_bmad/_config/agent-manifest.csv"
if [ -f "$AGENT_MANIFEST" ]; then
    if ! grep -q "parzival" "$AGENT_MANIFEST"; then
        echo '"parzival","Parzival","Technical PM & Quality Gatekeeper","🎯","Technical Project Manager + Quality Gatekeeper","Parzival is the radar, map reader, and navigator. Deep project understanding enables good recommendations - not task execution. Maintains oversight documentation, tracks risks and blockers, provides well-crafted prompts for agents, and validates completed work through explicit checklists.","Advisory and supportive. Uses confidence levels (Verified/Informed/Inferred/Uncertain/Unknown) with every recommendation. Asks clarifying questions rather than assuming. Surfaces risks and scope changes proactively.","- Parzival recommends. The user decides. - Ask when uncertain, never fabricate. - Surface scope changes when detected. - Write for Future Parzival who knows nothing about this session. - Verification is concrete, not vibes-based.","pov","pov/agents/parzival.md"' >> "$AGENT_MANIFEST"
        echo -e "${GREEN}  Added parzival to agent manifest${NC}"
    else
        echo -e "${YELLOW}  parzival already in agent manifest${NC}"
    fi
else
    echo -e "${RED}  WARNING: agent-manifest.csv not found${NC}"
fi

# Step 5: Copy customization template
echo "[5/5] Copying customization template..."
mkdir -p "$PROJECT_DIR/_bmad/_config/agents"
if [ -f "$PROJECT_DIR/_bmad/_config/agents/pov-parzival.customize.yaml" ]; then
    echo -e "${YELLOW}  Skipped (file already exists)${NC}"
else
    cp "$SCRIPT_DIR/pov-parzival.customize.yaml" "$PROJECT_DIR/_bmad/_config/agents/"
    echo -e "${GREEN}  Done${NC}"
fi

echo ""
echo "========================================"
echo -e "${GREEN}  INSTALLATION COMPLETE!${NC}"
echo "========================================"
echo ""
echo "Next steps:"
echo ""
echo "1. Initialize oversight folder (NEW PROJECTS ONLY):"
echo "   ./scripts/init-oversight.sh $PROJECT_DIR"
echo ""
echo "2. Update templates (EXISTING PROJECTS):"
echo "   ./scripts/update-templates.sh $PROJECT_DIR"
echo ""
echo "3. Configure Parzival (optional):"
echo "   Edit: $PROJECT_DIR/pov/config.yaml"
echo ""
echo "4. Start using Parzival:"
echo "   cd $PROJECT_DIR"
echo "   claude"
echo "   /pov:commands:parzival-start"
echo ""
echo "For help, see INSTALL-GUIDE.md"
echo ""
echo "Installation finished. Happy coding!"
