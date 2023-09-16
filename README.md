# RaylibTemplate
A simple and easy-to-use template for Raylib
Prerequisites
---
**Template based on [Raysan5's](https://github.com/raysan5) C99 Library [raylib 4.5](https://github.com/raysan5/raylib/releases/tag/4.5.0)**

Download the Raylib and install as you like. Remember to change the Paths inside the ``.vscode``-Folder.

***NOTE: Build currently only supported on Windows (Linux support comming soon)***

Windows
---
Just install raylib using the [Installer](https://github.com/raysan5/raylib/releases/download/4.5.0/raylib_installer_v4.5.mingw.64bit.exe) and install it at the recommended Path.

```
C:/raylib
```
Otherwise you need to change the paths in the ``.vscode``-Folder.

Linux (Ubuntu|Debian)
---
Just run a few Commands the rest is Setup in the Makefile of the Template.

```
# Install Build-Essentials and git if nessesary
> sudo apt install build-essential git

# Install required libraries 
> sudo apt install libasound2-dev libx11-dev libxrandr-dev libxi-dev libgl1-mesa-dev libglu1-mesa-dev libxcursor-dev libxinerama-dev

# Clone the Raylib Repository
git clone https://github.com/raysan5/raylib.git raylib

# CD into the Repo and make ist with the PLATFORM=PLATFORM_DESKTOP attrib
cd raylib/src/
make PLATFORM=PLATFORM_DESKTOP

# Install using make and it is Done
sudo make install
```
