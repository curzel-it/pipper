"""
Launches a script that logs volume levels and exposes it to localhost:8889 as a simple web page.
"""

import time
import threading
import numpy as np
import sounddevice as sd
from flask import Flask, jsonify, render_template_string

app = Flask(__name__)

volume_level = 0

html_template = """
<!DOCTYPE html>
<html>
<head>
    <title>Microphone Volume Levels</title>
    <meta http-equiv="refresh" content="0.5">
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 50px;
        }
        h1 {
            font-size: 2em;
        }
        .volume {
            font-size: 4em;
            color: #007BFF;
        }
    </style>
</head>
<body>
    <h1>Current Microphone Volume Level</h1>
    <div class="volume">{{ volume }}</div>
</body>
</html>
"""

def capture_microphone_audio():
    global volume_level

    def audio_callback(indata, frames, time, status):
        global volume_level
        if status: print(status)
        rms = np.sqrt(np.mean(indata**2))
        volume_level = int(rms * 1000) 

    with sd.InputStream(callback=audio_callback, channels=1, samplerate=44100):
        while True:
            time.sleep(0.1)

@app.route('/')
def index():
    return render_template_string(html_template, volume=volume_level)

if __name__ == '__main__':
    audio_thread = threading.Thread(target=capture_microphone_audio, daemon=True)
    audio_thread.start()
    app.run(host='0.0.0.0', port=8889)
