#!/bin/bash
# HyperBot Installer
# Run: curl -sL https://myhyperbot.com/hyperbot.sh | bash

set -e

echo "🤖 Installing HyperBot..."

# Create install dir
INSTALL_DIR="$HOME/.hyperbot"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

echo "📥 Downloading HyperBot..."

# Method 1: Try git clone
if command -v git &> /dev/null; then
    echo "   Using git..."
    rm -rf myhyperbot 2>/dev/null || true
    git clone --depth 1 https://github.com/conceptlucid/myhyperbot.git myhyperbot 2>/dev/null && cd myhyperbot/hyperbot-agent && {
        echo "   Installing dependencies..."
        npm install 2>/dev/null || npm install || true
        cd ..
    }
fi

# Method 2: If git failed, try curl
if [ ! -d "myhyperbot/hyperbot-agent" ] && command -v curl &> /dev/null; then
    echo "   Using curl..."
    mkdir -p myhyperbot/hyperbot-agent
    cd myhyperbot/hyperbot-agent
    
    # Download main files
    curl -sL "https://raw.githubusercontent.com/conceptlucid/myhyperbot/main/hyperbot-agent/package.json" -o package.json
    curl -sL "https://raw.githubusercontent.com/conceptlucid/myhyperbot/main/hyperbot-agent/src/index.ts" -o src/index.ts 2>/dev/null || mkdir -p src
    
    echo "   Installing dependencies..."
    npm install 2>/dev/null || npm install || true
    cd ../..
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
cd "$(dirname "$0")/myhyperbot/hyperbot-agent"
npx tsx src/index.ts
EOF
chmod +x start.sh

echo ""
echo "✅ HyperBot installed!"
echo ""
echo "To start:"
echo "   ~/.hyperbot/start.sh"
echo ""
