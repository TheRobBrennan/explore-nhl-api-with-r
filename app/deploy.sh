# Assuming you are on a machine that can SSH into root@161.35.228.138

# Use rsync to copy and deploy my local files to the remote server
# Exclude virtual environment, cache, and other unnecessary directories
rsync -av --exclude .venv --exclude .ipynb_checkpoints --exclude __pycache__ fastapi root@161.35.228.138:/root
