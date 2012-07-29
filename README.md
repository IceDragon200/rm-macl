## RGSS3-MACL
### Intro
The RGSS3-MACL is designed to bring everyday used functions and expand
on the base RGSS3 classes for RMVXAce, some classes found in the MACL
can be used outside of RM, such as many of the build_tools
and the StandardLibEx.
All files found in the lib are auto-generated, and should be used
with caution.

### USE
Simply copy the rgss3_macl.rb into your project script editor.
Place the script below materials; and above main and all other scripts.

### DEV
To build a fresh copy of the rgss3_macl.rb run the build_macl.bat

###TODO
Test all scripts, and ensure that they can work standalone (if possible).
Actually write some form of documentation.
Add proper file tracking to Skinj for debugging purposes.

###CHANGES
lib/ is no longer included.
all builds can be found in the builds/
edos_* builds have 1 minor difference:
```
  Game_* are Game::*
  Window_* are Window::*
  Scene_* are Scene::*
  Sprite_* are Sprite::
``` 
