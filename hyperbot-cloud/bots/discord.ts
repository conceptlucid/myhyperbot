import { Client, GatewayIntentBits, Events } from 'discord.js'

const TOKEN = process.env.DISCORD_BOT_TOKEN
if (!TOKEN) { console.log('⚠️ Set DISCORD_BOT_TOKEN'); process.exit(0) }

const client = new Client({ intents: [GatewayIntentBits.Guilds, GatewayIntentBits.GuildMessages, GatewayIntentBits.MessageContent] })

client.once(Events.ClientReady, () => console.log(`🤖 HyperBot Discord ready: ${client.user?.tag}`))

client.on(Events.MessageCreate, async (msg) => {
  if (msg.author.bot) return
  const text = msg.content.toLowerCase().trim()
  
  // Setup commands
  if (text === 'register') {
    await msg.reply(`📝 To register your device:\n\n1. Run on your computer:\n\`curl -sL https://myhyperbot.com/hyperbot.sh | bash\`\n\n2. Then run: \`~/.hyperbot/start.sh\`\n\n3. Come back here and say "my device is online"`)
    return
  }
  
  if (text === 'my device is online' || text === 'device online') {
    // In a real implementation, check connected agents
    await msg.reply("Great! Your device should be connected. You can now ask me things like:\n- 'run ls -la'\n- 'what's on my screen'\n- 'search for files named report'")
    return
  }
  
  if (text.startsWith('set api')) {
    const key = text.replace('set api', '').trim()
    await msg.reply("API key noted! (In full version, this saves to your config)")
    return
  }
  
  // Default: Echo back (in full version, send to AI)
  await msg.reply(`Hey! I'm HyperBot. Say "register" to get started, or just tell me what you want to do.`)
})

client.login(TOKEN)
