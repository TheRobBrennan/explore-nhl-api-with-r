# Welcome
Let's refer to the `How to create an API in Python with FastAPI` section in the blog post [How to create an API in Python](https://anderfernandez.com/en/blog/how-to-create-api-python/) as a starting point.

## Local development

### Install dependencies and run our project

```sh
# Make sure you are in the FastAPI directory
(.venv) % cd fastapi

# Verify that you have Python installed on your machine
% python3 --version

# Create a new virtual environment for the project
% python3 -m venv .venv

# Select your new environment by using the Python: Select Interpreter command in VS Code
#   - Enter the path: ./.venv/bin/python

# Activate your virtual environment
% source .venv/bin/activate
(.venv) %

# PREFERRED: Install the packages from requirements.txt
(.venv) % pip install -r requirements.txt

# Let's start our FastAPI server - Available at http://127.0.0.1:8000/
(.venv) % uvicorn main:app --reload

# -------------------------------------------------------------------------------------- #
# REFERENCE DOCUMENTATION
# -------------------------------------------------------------------------------------- #
# Install Python packages in a virtual environment
(.venv) % pip install fastapi
(.venv) % pip install uvicorn
(.venv) % pip install pandas
(.venv) % pip install matplotlib
(.venv) % pip install requests
(.venv) % pip install gunicorn
(.venv) % pip install requests

# When you are ready to generate a requirements.txt file
(.venv) % pip freeze > requirements.txt

# What happens if you want to uninstall a package?

# Uninstall the package from your virtual environment
# (.venv) % pip uninstall simplejson

# Remove the dependency from requirements.txt if it exists
# (.venv) % pip uninstall -r requirements.txt

```
