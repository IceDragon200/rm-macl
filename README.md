RGSS3-MACL
==========

## Intro
The RGSS3-MACL is designed to bring everyday used functions and expand
on the base RGSS3 classes for RMVXAce, some classes found in the MACL
can be used outside of RM, such as many of the build_tools
and the std-lib-ex.
All files found in the lib are auto-generated, and should be used
with caution, since they may contain syntax errors.

## FUTURE PLANS
```
Patch to work with RGSS2 and RMGosu (by CaptainJet)
```
## FEATURES
Various scripts

## USE
The MACL has many uses
### _path-*_
```
If you wish to take advantage of certain scripts in the MACL such as Skinj and Skrip.
You can add the _path-*_ to your PATH variable use the commands from your console/terminal.
* is your platform, win for Windows, and nix for Linux and Mac (but why would you being using those?)
```

### Option 1
require the scripts from the src folder, after you've placed the macl into a nice comfy location.

### Option 2
```
If you need everything, like myself then you can use 'require macl_local.rb'
Some scripts may fail to load due to certain dependencies.
I'm working as fast as I can to fix them
```

### Option 3
```
build the macl using skinj and copy the output file, (usually around 2000 lines)

If your using RPG Maker VX Ace:
Place the script below materials; and above main and all other scripts.
```

## DEV
Depending on your platform, you'll need to use either the _win_ or _linux_ builders

## TODO
```
1 . Test all scripts, and ensure that they can work standalone (if possible).
2 . Actually write some form of documentation.
3 . Add proper file tracking to Skinj for debugging purposes.
4 . Finish the _path-win_ commands.
```

## CHANGES
lib/ is no longer included. All builds can be found in the builds/ directory.
edos_* builds have 1 minor difference:
```
  Game_* are Game::*
  Window_* are Window::*
  Scene_* are Scene::*
  Sprite_* are Sprite::
``` 
In short EDOS builds use namespaces or modules instead of naming conventions.
