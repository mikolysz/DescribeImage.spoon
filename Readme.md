# DescribeImage

This is a Hammerspoon extension that can describe images with the OpenAI Vision API. The extension is intended for Voice Over users, it grabs images from under the voice over cursor and speaks them with Voice Over. A custom OpenAI API key with GPT-4 access is required.

## Limitations

The Spoon generates the image descriptions using Transformer-based Large language models, which are prone to generating plausibly-sounding but wildly inaccurate text. These models often make up details that actually aren't in the image, recognize text in a way that makes grammatical sense but is very different from what's actually presented etc. Treat those descriptions as if they came from a compulsive liar.

Image recognition is performed by grabbing a screenshot of the part of the screen taken by the focused item. This means that, if the item is covered by any notifications, pop-ups or windows from other applications, those windows will be included as part of the screenshot and may obscure some of the content to be described. This limitation is particularly problematic for users residing in Europe, who often have to deal with cookie consent forms that aren't otherwise noticeable for a screen-reader user, they usually appear either at the top or the bottom of the page. Other pop-ups can usually be dismissed by pressing VO+f2 twice and finding them as system dialogs. In the worst-case scenario, you can also try recognizing the screen contents with VOCR and clicking somewhere within the pop-up to focus it.

## Installation

1. Install Hammerspoon
2. Install this spoon (by cloning the repo and double-clicking on it in the Finder).
3. Find "Hammerspoon" in your menu extras and click "Open Config". In the file that appears, paste the following two lines:
  ```lua
  hs.loadSpoon("DescribeImage")
  spoon.DescribeImage:start("PUT_YOUR_OPENAI_API_KEY_HERE")
  ```
4. In the Hammerspoon menu, click "reload config"


## Usage

Move to an image to be described with the Voice Over cursor and press ctrl+shift+d. You will hear "grabbing screenshot." After the description is finished, it will be spoken automatically. You can copy the description for further review with VO+shift+c. If the description is interrupted by a notification and you'd like to hear it again, get my SpeechHistory spoon and review it from there.

## Roadmap

- [x] Grab contents of VO cursor
- [x] Describe images with Open AI
- [x] speak descriptions using Voice Over
- [ ] play a sound during image processing
- [ ] Provide image descriptions in the user's system language instead of always defaulting to English
- [ ] Let the user ask clarifying questions
- [ ] Allow adding more images to the conversation
- [ ] Ability to recognize the window or the whole screen.
- [ ] Allow changing the initial prompt.
