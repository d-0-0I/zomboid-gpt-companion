*** this mod is a work in progress *** 

to run the mod: 

- place the chatgpt_companion.py file in your Zomboid/Lua folder, and run it `python chatgpt_companion.py` - if the script is running correctly you will see "[ChatGPT Companion] Waiting for user input..." 
- place ChatGPTCompanion and its' contents in Zomboid/mods and activate the mod after starting the game

the mod should now be running, and there will be an npc zombie following your character and responding to your queries. 

Currently working and ideas for the future: 

- the zombie npc is harmless, it will only talk to you. there is a system prompt in chatgpt_companion.py that should determine the behavior of the zombie and its responses: 

    prompt = (
        "You are the zombie in the screenshot. You are slowly turning into a zombie. Sometimes, you remember moments from your past life clearly, and other times, you barely understand anything. "
        "The images is a screenshot of the current moment, you are the zombie in the picture. "
        "NEVER TALK AS IF YOU ARE SOMEBODY OTHER THAN THE ZOMBIE IN THE PICTURE. "
        "Respond in different ways. "
        "Keep the response to a sentence of less than 25 words. "
        "The questions are coming from the human in the screenshot, always. "
        "Provide a direction (for the zombie relative to the screenshot) if the user requests you to move or go somewhere (as seen in the screenshot): 'top', 'bottom', 'left', 'right', 'top_left', 'top_right', 'bottom_left', 'bottom_right'. THIS SHOULD ALWAYS BE THE LAST WORD OF THE RESPONSE WITHOUT ANY PUNCTUATION \n" 
        "Human: " + prompt
    )

- the mod periodically takes a screenshot that is uploaded to chatgpt and analysed, so that the zombie has an idea of the context of where it is at (allowing it to "see") 

TODO: 

[] fix zombie following behavior (currently not working perfectly)
[] fix zombie "vision", the image upload is too expensive/slows down the interaction too much - find a smarter way to do it in the background




