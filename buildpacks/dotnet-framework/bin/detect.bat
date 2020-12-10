@echo off

set plan_path=%2

if exist c:\workspace\*.sln (
    (
    echo [[requires]]
    echo name = "dotnet-framework"

    echo [[provides]]
    echo name = "dotnet-framework"
    ) >> %plan_path%

    echo Detection PASSED
    exit 0
)
