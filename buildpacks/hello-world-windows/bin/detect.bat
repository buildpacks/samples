@echo off

:: 1. GET ARGS
set plan_path=%2

:: 2. DECLARE DEPENDENCIES (OPTIONAL)
echo [[provides]] >> %plan_path%
echo name = "some-world" >> %plan_path%

echo [[requires]] >> %plan_path%
echo name = "some-world" >> %plan_path%
exit /b 0
