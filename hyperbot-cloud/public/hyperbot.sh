#!/bin/bash
# HyperBot Quick Install
# Run: curl -sL https://myhyperbot.com/hyperbot.sh | bash

echo "🤖 HyperBot Installer"
echo ""

# Function to check if Node.js is installed
check_node() {
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v)
        echo "✅ Node.js $NODE_VERSION found"
        return 0
    else
        echo "❌ Node.js not found"
        return 1
    fi
}

# Function to install Node.js
install_node() {
    echo "📦 Installing Node.js..."
    
    if command -v apt-get &> /dev/null; then
        # Debian/Ubuntu
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs
    elif command -v yum &> /dev/null; then
        # CentOS/RHEL
        curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash - && sudo yum install -y nodejs
    elif command -v brew &> /dev/null; then
        # macOS
        brew install node
    elif command -v winget &> /dev/null; then
        # Windows (WSL or Git Bash)
        winget install OpenJS.NodeJS
    else
        echo "❌ Cannot auto-install Node.js"
        echo "Please install Node.js manually: https://nodejs.org"
        exit 1
    fi
}

# Check for Node.js, install if missing
if ! check_node; then
    install_node
    check_node || exit 1
fi

# Create install directory
INSTALL_DIR="$HOME/.hyperbot"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# Generate device code
DEVICE_CODE=$(cat /dev/urandom | tr -dc 'A-Z0-9' | fold -w 8 | head -n 1)

# Create config
cat > config.json << EOF
{
  "deviceCode": "$DEVICE_CODE",
  "cloudUrl": "https://myhyperbot.com",
  "apiKey": "",
  "setupComplete": false
}
EOF

# Create simple connector
cat > connect.js << 'EOF'
const { WebSocket } = require('ws');
const fs = require('fs');
const http = require('http');

const config = JSON.parse(fs.readFileSync('./config.json', 'utf-8'));
const deviceId = config.deviceCode || 'unknown';

console.log('🤖 HyperBot connecting...');
console.log('   Device Code:', deviceId);

// Try to connect to cloud
try {
    const ws = new WebSocket((config.cloudUrl || 'https://myhyperbot.com').replace('https','wss') + '/ws/agent', {
        headers: { 
            'Authorization': 'Bearer ' + (config.apiKey || 'demo'),
            'X-Device-Id': deviceId 
        }
    });

    ws.on('open', () => {
        console.log('✅ Connected to HyperBot Cloud!');
        ws.send(JSON.stringify({ 
            type: 'register', 
            deviceId, 
            deviceName: 'my-device',
            capabilities: ['screen', 'mouse', 'keyboard', 'terminal', 'files', 'system']
        }));
    });

    ws.on('message', (data) => {
        const msg = JSON.parse(data);
        if (msg.type === 'welcome') {
            console.log('✅ Device registered!');
            console.log('\n🎉 You\'re all set!');
            console.log('Now go to https://myhyperbot.com/setup and enter your device code:', deviceId);
        }
    });

    ws.on('error', (err) => {
        console.log('⚠️ Could not connect to cloud (this is okay for now)');
        console.log('Your device code is:', deviceId);
        console.log('Go to https://myhyperbot.com/setup to finish setup');
    });
} catch(e) {
    console.log('⚠️ Connection setup failed');
    console.log('Your device code is:', deviceId);
    console.log('Go to https://myhyperbot.com/setup to finish setup');
}
EOF

echo ""
echo "✅ Installation complete!"
echo ""
echo "NEXT STEPS:"
echo "1. Go to: https://myhyperbot.com/setup"
echo "2. Enter device code: $DEVICE_CODE"
echo "3. Complete setup through Telegram or Discord"
echo ""
