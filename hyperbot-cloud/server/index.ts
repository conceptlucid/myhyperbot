import { createServer } from 'http'
import { WebSocketServer, WebSocket } from 'ws'

interface Agent {
  ws: WebSocket
  id: string
  name: string
  lastSeen: number
}

const agents = new Map<string, Agent>()

const server = createServer((req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization')
  
  if (req.url === '/health') {
    res.writeHead(200, { 'Content-Type': 'application/json' })
    res.end(JSON.stringify({ status: 'ok', agents: agents.size }))
    return
  }

  if (req.url === '/api/agents' && req.method === 'GET') {
    const list = Array.from(agents.values()).map(a => ({ id: a.id, name: a.name }))
    res.writeHead(200)
    res.end(JSON.stringify(list))
    return
  }

  res.writeHead(404)
  res.end('Not found')
})

const wss = new WebSocketServer({ server, path: '/ws/agent' })

wss.on('connection', (ws, req) => {
  const apiKey = req.headers['authorization']?.replace('Bearer ', '')
  const deviceId = req.headers['x-device-id'] as string

  if (!apiKey) {
    ws.close(4001, 'Unauthorized')
    return
  }

  ws.on('message', (data) => {
    try {
      const msg = JSON.parse(data.toString())
      if (msg.type === 'register') {
        agents.set(deviceId, { ws, id: msg.deviceId, name: msg.deviceName, lastSeen: Date.now() })
        console.log(`✅ Agent registered: ${msg.deviceName}`)
        ws.send(JSON.stringify({ type: 'welcome' }))
      }
    } catch (e) {}
  })

  ws.on('close', () => {
    if (deviceId) agents.delete(deviceId)
  })
})

server.listen(3001, () => {
  console.log('🚀 HyperBot server running on port 3001')
})
