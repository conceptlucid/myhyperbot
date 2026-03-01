#!/bin/bash
# HyperBot Installer
# Run: curl -sL https://myhyperbot.com/hyperbot.sh | bash

set -e

echo "🤖 Installing HyperBot..."

# Detect OS
OS="$(uname -s)"
case "$OS" in
    Linux*)     PLATFORM="linux";;
    Darwin*)    PLATFORM="darwin";;
    MINGW*|MSYS*|CYGWIN*) PLATFORM="windows";;
    *)          echo "❌ Unsupported OS: $OS"; exit 1;;
esac

ARCH="$(uname -m)"
case "$ARCH" in
    x86_64)     ARCH="x64";;
    aarch64|arm64) ARCH="arm64";;
    *)          echo "❌ Unsupported architecture: $ARCH"; exit 1;;
esac

echo "   Platform: $PLATFORM ($ARCH)"

# Create install dir
INSTALL_DIR="$HOME/.hyperbot"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# Download agent files from GitHub releases (or clone)
echo "📥 Downloading HyperBot agent..."
REPO="conceptlucid/myhyperbot"

# Try to download pre-built or clone
if command -v git &> /dev/null; then
    if [ -d ".git" ]; then
        git pull 2>/dev/null || true
    else
        git clone --depth 1 https://github.com/$REPO.git temp 2>/dev/null || echo "⚠️  Using fallback..."
    fi
fi

# Create config
echo "⚙️  Configuring..."
cat > config.json << 'EOF'
{
  "cloudUrl": "https://myhyperbot.com",
  "deviceName": "",
  "apiKey": ""
}
EOF

# Create start script
cat > start.sh << 'EOF'
#!/bin/bash
cd "$(dirname "$0")"
npx tsx src/index.ts
EOF
chmod +x start.sh

# Install Node dependencies if needed
if [ -d "hyperbot-agent" ]; then
    cd hyperbot-agent
    if [ ! -d "node_modules" ]; then
        echo "📚 Installing dependencies..."
        npm install --silent 2>/dev/null || npm install 2>/dev/null || true
    fi
    cd ..
fi

echo ""
echo "✅ HyperBot installed!"
echo ""
echo "Next steps:"
echo "1. Edit ~/.hyperbot/config.json with your cloud URL"
echo "2. Run: ~/.hyperbot/start.sh"
echo ""
echo "📖 Docs: https://github.com/conceptlucid/myhyperbot"
