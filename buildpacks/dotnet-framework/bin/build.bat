@echo off

set env_dir=%2\env
set layers_dir=%1
set plan_path=%$3

set launch_toml_path=%layers_dir%\launch.toml
set layer_toml_path=%layers_dir%\dotnet-framework.toml
set layer_path=%layers_dir%\dotnet-framework
set publish_path=%TEMP%\publish

if not exist %layer_path% (
    mkdir %layer_path%
)

if not exist %layer_toml_path% (
    (
    echo [types]
    echo launch = false
    echo build = true
    echo cache = true
    ) > %layer_toml_path%
)

if not exist %publish_path% (
    mkdir %publish_path%
)

set NUGET_PACKAGES=%layer_path%

nuget restore
if %ERRORLEVEL% NEQ 0 (
    exit /b %ERRORLEVEL%
)

MSBuild /t:Rebuild /p:Configuration=Debug
if %ERRORLEVEL% NEQ 0 (
    exit /b %ERRORLEVEL%
)

(
echo [[processes]]
echo type = "web"
echo command = ["C:\\ServiceMonitor.exe", "w3svc"]
) >> %launch_toml_path%
