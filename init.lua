local inspect = hs.inspect
local ax = require("hs.AXUIElement")
local apiKey

local describeImage={}

local prompt = [[
Describe this image. If the image only contains text, just give me the text without describing the formatting. Focus on what's shown, don't try to provide context. Be brief but detailed.
]]

describeImage.name="Describe Image"
describeImage.version=1.0
describeImage.author="Mikolaj Holysz <miki123211@gmail.com>"
describeImage.license="MIT"

local grabScreenshotScript = [[
tell application "VoiceOver"
	grab screenshot of vo cursor
end tell
]]

local speakScript = [[
tell application "VoiceOver"
	output "MESSAGE"
end tell
]]

local function grabScreenshot()
    success, result, output = hs.osascript.applescript(grabScreenshotScript)
    if not success then
        print(inspect(output))
    end
    return output
end

local function speak(text)
    -- We can't pass the supplied message to string.gsub directly,
    -- because gsub uses '%' characters in the replacement string for capture groups
    -- and we can't guarantee that our message doesn't contain any of those.

    local script = speakScript:gsub("MESSAGE", function ()
        return text
    end)

    success, _, output = hs.osascript.applescript(script)
    if not success then
        print(inspect(output))
    end

    -- We don't want the phrase that we just read to be appended to the history buffer again.
end

local function describe()
    local path = grabScreenshot()
    -- path format: 'utxt'("actual_path")
    path = path:sub(9, -3)
    local file = io.open(path, "rb")
    local contents = file:read("a") -- Read the whole file
    file:close()
    -- Hammerspoon doesn't seem to have a function for this.
    hs.execute("rm '" .. path .. "'")
    contents = hs.base64.encode(contents)
    local payload = {
        model = "gpt-4-vision-preview",
        messages = {
            {
                role = "user",
                content = {
                    {
                        type = "text",
                        text = prompt,
                    },
                    {
                        type = "image_url",
                        image_url = {
                            url = "data:image/jpeg;base64," .. contents
                        }, -- url
                    }, -- content
                }, -- contents
            }, -- message
        }, -- messages
        max_tokens = 1000
    } -- payload
    payload = hs.json.encode(payload)
    url = "https://api.openai.com/v1/chat/completions"
    print(inspect(apiKey))
    headers = {
        ["Content-Type"] = "application/json",
        Authorization = "Bearer " .. apiKey
    }
    hs.http.asyncPost(url, payload, headers, function(code, body, _)
        if code ~= 200 then
            speak("error: " .. body)
            return
        end
        body = hs.json.decode(body)
        local text = body.choices[1].message.content
        text = text:gsub("[\"\n]", " ")
        print(text)
        speak(text)
    end)
end

local hotkey = hs.hotkey.new("ctrl-shift", "d", describe)

function describeImage.init()
end

function describeImage.start(_self, apikey)
    hotkey:enable()
    apiKey = apikey
end

function describeImage.stop()
    hotkey:disable()
end

return describeImage