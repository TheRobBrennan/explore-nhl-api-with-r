import pandas as pd

import io
import matplotlib
matplotlib.use('AGG')
import matplotlib.pyplot as plt

from fastapi import FastAPI, Response, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware 
import uvicorn 

app = FastAPI()

# To avoid any CORS problems when using the API, we will additionally integrate CORS Middleware
origins = ['*']
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
) 

# Our default route
@app.get("/")
async def root():
    return {"message": "Hello from FastAPI"} 

# Documentation for our FastAPI can be found at http://127.0.0.1:8000/docs
# OpenAPI documentation for our FastAPI can be found at http://127.0.0.1:8000/redoc
@app.get("/my-first-api")
def hello(name = None):

    if name is None:
        text = 'Hello!'

    else:
        text = 'Hello ' + name + '!'

    return text

@app.get("/get-iris")
def get_iris():
    # When it comes to “normal” objects, like a DataFrame, FastAPI will convert it directly to a JSON file.
    url ='https://gist.githubusercontent.com/curran/a08a1080b88344b0c8a7/raw/0e7a9b0a5d22642a06d3d5b9bcbad9890c8ee534/iris.csv'
    iris = pd.read_csv(url)

    return iris

@app.get("/plot-iris")
def plot_iris(background_tasks: BackgroundTasks):

    img_buf = create_iris_image_buffer()
    background_tasks.add_task(img_buf.close)
    headers = {'Content-Disposition': 'inline; filename="out.png"'}
    return Response(img_buf.getvalue(), headers=headers, media_type='image/png')

def create_iris_image_buffer():
    url ='https://gist.githubusercontent.com/curran/a08a1080b88344b0c8a7/raw/0e7a9b0a5d22642a06d3d5b9bcbad9890c8ee534/iris.csv'
    iris = pd.read_csv(url)

    # Create a 750px x 350px plot
    plt.rcParams['figure.figsize'] = [7.50, 3.50]
    plt.rcParams['figure.autolayout'] = True
    fig = plt.figure()  # make sure to call this, in order to create a new figure
    img_buf = io.BytesIO()
    plt.scatter(iris['sepal_length'], iris['sepal_width'])
    plt.savefig(img_buf, format='png')
    plt.close(fig)
    return img_buf

# For local development, our API should be available at http://localhost:8000
if __name__ == "__main__":
    uvicorn.run(app, host='0.0.0.0', port=8000)
