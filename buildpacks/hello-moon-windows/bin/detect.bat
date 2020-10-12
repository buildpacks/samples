@echo off

:: 1. GET ARGS
set plan_path=%2

:: 2. DECLARE DEPENDENCIES (OPTIONAL)
(
echo [[requires]]
echo name = "some-world"
echo version = "0.1"

echo [requires.metadata]
echo world = "Earth-616"
) >> %plan_path%

exit /b 0
