#!/bin/bash
# HyperBot Installer
# Run: curl -sL https://myhyperbot.com/hyperbot.sh | bash

echo "🤖 Installing HyperBot..."

# Create install dir
INSTALL_DIR="$HOME/.hyperbot"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

echo "📥 Setting up HyperBot..."

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
echo "Starting HyperBot agent..."
echo "Make sure you have Node.js installed: https://nodejs.org"
echo ""
echo "To run manually:"
echo "  git clone https://github.com/conceptlucid/myhyperbot.git"
echo "  cd myhyperbot/hyperbot-agent"
echo "  npm install"
echo "  npx tsx src/index.ts"
EOF
chmod +x start.sh

# Create README
cat > README.md << 'EOF'
# HyperBot

## To run:

1. Install Node.js: https://nodejs.org

2. Clone the repo:
   git clone https://github.com/conceptlucid/myhyperbot.git

3. Install dependencies:
   cd myhyperbot/hyperbot-agent
   npm install

4. Configure:
   Edit config.json with your cloud URL

5. Start:
   npx tsx src/index.ts
EOF

echo ""
echo "✅ HyperBot setup complete!"
echo ""
echo "To finish installation:"
echo "1. Install Node.js: https://nodejs.org"
echo "2. Run: git clone https://github.com/conceptlucid/myhyperbot.git"
echo "3. cd myhyperbot/hyperbot-agent"
echo "4. npm install"
echo "5. npx tsx src/index.ts"
echo ""
echo "📖 Full docs: https://github.com/conceptlucid/myhyperbot"
