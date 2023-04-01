import os
import sys

# Construct the path to the subdirectory containing the module
nhl_module_path = os.path.join(os.path.dirname(__file__), 'nhl')

# Add the subdirectory path to the system path
sys.path.append(nhl_module_path)

# Import the module from the subdirectory
from nhl import say_hello

# Call the function from the module
say_hello()
