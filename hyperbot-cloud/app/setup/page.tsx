'use client'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'

export default function Setup() {
  const router = useRouter()
  const [step, setStep] = useState(1)
  const [deviceCode, setDeviceCode] = useState('')
  const [formData, setFormData] = useState({
    yourName: '',
    botName: 'HyperBot',
    relationship: 'assistant',
    timezone: 'America/Los_Angeles',
    dailyBrief: true,
    password: ''
  })

  // Generate device code on load
  useEffect(() => {
    const code = Math.random().toString(36).substring(2, 10).toUpperCase()
    setDeviceCode(code)
    localStorage.setItem('hyperbot_code', code)
  }, [])

  const handleSubmit = () => {
    // Save to localStorage (in real app, save to server)
    localStorage.setItem('hyperbot_setup', JSON.stringify(formData))
    router.push('/dashboard')
  }

  return (
    <div style={{ minHeight: '100vh', background: '#0a0a0a', color: '#fff', fontFamily: 'system-ui' }}>
      <div style={{ maxWidth: '600px', margin: '0 auto', padding: '40px 20px' }}>
        {/* Progress */}
        <div style={{ display: 'flex', gap: '10px', marginBottom: '40px' }}>
          {[1,2,3,4].map(s => (
            <div key={s} style={{ 
              flex: 1, height: '4px', borderRadius: '2px',
              background: s <= step ? '#00d4ff' : '#222'
            }} />
          ))}
        </div>

        {/* Step 1: Welcome */}
        {step === 1 && (
          <div>
            <h1 style={{ fontSize: '2.5rem', marginBottom: '20px' }}>
              Welcome to <span style={{ color: '#00d4ff' }}>HyperBot!</span>
            </h1>
            <p style={{ color: '#888', fontSize: '1.2rem', marginBottom: '30px' }}>
              Your personal AI that works on your computer.
            </p>
            <div style={{ background: '#111', padding: '20px', borderRadius: '12px', marginBottom: '30px' }}>
              <p style={{ marginBottom: '10px' }}>Your device code:</p>
              <code style={{ fontSize: '2rem', color: '#00d4ff' }}>{deviceCode}</code>
            </div>
            <button onClick={() => setStep(2)} style={{ 
              padding: '16px 40px', background: '#00d4ff', border: 'none', 
              borderRadius: '12px', color: '#000', fontWeight: '600', fontSize: '1.1rem', cursor: 'pointer'
            }}>
              Continue →
            </button>
          </div>
        )}

        {/* Step 2: Choose Channel */}
        {step === 2 && (
          <div>
            <h2 style={{ marginBottom: '20px' }}>Choose your setup channel</h2>
            <p style={{ color: '#888', marginBottom: '30px' }}>
              How do you want to configure HyperBot?
            </p>
            <div style={{ display: 'grid', gap: '15px' }}>
              {[
                { icon: '✈️', name: 'Telegram', desc: 'Message me on Telegram' },
                { icon: '💬', name: 'Discord', desc: 'Use Discord bot' },
                { icon: '💼', name: 'Slack', desc: 'Slack workspace' },
              ].map(c => (
                <button key={c.name} onClick={() => setStep(3)} style={{ 
                  padding: '20px', background: '#111', border: '1px solid #222', 
                  borderRadius: '12px', color: '#fff', cursor: 'pointer', textAlign: 'left'
                }}>
                  <span style={{ fontSize: '1.5rem', marginRight: '15px' }}>{c.icon}</span>
                  <strong>{c.name}</strong>
                  <p style={{ color: '#666', fontSize: '0.9rem', marginTop: '5px' }}>{c.desc}</p>
                </button>
              ))}
            </div>
          </div>
        )}

        {/* Step 3: Personalize */}
        {step === 3 && (
          <div>
            <h2 style={{ marginBottom: '20px' }}>Personalize your HyperBot</h2>
            
            <div style={{ display: 'grid', gap: '20px' }}>
              <div>
                <label style={{ display: 'block', marginBottom: '8px', color: '#888' }}>Your Name</label>
                <input 
                  type="text" 
                  value={formData.yourName}
                  onChange={e => setFormData({...formData, yourName: e.target.value})}
                  placeholder="What should I call you?"
                  style={{ width: '100%', padding: '14px', background: '#111', border: '1px solid #222', borderRadius: '10px', color: '#fff', fontSize: '1rem' }}
                />
              </div>
              
              <div>
                <label style={{ display: 'block', marginBottom: '8px', color: '#888' }}>Bot Name</label>
                <input 
                  type="text" 
                  value={formData.botName}
                  onChange={e => setFormData({...formData, botName: e.target.value})}
                  placeholder="What should I call myself?"
                  style={{ width: '100%', padding: '14px', background: '#111', border: '1px solid #222', borderRadius: '10px', color: '#fff', fontSize: '1rem' }}
                />
              </div>

              <div>
                <label style={{ display: 'block', marginBottom: '8px', color: '#888' }}>Your Timezone</label>
                <select 
                  value={formData.timezone}
                  onChange={e => setFormData({...formData, timezone: e.target.value})}
                  style={{ width: '100%', padding: '14px', background: '#111', border: '1px solid #222', borderRadius: '10px', color: '#fff', fontSize: '1rem' }}
                >
                  <option value="America/Los_Angeles">Pacific (PT)</option>
                  <option value="America/Denver">Mountain (MT)</option>
                  <option value="America/Chicago">Central (CT)</option>
                  <option value="America/New_York">Eastern (ET)</option>
                  <option value="Europe/London">London</option>
                  <option value="Europe/Paris">Paris</option>
                  <option value="Asia/Tokyo">Tokyo</option>
                </select>
              </div>

              <label style={{ display: 'flex', alignItems: 'center', gap: '10px', cursor: 'pointer' }}>
                <input 
                  type="checkbox" 
                  checked={formData.dailyBrief}
                  onChange={e => setFormData({...formData, dailyBrief: e.target.checked})}
                  style={{ width: '20px', height: '20px' }}
                />
                <span>Send me a daily brief</span>
              </label>
            </div>

            <button onClick={() => setStep(4)} style={{ 
              marginTop: '30px', padding: '16px 40px', background: '#00d4ff', border: 'none', 
              borderRadius: '12px', color: '#000', fontWeight: '600', fontSize: '1.1rem', cursor: 'pointer'
            }}>
              Continue →
            </button>
          </div>
        )}

        {/* Step 4: Dashboard Access */}
        {step === 4 && (
          <div>
            <h2 style={{ marginBottom: '20px' }}>Set up dashboard access</h2>
            
            <div style={{ background: '#111', padding: '20px', borderRadius: '12px', marginBottom: '20px' }}>
              <p style={{ marginBottom: '10px', color: '#888' }}>Your device code (auto-generated):</p>
              <code style={{ fontSize: '1.5rem', color: '#00d4ff' }}>{deviceCode}</code>
            </div>

            <div style={{ marginBottom: '20px' }}>
              <label style={{ display: 'block', marginBottom: '8px', color: '#888' }}>Create a password</label>
              <input 
                type="password" 
                value={formData.password}
                onChange={e => setFormData({...formData, password: e.target.value})}
                placeholder="Min 6 characters"
                style={{ width: '100%', padding: '14px', background: '#111', border: '1px solid #222', borderRadius: '10px', color: '#fff', fontSize: '1rem' }}
              />
            </div>

            <button onClick={handleSubmit} style={{ 
              padding: '16px 40px', background: '#00d4ff', border: 'none', 
              borderRadius: '12px', color: '#000', fontWeight: '600', fontSize: '1.1rem', cursor: 'pointer'
            }}>
              Finish Setup →
            </button>
          </div>
        )}
      </div>
    </div>
  )
}
