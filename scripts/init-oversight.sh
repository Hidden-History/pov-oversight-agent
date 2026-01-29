#!/bin/bash
# Parzival Oversight Folder Initializer
# Version: 1.2.0
# For NEW projects only - initializes oversight folder from templates

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================"
echo "  PARZIVAL OVERSIGHT INITIALIZER v1.2.0"
echo "  For NEW projects only"
echo "========================================"
echo ""

# Get project directory from argument or ask
if [ -n "$1" ]; then
    PROJECT_DIR="$1"
else
    echo "Where is your BMAD project located?"
    read -p "Enter full path: " PROJECT_DIR
fi

# Expand ~ to home directory
PROJECT_DIR="${PROJECT_DIR/#\~/$HOME}"

# Validate path
if [[ "$PROJECT_DIR" == *".."* ]]; then
    echo -e "${RED}ERROR: Path cannot contain '..' for security${NC}"
    exit 1
fi

if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}ERROR: Directory does not exist: $PROJECT_DIR${NC}"
    exit 1
fi

# Verify BMAD is installed
if [ ! -d "$PROJECT_DIR/_bmad" ]; then
    echo -e "${RED}ERROR: BMAD not found in $PROJECT_DIR${NC}"
    echo "Please install BMAD first"
    exit 1
fi

# Verify Parzival module is installed
if [ ! -d "$PROJECT_DIR/pov" ]; then
    echo -e "${RED}ERROR: Parzival module not found${NC}"
    echo "Please run install.sh first"
    exit 1
fi

# Check if oversight folder already exists
if [ -d "$PROJECT_DIR/oversight" ]; then
    echo -e "${YELLOW}WARNING: oversight/ folder already exists!${NC}"
    echo ""
    echo "This script is for NEW projects only."
    echo "For existing projects, use update-templates.sh instead."
    echo ""
    read -p "Continue anyway? This will NOT overwrite existing files. (y/n): " FORCE
    if [ "$FORCE" != "y" ] && [ "$FORCE" != "Y" ]; then
        echo "Cancelled."
        exit 0
    fi
fi

echo ""
echo "Initializing oversight folder..."
echo ""

# Create oversight directory
mkdir -p "$PROJECT_DIR/oversight"

# Copy templates with no-clobber (never overwrites)
echo "[1/4] Copying template files..."
TEMPLATE_DIR="$PROJECT_DIR/pov/templates/oversight"
NEW_FILES=0
SKIPPED_FILES=0

# Use find to copy files recursively without overwriting
while IFS= read -r -d '' file; do
    # Get relative path from template dir
    rel_path="${file#$TEMPLATE_DIR/}"
    target_file="$PROJECT_DIR/oversight/$rel_path"

    # Create parent directory if needed
    mkdir -p "$(dirname "$target_file")"

    # Copy only if doesn't exist
    if [ ! -f "$target_file" ]; then
        cp "$file" "$target_file"
        NEW_FILES=$((NEW_FILES + 1))
    else
        SKIPPED_FILES=$((SKIPPED_FILES + 1))
    fi
done < <(find "$TEMPLATE_DIR" -type f -print0)

echo -e "${GREEN}  Copied $NEW_FILES new files${NC}"
if [ $SKIPPED_FILES -gt 0 ]; then
    echo -e "${YELLOW}  Skipped $SKIPPED_FILES existing files${NC}"
fi

# Create additional directories
echo "[2/4] Creating directory structure..."
mkdir -p "$PROJECT_DIR/oversight/decisions"
mkdir -p "$PROJECT_DIR/oversight/session-logs"
mkdir -p "$PROJECT_DIR/oversight/prompts"
mkdir -p "$PROJECT_DIR/oversight/uncertainty"
mkdir -p "$PROJECT_DIR/oversight/archive"
mkdir -p "$PROJECT_DIR/oversight/audits"
mkdir -p "$PROJECT_DIR/oversight/plans"
mkdir -p "$PROJECT_DIR/oversight/specs"
mkdir -p "$PROJECT_DIR/oversight/tasks"
mkdir -p "$PROJECT_DIR/oversight/session-index"
mkdir -p "$PROJECT_DIR/oversight/session-index/archive"
echo -e "${GREEN}  Done${NC}"

# Create .gitkeep files for empty directories
echo "[3/4] Creating .gitkeep files..."
for dir in decisions session-logs prompts uncertainty; do
    touch "$PROJECT_DIR/oversight/$dir/.gitkeep"
done
echo -e "${GREEN}  Done${NC}"

# Report structure
echo "[4/4] Verifying structure..."
TOTAL_DIRS=$(find "$PROJECT_DIR/oversight" -type d | wc -l)
TOTAL_FILES=$(find "$PROJECT_DIR/oversight" -type f | wc -l)
echo -e "${GREEN}  Created $TOTAL_DIRS directories and $TOTAL_FILES files${NC}"

echo ""
echo "========================================"
echo -e "${GREEN}  INITIALIZATION COMPLETE!${NC}"
echo "========================================"
echo ""
echo "Oversight folder structure:"
echo "  oversight/"
echo "    ├── SESSION_WORK_INDEX.md  (quick context, <80 lines)"
echo "    ├── session-index/         (NEW: full session history)"
echo "    │   ├── INDEX.md           (navigation)"
echo "    │   └── archive/           (quarterly archives)"
echo "    ├── knowledge/             (assumptions, confidence map)"
echo "    ├── tracking/              (tasks, risks, blockers, debt)"
echo "    ├── verification/          (checklists)"
echo "    ├── decisions/             (architectural decisions)"
echo "    ├── session-logs/          (individual handoffs)"
echo "    ├── specs/                 (specifications)"
echo "    └── standards/             (project standards)"
echo ""
echo "Next steps:"
echo "1. Review SESSION_WORK_INDEX.md to understand the oversight system"
echo "2. Customize PROJECT_STANDARDS.yaml for your project"
echo "3. Start using Parzival: /parzival-start"
echo ""
