a bunch of bash functions for 18648

Add the following lines into your bashrc

DIRECTORY="embedded_scripts"
if [ ! -d "$DIRECTORY" ]; then
    echo "here"
    git clone https://github.com/mbremner322/embedded_scripts.git
fi
cd "$DIRECTORY"
git pull
source embedded_script.sh
cd

