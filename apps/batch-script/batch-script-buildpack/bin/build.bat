@echo off
echo --- Batch script buildpack

:: 1. INPUT ARGUMENTS
set layers_dir=%1

:: 2. SET DEFAULT START COMMAND
(
echo [[processes]]
echo type = "web"
echo command = "app.bat"
) >> %layers_dir%\launch.toml

:: LIST CONTENTS
echo --- Hello Batch Script buildpack
echo 
echo Here are the contents of the current working directory:
dir /q /s
