#!/bin/bash
# HyperBot Installer
# Run: curl -sL https://myhyperbot.com/hyperbot.sh | bash

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

# Download agent
echo "📥 Downloading HyperBot agent..."
git clone --depth 1 https://github.com/conceptlucid/myhyperbot.git temp 2>/dev/null || {
    echo "⚠️ Git clone failed, using npm..."
}

if [ -d "temp/hyperbot-agent" ]; then
    mv temp/hyperbot-agent .
    rm -rf temp
fi

# Install dependencies
if [ -d "hyperbot-agent" ]; then
    cd hyperbot-agent
    echo "📚 Installing dependencies..."
    npm install 2>/dev/null || npm install || true
    cd ..
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
cd "$(dirname "$0")/hyperbot-agent"
npx tsx src/index.ts
EOF
chmod +x start.sh

echo ""
echo "✅ HyperBot installed!"
echo ""
echo "Next steps:"
echo "1. Edit ~/.hyperbot/config.json with your cloud URL"
echo "2. Run: ~/.hyperbot/start.sh"
echo ""
