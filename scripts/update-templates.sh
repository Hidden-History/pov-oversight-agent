#!/bin/bash
# Parzival Oversight Template Updater
# Version: 1.0.0
# For EXISTING projects - selectively updates oversight templates

# Note: Not using 'set -e' for this interactive script
# as read commands can return non-zero on EOF

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "========================================"
echo "  PARZIVAL TEMPLATE UPDATER v1.0.0"
echo "  For EXISTING projects"
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

# Verify Parzival module is installed
if [ ! -d "$PROJECT_DIR/_bmad/pov" ]; then
    echo -e "${RED}ERROR: Parzival module not found${NC}"
    echo "Please run install.sh first"
    exit 1
fi

# Verify oversight folder exists
if [ ! -d "$PROJECT_DIR/oversight" ]; then
    echo -e "${RED}ERROR: oversight/ folder not found${NC}"
    echo "For new projects, use init-oversight.sh instead"
    exit 1
fi

TEMPLATE_DIR="$PROJECT_DIR/_bmad/pov/templates/oversight"
OVERSIGHT_DIR="$PROJECT_DIR/oversight"

echo "Scanning for template updates..."
echo ""

# Counters
NEW_FILES=0
UPDATED_FILES=0
KEPT_FILES=0
SKIPPED_FILES=0

# Find all template files
while IFS= read -r -d '' template_file; do
    # Get relative path from template dir
    rel_path="${template_file#$TEMPLATE_DIR/}"
    target_file="$OVERSIGHT_DIR/$rel_path"

    # Skip _TEMPLATE.md files (these are just templates for new files)
    if [[ "$rel_path" == *"_TEMPLATE.md" ]]; then
        continue
    fi

    # If target doesn't exist, copy it
    if [ ! -f "$target_file" ]; then
        mkdir -p "$(dirname "$target_file")"
        cp "$template_file" "$target_file"
        echo -e "${GREEN}[NEW]${NC} $rel_path"
        NEW_FILES=$((NEW_FILES + 1))
        continue
    fi

    # Check if files are different
    if ! diff -q "$template_file" "$target_file" > /dev/null 2>&1; then
        echo ""
        echo "========================================"
        echo -e "${YELLOW}[CHANGED]${NC} $rel_path"
        echo "========================================"
        echo ""
        echo "Options:"
        echo "  [d] Show diff"
        echo "  [k] Keep current version (skip update)"
        echo "  [u] Use new template (replace current)"
        echo "  [s] Skip all remaining (stop prompting)"
        echo ""

        while true; do
            read -p "Choice [d/k/u/s]: " choice || {
                # Handle EOF (when input is piped or redirected)
                echo ""
                echo -e "${YELLOW}  EOF detected, keeping current version${NC}"
                KEPT_FILES=$((KEPT_FILES + 1))
                break
            }
            case "$choice" in
                d|D)
                    echo ""
                    echo "--- Current version"
                    echo "+++ New template"
                    diff -u "$target_file" "$template_file" || true
                    echo ""
                    ;;
                k|K)
                    echo -e "${BLUE}  Keeping current version${NC}"
                    KEPT_FILES=$((KEPT_FILES + 1))
                    break
                    ;;
                u|U)
                    cp "$template_file" "$target_file"
                    echo -e "${GREEN}  Updated to new template${NC}"
                    UPDATED_FILES=$((UPDATED_FILES + 1))
                    break
                    ;;
                s|S)
                    echo -e "${YELLOW}  Skipping all remaining updates${NC}"
                    SKIPPED_FILES=$((SKIPPED_FILES + 1))
                    # Mark as skipped and exit the while loop
                    SKIP_ALL=1
                    break
                    ;;
                *)
                    echo "Invalid choice. Please enter d, k, u, or s"
                    ;;
            esac
        done

        # Check if user wants to skip all
        if [ "${SKIP_ALL:-0}" -eq 1 ]; then
            break
        fi
    fi

done < <(find "$TEMPLATE_DIR" -type f -print0)

echo ""
echo "========================================"
echo -e "${GREEN}  UPDATE COMPLETE!${NC}"
echo "========================================"
echo ""
echo "Summary:"
echo -e "  ${GREEN}New files added:${NC}       $NEW_FILES"
echo -e "  ${GREEN}Files updated:${NC}         $UPDATED_FILES"
echo -e "  ${BLUE}Files kept (skipped):${NC}  $KEPT_FILES"
if [ "${SKIP_ALL:-0}" -eq 1 ]; then
    echo -e "  ${YELLOW}Files skipped (all):${NC}   (remaining files not processed)"
fi
echo ""

if [ $UPDATED_FILES -gt 0 ] || [ $NEW_FILES -gt 0 ]; then
    echo "Changes made to oversight folder."
    echo "Review changes before committing:"
    echo "  cd $PROJECT_DIR"
    echo "  git diff oversight/"
fi

echo ""
