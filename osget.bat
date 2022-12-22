:main
set "download_dir=."
set "use_bt=no"

if "%1" == "--help" (
    goto show_help
)
if "%1" == "-h" (
    goto show_help
)
if "%1" == "--version" (
    goto version
)
if "%1" == "-v" (
    goto version
)
if "%1" == "--list" (
    goto list
)
if "%1" == "-l" (
    goto list
)
if "%1" == "--listosnames" (
    goto list_osnames
)
if "%1" == "-o" (
    goto list_osnames
)
if "%1" == "--information" (
    goto get_information
)
if "%1" == "-i" (
    goto get_information
)
if "%1" == "--directory" (
    shift
    set "download_dir=%1"
    shift
)
if "%1" == "-d" (
    shift
    set "download_dir=%1"
    shift
)
if "%1" == "--search" (
    shift
    goto search
)
if "%1" == "-s" (
    shift
    goto search
)
if "%1" == "--torrent" (
    set "use_bt=yes"
    shift
)
if "%1" == "-t" (
    set "use_bt=yes"
    shift
)
if "%1" == "--update" (
    goto update_os_list
)
if "%1" == "-u" (
    goto update_os_list
)

if "%1" == "" (
    echo.
    echo No operating system specified.
    echo.
    goto show_help
)

call checkfor_btclient

:download_loop
if "%1" == "" (
    goto :EOF
)

call download %1
shift
goto download_loop
