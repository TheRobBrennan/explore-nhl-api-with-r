# Activate the virtual environment
source .venv/bin/activate

# Install the packages from requirements.txt into the selected virtual environment
pip install -r requirements.txt

# Start our FastAPI server
./start.sh
