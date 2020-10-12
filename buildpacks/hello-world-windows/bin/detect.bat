@echo off

:: 1. GET ARGS
set plan_path=%2

:: 2. DECLARE DEPENDENCIES (OPTIONAL)
(
echo [[provides]]
echo name = "some-world"

echo [[requires]]
echo name = "some-world"
) >> %plan_path%

exit /b 0
