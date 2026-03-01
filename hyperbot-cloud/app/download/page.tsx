'use client'

import { useState } from 'react'

export default function Download() {
  const [copied, setCopied] = useState('')

  const copyToClipboard = (text: string, id: string) => {
    navigator.clipboard.writeText(text)
    setCopied(id)
    setTimeout(() => setCopied(''), 2000)
  }

  return (
    <div style={{ minHeight: '100vh', background: '#0a0a0a', color: '#fff', fontFamily: 'system-ui', padding: '40px' }}>
      <a href="/" style={{ color: '#888', textDecoration: 'none' }}>← Back</a>
      
      <h1 style={{ fontSize: '3rem', marginTop: '40px', marginBottom: '20px' }}>
        Install HyperBot
      </h1>
      <p style={{ color: '#888', fontSize: '1.2rem', marginBottom: '40px' }}>
        One command to connect your machine to HyperBot
      </p>

      <div style={{ background: '#111', borderRadius: '16px', padding: '30px', marginBottom: '30px' }}>
        <h3 style={{ marginBottom: '20px', color: '#00d4ff' }}>macOS / Linux</h3>
        <div style={{ background: '#000', padding: '20px', borderRadius: '12px', fontFamily: 'monospace', fontSize: '1.1rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <span>curl -sL https://myhyperbot.com/hyperbot.sh | bash</span>
          <button onClick={() => copyToClipboard('curl -sL https://myhyperbot.com/hyperbot.sh | bash', 'mac')} style={{ padding: '8px 16px', background: '#222', border: 'none', borderRadius: '6px', color: '#fff', cursor: 'pointer' }}>
            {copied === 'mac' ? '✓ Copied!' : 'Copy'}
          </button>
        </div>
      </div>

      <div style={{ background: '#111', borderRadius: '16px', padding: '30px', marginBottom: '30px' }}>
        <h3 style={{ marginBottom: '20px', color: '#00d4ff' }}>Windows (PowerShell)</h3>
        <div style={{ background: '#000', padding: '20px', borderRadius: '12px', fontFamily: 'monospace', fontSize: '1.1rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <span>irm https://myhyperbot.com/hyperbot.ps1 | iex</span>
          <button onClick={() => copyToClipboard('irm https://myhyperbot.com/hyperbot.ps1 | iex', 'win')} style={{ padding: '8px 16px', background: '#222', border: 'none', borderRadius: '6px', color: '#fff', cursor: 'pointer' }}>
            {copied === 'win' ? '✓ Copied!' : 'Copy'}
          </button>
        </div>
      </div>

      <div style={{ marginTop: '50px' }}>
        <h2 style={{ marginBottom: '30px' }}>After install:</h2>
        <ol style={{ color: '#888', lineHeight: '2.5', fontSize: '1.1rem' }}>
          <li>Edit <code style={{ color: '#00d4ff' }}>~/.hyperbot/config.json</code></li>
          <li>Set cloudUrl: <code style={{ color: '#00d4ff' }}>"cloudUrl": "https://myhyperbot.com"</code></li>
          <li>Set your API key (get from dashboard or leave blank)</li>
          <li>Run: <code style={{ color: '#00d4ff' }}>~/.hyperbot/start.sh</code></li>
          <li>Your machine appears in the dashboard!</li>
        </ol>
      </div>

      <div style={{ marginTop: '40px', background: '#111', borderRadius: '16px', padding: '30px' }}>
        <h3 style={{ marginBottom: '20px', color: '#00d4ff' }}>Example config.json:</h3>
        <pre style={{ background: '#000', padding: '20px', borderRadius: '12px', overflow: 'auto', fontSize: '0.9rem', color: '#888' }}>
{`{
  "cloudUrl": "https://myhyperbot.com",
  "deviceName": "my-macbook",
  "apiKey": ""
}`}
        </pre>
      </div>
    </div>
  )
}
