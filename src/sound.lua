local Sound = {}

local function generatePattern(notes, sampleRate, waveform, volume)
    -- notes: { {freq, duration}, ... }  -- freq 0 = silence
    sampleRate = sampleRate or 44100
    waveform = waveform or "square"
    volume = volume or 0.15

    local totalSamples = 0
    local noteSamples = {}
    for _, note in ipairs(notes) do
        local samples = math.floor(note[2] * sampleRate)
        table.insert(noteSamples, samples)
        totalSamples = totalSamples + samples
    end

    local data = love.sound.newSoundData(totalSamples, sampleRate, 16, 1)
    local pos = 0

    for i, note in ipairs(notes) do
        local freq = note[1]
        local samples = noteSamples[i]
        for s = 0, samples - 1 do
            local amp = 0
            if freq > 0 then
                local t = s / sampleRate
                if waveform == "square" then
                    local phase = (t * freq) % 1
                    amp = phase < 0.5 and 1 or -1
                else
                    amp = math.sin(t * freq * 2 * math.pi)
                end
            end

            local envelope = 1
            local attack = math.min(500, samples / 8)
            local release = math.min(500, samples / 8)
            if s < attack then
                envelope = s / attack
            elseif s > samples - release then
                envelope = (samples - s) / release
            end

            data:setSample(pos, amp * envelope * volume)
            pos = pos + 1
        end
    end

    return love.audio.newSource(data, "static")
end

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

    -- Retro background loop: C minor arpeggio (C3, Eb3, G3, Bb3)
    local musicNotes = {
        {130.81, 0.40}, {0, 0.15},
        {155.56, 0.40}, {0, 0.15},
        {196.00, 0.40}, {0, 0.15},
        {233.08, 0.40}, {0, 0.15},
    }
    Sound.music = generatePattern(musicNotes, 44100, "square", 0.12)
    Sound.music:setLooping(true)
end

function Sound.playMusic()
    if Sound.music and Sound.music:isPlaying() == false then
        Sound.music:play()
    end
end

function Sound.stopMusic()
    if Sound.music then
        Sound.music:stop()
    end
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
