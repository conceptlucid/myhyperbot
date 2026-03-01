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
    <div style={{ minHeight: '100vh', background: '#0a0a0a', color: '#fff', fontFamily: 'system-ui' }}>
      {/* Header */}
      <div style={{ padding: '20px 40px', borderBottom: '1px solid #111' }}>
        <a href="/" style={{ color: '#888', textDecoration: 'none' }}>← Back to Home</a>
      </div>

      <div style={{ maxWidth: '800px', margin: '0 auto', padding: '40px 20px' }}>
        <h1 style={{ fontSize: '3rem', fontWeight: '800', marginBottom: '10px' }}>
          Install <span style={{ color: '#00d4ff' }}>HyperBot</span>
        </h1>
        <p style={{ color: '#888', fontSize: '1.3rem', marginBottom: '40px' }}>
          Connect your computer to HyperBot in seconds
        </p>

        {/* Install Box */}
        <div style={{ background: '#111', borderRadius: '20px', padding: '40px', marginBottom: '40px', border: '1px solid #222' }}>
          <h2 style={{ fontSize: '1.5rem', marginBottom: '20px' }}>🚀 Quick Install</h2>
          
          <div style={{ marginBottom: '30px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '10px' }}>
              <span style={{ color: '#00d4ff', fontWeight: '600' }}>macOS / Linux</span>
              <span style={{ color: '#666', fontSize: '0.9rem' }}>Run in Terminal</span>
            </div>
            <div style={{ background: '#000', padding: '16px 20px', borderRadius: '12px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <code style={{ color: '#00ff88', fontSize: '1rem' }}>curl -sL https://myhyperbot.com/hyperbot.sh | bash</code>
              <button onClick={() => copyToClipboard('curl -sL https://myhyperbot.com/hyperbot.sh | bash', 'mac')} style={{ padding: '8px 16px', background: '#222', border: 'none', borderRadius: '8px', color: '#fff', cursor: 'pointer', marginLeft: '20px' }}>
                {copied === 'mac' ? '✓ Copied' : 'Copy'}
              </button>
            </div>
          </div>

          <div>
            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '10px' }}>
              <span style={{ color: '#00d4ff', fontWeight: '600' }}>Windows</span>
              <span style={{ color: '#666', fontSize: '0.9rem' }}>Run in PowerShell</span>
            </div>
            <div style={{ background: '#000', padding: '16px 20px', borderRadius: '12px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <code style={{ color: '#00ff88', fontSize: '1rem' }}>irm https://myhyperbot.com/hyperbot.ps1 | iex</code>
              <button onClick={() => copyToClipboard('irm https://myhyperbot.com/hyperbot.ps1 | iex', 'win')} style={{ padding: '8px 16px', background: '#222', border: 'none', borderRadius: '8px', color: '#fff', cursor: 'pointer', marginLeft: '20px' }}>
                {copied === 'win' ? '✓ Copied' : 'Copy'}
              </button>
            </div>
          </div>
        </div>

        {/* Steps */}
        <div style={{ background: '#111', borderRadius: '20px', padding: '40px', border: '1px solid #222' }}>
          <h2 style={{ fontSize: '1.5rem', marginBottom: '30px' }}>📋 After Install</h2>
          
          <div style={{ display: 'grid', gap: '20px' }}>
            <div style={{ display: 'flex', gap: '15px', alignItems: 'flex-start' }}>
              <div style={{ width: '30px', height: '30px', background: '#00d4ff', borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#000', fontWeight: '700', flexShrink: '0' }}>1</div>
              <div>
                <div style={{ fontWeight: '600', marginBottom: '5px' }}>Edit config file</div>
                <code style={{ color: '#00d4ff', background: '#000', padding: '4px 10px', borderRadius: '6px', fontSize: '0.9rem' }}>nano ~/.hyperbot/config.json</code>
              </div>
            </div>
            
            <div style={{ display: 'flex', gap: '15px', alignItems: 'flex-start' }}>
              <div style={{ width: '30px', height: '30px', background: '#00d4ff', borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#000', fontWeight: '700', flexShrink: '0' }}>2</div>
              <div>
                <div style={{ fontWeight: '600', marginBottom: '5px' }}>Set your server URL</div>
                <code style={{ color: '#00d4ff', background: '#000', padding: '4px 10px', borderRadius: '6px', fontSize: '0.9rem' }}>"cloudUrl": "https://myhyperbot.com"</code>
              </div>
            </div>
            
            <div style={{ display: 'flex', gap: '15px', alignItems: 'flex-start' }}>
              <div style={{ width: '30px', height: '30px', background: '#00d4ff', borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#000', fontWeight: '700', flexShrink: '0' }}>3</div>
              <div>
                <div style={{ fontWeight: '600', marginBottom: '5px' }}>Start the agent</div>
                <code style={{ color: '#00d4ff', background: '#000', padding: '4px 10px', borderRadius: '6px', fontSize: '0.9rem' }}>~/.hyperbot/start.sh</code>
              </div>
            </div>
            
            <div style={{ display: 'flex', gap: '15px', alignItems: 'flex-start' }}>
              <div style={{ width: '30px', height: '30px', background: '#00d4ff', borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#000', fontWeight: '700', flexShrink: '0' }}>4</div>
              <div>
                <div style={{ fontWeight: '600', marginBottom: '5px' }}>Go to dashboard!</div>
                <a href="/dashboard" style={{ color: '#00d4ff' }}>https://myhyperbot.com/dashboard</a>
              </div>
            </div>
          </div>
        </div>

        {/* Help */}
        <div style={{ marginTop: '40px', textAlign: 'center', color: '#666' }}>
          <p>Need help? <a href="https://github.com/conceptlucid/myhyperbot" style={{ color: '#00d4ff' }}>Check GitHub</a></p>
        </div>
      </div>
    </div>
  )
}
