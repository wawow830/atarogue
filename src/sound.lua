local Sound = {}

local function generateTone(duration, freq, sampleRate, waveform)
    sampleRate = sampleRate or 44100
    waveform = waveform or "sine"
    local samples = math.floor(duration * sampleRate)
    local data = love.sound.newSoundData(samples, sampleRate, 16, 1)
    for i = 0, samples - 1 do
        local t = i / sampleRate
        local amp
        if waveform == "square" then
            local phase = (t * freq) % 1
            amp = phase < 0.5 and 1 or -1
        elseif waveform == "noise" then
            amp = math.random() * 2 - 1
        else
            amp = math.sin(t * freq * 2 * math.pi)
        end
        -- Simple attack/release envelope to avoid popping
        local envelope = 1
        local attack = math.min(1000, samples / 10)
        local release = math.min(1000, samples / 10)
        if i < attack then
            envelope = i / attack
        elseif i > samples - release then
            envelope = (samples - i) / release
        end
        data:setSample(i, amp * envelope * 0.5)
    end
    return love.audio.newSource(data, "static")
end

local function generateDescent(duration, startFreq, endFreq, sampleRate)
    sampleRate = sampleRate or 44100
    local samples = math.floor(duration * sampleRate)
    local data = love.sound.newSoundData(samples, sampleRate, 16, 1)
    for i = 0, samples - 1 do
        local t = i / sampleRate
        local progress = t / duration
        local freq = startFreq + (endFreq - startFreq) * progress
        local amp = math.sin(t * freq * 2 * math.pi)
        local envelope = 1
        local attack = math.min(1000, samples / 10)
        local release = math.min(2000, samples / 5)
        if i < attack then
            envelope = i / attack
        elseif i > samples - release then
            envelope = (samples - i) / release
        end
        data:setSample(i, amp * envelope * 0.5)
    end
    return love.audio.newSource(data, "static")
end

function Sound.load()
    -- Short square-wave beep for ball bounce
    Sound.bounce = generateTone(0.08, 440, 44100, "square")
    -- Crisp higher beep for brick break
    Sound.brick = generateTone(0.12, 880, 44100, "square")
    -- Descending tone for game over
    Sound.gameover = generateDescent(0.5, 220, 55, 44100)
end

function Sound.playBounce()
    if Sound.bounce then
        Sound.bounce:stop()
        Sound.bounce:play()
    end
end

function Sound.playBrick()
    if Sound.brick then
        Sound.brick:stop()
        Sound.brick:play()
    end
end

function Sound.playGameOver()
    if Sound.gameover then
        Sound.gameover:stop()
        Sound.gameover:play()
    end
end

return Sound
