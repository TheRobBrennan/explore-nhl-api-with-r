# Install pip3 for Python libraries
echo Installing pip for Python 3...
sudo apt update
sudo apt install python3-pip --yes
pip3 --version

# Install Python virtual environment
sudo apt install python3.10-venv --yes

# Install Radian - A 21st Century R console - https://github.com/randy3k/radian - https://pypi.org/project/radian/
echo Installing Radian...
pip3 install -U radian

# Install languageserver - https://search.r-project.org/CRAN/refmans/languageserver/html/languageserver-package.html
# An implementation of the Language Server Protocol for R. The Language Server protocol is used by an editor client to integrate features like auto completion.
echo Installing R languageserver...
R -e 'install.packages("languageserver")'

echo Installation complete.
