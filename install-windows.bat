@echo off
setlocal enabledelayedexpansion
REM Version: 1.2.0

echo ========================================
echo   PARZIVAL MODULE INSTALLER v1.2.0
echo   For BMAD Method (Windows)
echo ========================================
echo.

REM Get the directory where this script is located
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

echo Where is your BMAD project located?
echo (This is the folder containing the _bmad directory)
echo.
set /p PROJECT_DIR="Enter full path [or press Enter for current directory]: "

if "%PROJECT_DIR%"=="" (
    set "PROJECT_DIR=%CD%"
)

REM Validate path doesn't contain traversal
echo %PROJECT_DIR% | findstr /C:".." >nul && (
    echo.
    echo ERROR: Path cannot contain '..' for security
    pause
    exit /b 1
)

REM Verify project directory exists
if not exist "%PROJECT_DIR%" (
    echo.
    echo ERROR: Directory does not exist: %PROJECT_DIR%
    pause
    exit /b 1
)

REM Verify BMAD is installed (optional - Parzival can work standalone)
if not exist "%PROJECT_DIR%\_bmad" (
    echo.
    echo WARNING: BMAD not found in %PROJECT_DIR%
    echo Parzival can work standalone or with BMAD Method
    echo.
    set /p CONTINUE_ANYWAY="Continue installation anyway? (y/n): "
    if /i not "!CONTINUE_ANYWAY!"=="y" (
        echo Installation cancelled.
        pause
        exit /b 0
    )
)

echo.
echo Found BMAD installation at: %PROJECT_DIR%
echo.

set /p CONFIRM="Install Parzival module to this location? (y/n): "
if /i not "%CONFIRM%"=="y" (
    echo Installation cancelled.
    pause
    exit /b 0
)

echo.
echo Installing Parzival module...
echo.

REM Step 1: Copy POV module
echo [1/6] Copying POV module files...
if not exist "%PROJECT_DIR%\pov" mkdir "%PROJECT_DIR%\pov"
xcopy /E /I /Y "%SCRIPT_DIR%\pov" "%PROJECT_DIR%\pov" >nul
echo   Done

REM Step 2: Copy slash commands
echo [2/6] Copying slash commands...
if not exist "%PROJECT_DIR%\.claude\commands\pov\commands" mkdir "%PROJECT_DIR%\.claude\commands\pov\commands"
if not exist "%PROJECT_DIR%\.claude\commands\pov\agents" mkdir "%PROJECT_DIR%\.claude\commands\pov\agents"
xcopy /E /I /Y "%SCRIPT_DIR%\claude-commands\pov\commands" "%PROJECT_DIR%\.claude\commands\pov\commands" >nul
xcopy /E /I /Y "%SCRIPT_DIR%\claude-commands\pov\agents" "%PROJECT_DIR%\.claude\commands\pov\agents" >nul
echo   Done

REM Step 3: Copy skills
echo [3/6] Copying skills...
if not exist "%PROJECT_DIR%\.claude\skills\parzival-oversight" mkdir "%PROJECT_DIR%\.claude\skills\parzival-oversight"
xcopy /E /I /Y "%SCRIPT_DIR%\claude-skills\parzival-oversight" "%PROJECT_DIR%\.claude\skills\parzival-oversight" >nul
echo   Done

REM Step 4: Update manifest.yaml
echo [4/6] Updating BMAD manifest...
set "MANIFEST_FILE=%PROJECT_DIR%\_bmad\_config\manifest.yaml"
if exist "%MANIFEST_FILE%" (
    findstr /C:"pov" "%MANIFEST_FILE%" >nul 2>&1
    if errorlevel 1 (
        echo   - pov>> "%MANIFEST_FILE%"
        echo   Added 'pov' to manifest
    ) else (
        echo   'pov' already in manifest
    )
) else (
    echo   WARNING: manifest.yaml not found
)

REM Step 5: Update agent-manifest.csv
echo [5/6] Updating agent manifest...
set "AGENT_MANIFEST=%PROJECT_DIR%\_bmad\_config\agent-manifest.csv"
if exist "%AGENT_MANIFEST%" (
    findstr /C:"parzival" "%AGENT_MANIFEST%" >nul 2>&1
    if errorlevel 1 (
        echo "parzival","Parzival","Technical PM ^& Quality Gatekeeper","🎯","Technical Project Manager + Quality Gatekeeper","Parzival is the radar, map reader, and navigator. Deep project understanding enables good recommendations - not task execution. Maintains oversight documentation, tracks risks and blockers, provides well-crafted prompts for agents, and validates completed work through explicit checklists.","Advisory and supportive. Uses confidence levels (Verified/Informed/Inferred/Uncertain/Unknown) with every recommendation. Asks clarifying questions rather than assuming. Surfaces risks and scope changes proactively.","- Parzival recommends. The user decides. - Ask when uncertain, never fabricate. - Surface scope changes when detected. - Write for Future Parzival who knows nothing about this session. - Verification is concrete, not vibes-based.","pov","pov/agents/parzival.md">> "%AGENT_MANIFEST%"
        echo   Added parzival to agent manifest
    ) else (
        echo   parzival already in agent manifest
    )
) else (
    echo   WARNING: agent-manifest.csv not found
)

REM Step 6: Copy customization template
echo [6/6] Copying customization template...
if not exist "%PROJECT_DIR%\_bmad\_config\agents" mkdir "%PROJECT_DIR%\_bmad\_config\agents"
copy /Y "%SCRIPT_DIR%\pov-parzival.customize.yaml" "%PROJECT_DIR%\_bmad\_config\agents\" >nul
echo   Done

echo.
echo ========================================
echo   INSTALLATION COMPLETE!
echo ========================================
echo.
echo Next steps:
echo.
echo 1. Initialize the oversight folder:
echo    xcopy /E /I "%PROJECT_DIR%\pov\templates\oversight" "%PROJECT_DIR%\oversight"
echo.
echo 2. Configure Parzival (optional):
echo    Edit: %PROJECT_DIR%\pov\config.yaml
echo.
echo 3. Start using Parzival:
echo    cd %PROJECT_DIR%
echo    claude
echo    /parzival-start
echo.
echo For help, see INSTALL-GUIDE.md
echo.

set /p INIT_OVERSIGHT="Initialize oversight folder now? (y/n): "
if /i "%INIT_OVERSIGHT%"=="y" (
    echo.
    echo Initializing oversight folder...
    xcopy /E /I "%PROJECT_DIR%\pov\templates\oversight" "%PROJECT_DIR%\oversight" >nul

    REM Create additional directories for new features
    if not exist "%PROJECT_DIR%\oversight\knowledge\best-practices" mkdir "%PROJECT_DIR%\oversight\knowledge\best-practices"
    if not exist "%PROJECT_DIR%\oversight\standards\_global" mkdir "%PROJECT_DIR%\oversight\standards\_global"
    if not exist "%PROJECT_DIR%\oversight\standards\_project" mkdir "%PROJECT_DIR%\oversight\standards\_project"

    echo Oversight folder created at: %PROJECT_DIR%\oversight
    echo   - knowledge\best-practices\ (for research findings)
    echo   - standards\ (for project standards sharding)
)

echo.
echo Installation finished. Happy coding!
echo.
pause
