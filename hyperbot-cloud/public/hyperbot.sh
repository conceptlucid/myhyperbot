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

# Try git clone first
if command -v git &> /dev/null; then
    rm -rf myhyperbot 2>/dev/null || true
    git clone --depth 1 https://github.com/conceptlucid/myhyperbot.git myhyperbot 2>/dev/null && cd myhyperbot/hyperbot-agent && {
        echo "   Installing dependencies..."
        npm install 2>/dev/null || npm install || true
        cd ..
    }
fi

# Fallback: download via curl
if [ ! -d "myhyperbot/hyperbot-agent" ] && command -v curl &> /dev/null; then
    mkdir -p myhyperbot/hyperbot-agent
    cd myhyperbot/hyperbot-agent
    curl -sL "https://raw.githubusercontent.com/conceptlucid/myhyperbot/main/hyperbot-agent/package.json" -o package.json 2>/dev/null || true
    mkdir -p src
    curl -sL "https://raw.githubusercontent.com/conceptlucid/myhyperbot/main/hyperbot-agent/src/index.ts" -o src/index.ts 2>/dev/null || true
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

# Setup auto-start (cron/systemd/launchd)
echo "📝 Setting up auto-start..."

SETUP_SUCCESS=false

# Try cron
if command -v crontab &> /dev/null; then
    (crontab -l 2>/dev/null | grep -v "hyperbot"; echo "@reboot $HOME/.hyperbot/start.sh") | crontab - 2>/dev/null && {
        echo "   ✅ Added to crontab"
        SETUP_SUCCESS=true
    }
fi

# Try systemd (Linux)
if [ -d "$HOME/.config/systemd/user" ] && command -v systemctl &> /dev/null; then
    mkdir -p "$HOME/.config/systemd/user"
    cat > "$HOME/.config/systemd/user/hyperbot.service" << 'EOFSERVICE'
[Unit]
Description=HyperBot Agent

[Service]
Type=simple
ExecStart=%h/.hyperbot/start.sh
Restart=on-failure

[Install]
WantedBy=default.target
EOFSERVICE
    systemctl --user enable hyperbot 2>/dev/null && {
        echo "   ✅ Enabled systemd service"
        SETUP_SUCCESS=true
    }
fi

# Try launchd (macOS)
if [ -d "$HOME/Library/LaunchAgents" ]; then
    cat > "$HOME/Library/LaunchAgents/com.hyperbot.agent.plist" << 'EOFLAUNCH'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.hyperbot.agent</string>
    <key>ProgramArguments</key>
    <array>
        <string>%h/.hyperbot/start.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOFLAUNCH
    launchctl load "$HOME/Library/LaunchAgents/com.hyperbot.agent.plist" 2>/dev/null && {
        echo "   ✅ Enabled launchd service"
        SETUP_SUCCESS=true
    }
fi

if [ "$SETUP_SUCCESS" = false ]; then
    echo "   ⚠️  Auto-start not available. To start manually: ~/.hyperbot/start.sh"
fi

echo ""
echo "✅ HyperBot installed!"
echo ""
echo "To start now:"
echo "   ~/.hyperbot/start.sh"
echo ""
