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

xcopy c:\cnb\buildpacks\hello-moon-windows\0.0.1\bin\launch.toml %layers_dir%\launch.toml

xcopy c:\cnb\buildpacks\hello-moon-windows\0.0.1\bin\sys-info.toml %layers_dir%\sys-info.toml
md %layers_dir%\sys-info

xcopy c:\cnb\buildpacks\hello-moon-windows\0.0.1\bin\sys-info.bat %layers_dir%\sys-info\sys-info.bat
xcopy c:\cnb\buildpacks\hello-moon-windows\0.0.1\bin\sys-info.bat %layers_dir%\sys-info\sys-info-args.bat
xcopy c:\cnb\buildpacks\hello-moon-windows\0.0.1\bin\sys-info.bat %layers_dir%\sys-info\sys-info-direct.bat

echo --- Done
