#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

TOOL_NAME="clawdhub"

# Pull latest if this is an update
if [ -d .git ]; then
    git pull --ff-only 2>/dev/null || true
fi

# Clean stale build artifacts
rm -rf node_modules packages/clawdhub/dist ~/prj/util/bin/"$TOOL_NAME"

# Install dependencies
bun install

# Build CLI package
cd packages/clawdhub
bun run build
cd ../..

# Create wrapper script that runs the CLI
mkdir -p ~/prj/util/bin
cat > ~/prj/util/bin/"$TOOL_NAME" << 'WRAPPER'
#!/usr/bin/env bash
exec node "/Users/me/prj/util/clawdhub/packages/clawdhub/bin/clawdhub.js" "$@"
WRAPPER
chmod +x ~/prj/util/bin/"$TOOL_NAME"

echo "Installed: $("$TOOL_NAME" --version 2>/dev/null || echo "$TOOL_NAME")"
