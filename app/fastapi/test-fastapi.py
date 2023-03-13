# For the best experience, view this file in an interactive window instead of simply running at the command line.
# You will be able to see the example image returned from the plot-iris endpoint, etc.
import requests
from PIL import Image
import io

# Assuming you have your API server already running
resp = requests.get('http://127.0.0.1:8000/plot-iris')
file = io.BytesIO(resp.content)
im = Image.open(file)
im.show()

# Let's try the original endpoint using the name query parameter
resp = requests.get('http://127.0.0.1:8000/my-first-api?name=Rob')
print(resp.text)
