@echo off
set requestcount=1000
set concurrencies=1, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20
set url_1=
set url_2=
set url_3=
set url_4=
set url_5=
set url_6=
set url_7=
set url_8=
set url_9=
set url_0=

:menu
cls
@echo  ===================================
@echo  Measure Performance
@echo  ===================================
@echo.
@echo   [1] - %url_1%
@echo   [2] - %url_2%
@echo   [3] - %url_3%
@echo   [4] - %url_4%
@echo   [5] - %url_5%
@echo   [6] - %url_6%
@echo   [7] - %url_7%
@echo   [8] - %url_8%
@echo   [9] - %url_9%
@echo   [0] - %url_0%
@echo.
@echo   [A] - Measure all URLs
@echo   [C] - Configure
@echo   [Q] - Exit
@echo.
set /p choice=" Make your choice: "
if %choice% EQU 1 (
	call :option1
) else if %choice% EQU 2 (
	call :option2
) else if %choice% EQU 3 (
	call :option3
) else if %choice% EQU 4 (
	call :option4
) else if %choice% EQU 5 (
	call :option5
) else if %choice% EQU 6 (
	call :option6
) else if %choice% EQU 7 (
	call :option7
) else if %choice% EQU 8 (
	call :option8
) else if %choice% EQU 9 (
	call :option9
) else if %choice% EQU 0 (
	call :option0
) else if /I %choice% EQU A (
    call :optionA
) else if /I %choice% EQU C (
    call :optionC
) else if /I %choice% EQU Q (
	goto :eof
) else (
  @echo "Invalid choice - try again"
)
pause
goto :menu

:option1
  echo URL: %url_1%
  set /p url_1="Press Enter or change URL: "
  call :measure performance1.out %url_1%
  call :printResults performance1.out %url_1%
  goto :eof
:option2
  echo URL: %url_2%
  set /p url_2="Press Enter or change URL: "
  call :measure performance2.out %url_2%
  call :printResults performance2.out %url_2%
  goto :eof
:option3
  echo URL: %url_3%
  set /p url_3="Press Enter or change URL: "
  call :measure performance3.out %url_3%
  call :printResults performance3.out %url_3%
  goto :eof
:option4
  echo URL: %url_4%
  set /p url_4="Press Enter or change URL: "
  call :measure performance4.out %url_4%
  call :printResults performance4.out %url_4%
  goto :eof
:option5
  echo URL: %url_5%
  set /p url_5="Press Enter or change URL: "
  call :measure performance5.out %url_5%
  call :printResults performance5.out %url_5% 
  goto :eof
:option6
  echo URL: %url_6%
  set /p url_6="Press Enter or change URL: "
  call :measure performance6.out %url_6%
  call :printResults performance6.out %url_6% 
  goto :eof
:option7
  echo URL: %url_7%
  set /p url_7="Press Enter or change URL: "
  call :measure performance7.out %url_7%
  call :printResults performance7.out %url_7% 
  goto :eof
:option8
  echo URL: %url_8%
  set /p url_8="Press Enter or change URL: "
  call :measure performance8.out %url_8%
  call :printResults performance8.out %url_8% 
  goto :eof
:option9
  echo URL: %url_9%
  set /p url_9="Press Enter or change URL: "
  call :measure performance9.out %url_9%
  call :printResults performance9.out %url_9% 
  goto :eof
:option0
  echo URL: %url_0%
  set /p url_0="Press Enter or change URL: "
  call :measure performance0.out %url_0%
  call :printResults performance0.out %url_0% 
  goto :eof
  
:optionA
  call :measure performance1.out %url_1% 
  call :measure performance2.out %url_2%
  call :measure performance3.out %url_3%
  call :measure performance4.out %url_4%
  call :measure performance5.out %url_5%
  call :measure performance6.out %url_6%
  call :measure performance7.out %url_7%
  call :measure performance8.out %url_8%
  call :measure performance9.out %url_9%
  call :measure performance0.out %url_0%
  call :printResults performance1.out %url_1%
  call :printResults performance2.out %url_2%
  call :printResults performance3.out %url_3%
  call :printResults performance4.out %url_4%
  call :printResults performance5.out %url_5%
  call :printResults performance6.out %url_6%
  call :printResults performance7.out %url_7%
  call :printResults performance8.out %url_8%
  call :printResults performance9.out %url_9%
  call :printResults performance0.out %url_0%
  goto :eof

:optionC
  echo Change configuration:
  set /p concurrencies=Concurrencies (Defaults: %concurrencies%)
  set /p requestcount=Requests (Defaults: %requestcount%)
  goto :eof

:measure
set out=%1
set url=%2
IF "%url%"=="" (
  goto :eof
)
@echo ===================================
@echo Ramp-up... 
@echo   %url%
@echo ===================================
call :run-ab %out% %url%
@echo ===================================
@echo Measuring...
@echo   %url%
@echo ===================================
call :run-ab %out% %url%
goto :eof


:run-ab
set out=%1
set url=%2
@echo "URL: %1" > %out%
FOR %%c IN ( %concurrencies% ) DO ( echo Concurrent requests: %%c && ( ab -c %%c -k -n %requestcount% %url% >> %out% ) ) 2>NUL
goto :eof

:printResults
set name=%2
set in=%1
IF "%name%"=="" goto :eof
echo.
echo ===================================
echo Results: %name%
echo.
echo Concurrency     Non-2xx         Throughput [#/sec]
echo --------------------------------------------------
set sedpattern=/^Concurrency Level:/{s/^Concurrency Level:      //;s/\n//;P};
set sedpattern=%sedpattern%/^Non-2xx responses:/{s/Non-2xx responses:      /\t/;P};     
set sedpattern=%sedpattern%/^Requests per second:/{s/^Requests per second:    /\t/;P}; 
sed -n "%sedpattern%" %in% | sed "N;s/\n/\t/;N;s/\n/\t/;s/\[#\/sec\] (mean)$//"
goto :eof
