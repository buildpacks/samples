@echo off

echo --- Hello Moon buildpack

set env_dir=%2\env
set layers_dir=%1
set plan_path=%3

echo      env_dir: %env_dir%
echo      env_vars:
for /f "tokens=*" %%f in ('dir /s /q /b %env_dir%') do (
  for /f %%v in ('type %%f') do (
    set %%~nf=%%v
  )
)
for /f "tokens=*" %%o in ('set') do (
    echo        %%o
)

echo      layers_dir: %layers_dir%
echo      plan_path: %plan_path%
echo      plan contents:
for /f "tokens=*" %%o in ('type %plan_path%') do (
    echo        %%o
)

echo --- Done
