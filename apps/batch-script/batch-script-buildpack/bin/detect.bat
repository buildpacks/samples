@echo off

:: 1. CHECK IF APPLICABLE
if not exist app.bat (
   exit /b 100
)

:: LIST CONTENTS
echo --- Hello Batch Script buildpack
echo 
echo Here are the contents of the current working directory:
dir /q /s
