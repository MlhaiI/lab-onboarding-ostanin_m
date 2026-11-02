@echo off
chcp 65001
REM =============================================
REM Практическая работа: Диагностика ПК
REM Фамилия: [Ваша Фамилия]
REM Дата: %date%
REM =============================================

set "report=%~dp0pc_report.txt"

REM Очистка или создание нового отчёта
if exist "%report%" del "%report%"
echo Диагностика компьютера > "%report%"
echo ===================== >> "%report%"
echo. >> "%report%"

:log
echo %~1
echo %~1 >> "%report%"
exit /b

call :log "=== ОПЕРАЦИОННАЯ СИСТЕМА ==="
for /f "skip=1 tokens=*" %%a in ('wmic os get Caption /format:list') do if not "%%a"=="" set "os_caption=%%a" & goto :found_os
:found_os
for /f "skip=1 tokens=*" %%a in ('wmic os get Version /format:list') do if not "%%a"=="" set "os_version=%%a" & goto :found_ver
:found_ver
if not defined os_caption set "os_caption=Данные не получены"
if not defined os_version set "os_version=Данные не получены"
call :log "%os_caption%"
call :log "Версия: %os_version%"
echo. >> "%report%"

call :log "=== ПРОЦЕССОР ==="
for /f "skip=1 tokens=*" %%a in ('wmic cpu get Name /format:list') do if not "%%a"=="" set "cpu_name=%%a" & goto :found_cpu
:found_cpu
if not defined cpu_name set "cpu_name=Данные не получены"
call :log "%cpu_name%"
echo. >> "%report%"

call :log "=== ОПЕРАТИВНАЯ ПАМЯТЬ ==="
for /f "skip=1 tokens=1,2" %%a in ('wmic OS get TotalVisibleMemorySize^, FreePhysicalMemory /format:list') do (
    if "%%a"=="TotalVisibleMemorySize=" set "mem_total_kb=%%b"
    if "%%a"=="FreePhysicalMemory=" set "mem_free_kb=%%b"
)
if