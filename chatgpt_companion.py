import openai
import time
import os
import base64
from pathlib import Path

# Set up the OpenAI API key
client = openai.OpenAI(
    api_key="YOUR_CHATGPT_API_KEY"
)

# Paths to input and output files
USER_INPUT_FILE = './user_input.txt'
RESPONSE_FILE = './response.txt'
SCREENSHOT_FILE = '../Screenshots/pzscreenshot.png'

# Function to read user input from the file
def read_user_input():
    if os.path.exists(USER_INPUT_FILE):
        with open(USER_INPUT_FILE, 'r') as file:
            user_input = file.readline().strip()
            if user_input:
                # Clear the input file after reading
                open(USER_INPUT_FILE, 'w').close()
                return user_input
    return None

# Function to write the response to the file
def write_response(response):
    with open(RESPONSE_FILE, 'w') as file:
        file.write(response)

# Function to get response from ChatGPT
# This function will also parse the response for directional commands
def get_chatgpt_response(prompt):
    prompt = (
        "You are the zombie in the screenshot. You are slowly turning into a zombie. Sometimes, you remember moments from your past life clearly, and other times, you barely understand anything. "
        "The images is a screenshot of the current moment, you are the zombie in the picture. "
        "NEVER TALK AS IF YOU ARE SOMEBODY OTHER THAN THE ZOMBIE IN THE PICTURE. "
        # "You used to be a comedian, sometimes you make jokes. "
        "Respond in different ways. "
        "Keep the response to a sentence of less than 25 words. "
        "The questions are coming from the human in the screenshot, always. "
        "Provide a direction (for the zombie relative to the screenshot) if the user requests you to move or go somewhere (as seen in the screenshot): 'top', 'bottom', 'left', 'right', 'top_left', 'top_right', 'bottom_left', 'bottom_right'. THIS SHOULD ALWAYS BE THE LAST WORD OF THE RESPONSE WITHOUT ANY PUNCTUATION \n" 
        "Human: " + prompt
    )
    try:
        with open(SCREENSHOT_FILE, "rb") as image_file:
            img_b64_str = base64.b64encode(image_file.read()).decode('utf-8')
            img_type = "image/png"
        
        chat_completion = client.chat.completions.create(
            messages=[
                {
                    "role": "user",
                    "content": [
                        {"type": "text", "text": prompt},
                        {
                            "type": "image_url",
                            "image_url": {
                                "url": f"data:{img_type};base64,{img_b64_str}"
                            }
                        }
                    ]
                }
            ],
            model="gpt-4o-mini"
        )
        response_text = chat_completion.choices[0].message.content.strip()
        print('RESPONSE!!!!--->>', response_text)
        return response_text
    except Exception as e:
        print(f"Error getting response from ChatGPT: {e}")
        return "I couldn't process that, please try again."

# Main loop to keep checking for new user input
def main():
    print("[ChatGPT Companion] Waiting for user input...")
    while True:
        user_input = read_user_input()
        if user_input:
            print(f"[ChatGPT Companion] User input received: {user_input}")
            response = get_chatgpt_response(user_input)
            print(f"[ChatGPT Companion] Response from ChatGPT: {response}")
            write_response(response)
        time.sleep(1)  # Check for new input every second

if __name__ == "__main__":
    main()