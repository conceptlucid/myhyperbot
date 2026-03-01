#!/bin/bash
# HyperBot Installer
# Run: curl -sL https://myhyperbot.com/hyperbot.sh | bash

set -e

echo "🤖 Installing HyperBot..."

# Try to install cron if not available
if ! command -v crontab &> /dev/null; then
    echo "📦 Installing cron..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y cron 2>/dev/null || true
    elif command -v yum &> /dev/null; then
        sudo yum install -y cronie 2>/dev/null || true
    elif command -v brew &> /dev/null; then
        brew install cron 2>/dev/null || true
    fi
fi

# Create install dir
INSTALL_DIR="$HOME/.hyperbot"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

echo "📥 Downloading HyperBot..."

# Try git clone first
if command -v git &> /dev/null; then
    rm -rf myhyperbot 2>/dev/null || true
    git clone --depth 1 https://github.com/conceptlucid/myhyperbot.git myhyperbot 2>/dev/null && cd myhyperbot/hyperbot-agent && {
        echo "   Installing dependencies..."
        npm install 2>/dev/null || npm install || true
        cd ..
    }
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

# Setup auto-start with cron
echo "📝 Setting up auto-start..."
if command -v crontab &> /dev/null; then
    (crontab -l 2>/dev/null | grep -v "hyperbot"; echo "@reboot $HOME/.hyperbot/start.sh") | crontab - 2>/dev/null && {
        echo "   ✅ Auto-start enabled!"
    }
else
    echo "   ⚠️ Cron not available. Start manually with: ~/.hyperbot/start.sh"
fi

echo ""
echo "✅ HyperBot installed!"
echo ""
echo "To start now:"
echo "   ~/.hyperbot/start.sh"
echo ""
