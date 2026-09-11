@echo off
rem Launch Godot project. Adjust GODOT_EXE if your install path differs.
set GODOT_EXE=godot
if exist "C:\Users\admin\tools\Godot_v4.4.1-stable_win64.exe" (
  set GODOT_EXE=C:\Users\admin\tools\Godot_v4.4.1-stable_win64.exe
)
set PROJECT_DIR=%~dp0
"%GODOT_EXE%" --path "%PROJECT_DIR%"
