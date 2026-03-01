#!/bin/bash
# HyperBot Quick Install
# Run: curl -sL https://myhyperbot.com/hyperbot.sh |🤖 Hyper bash

echo "Bot Quick Install"
echo ""

# Create install dir
mkdir -p "$HOME/.hyperbot"
cd "$HOME/.hyperbot"

# Create minimal config
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
npx tsx -e "
const { WebSocket } = require('ws');
const fs = require('fs');
const config = JSON.parse(fs.readFileSync('./config.json', 'utf-8'));
const deviceId = require('crypto').randomUUID();

const ws = new WebSocket(config.cloudUrl.replace('https','wss') + '/ws/agent', {
  headers: { 'Authorization': 'Bearer ' + (config.apiKey||'demo'), 'X-Device-Id': deviceId }
});

ws.on('open', () => {
  console.log('Connected! Device ID:', deviceId);
  ws.send(JSON.stringify({ type: 'register', deviceId, deviceName: config.deviceName || 'my-device', capabilities: ['terminal'] }));
});

ws.on('message', (data) => console.log(data.toString()));
"
EOF

chmod +x start.sh

echo "✅ Setup complete!"
echo ""
echo "NEXT STEPS:"
echo "1. Message @hyperbot on Discord or Telegram"
echo "2. Say 'register' and give it this device ID:"
echo "   (run ~/.hyperbot/start.sh to see it)"
echo ""
echo "Or just run: ~/.hyperbot/start.sh"
echo ""
