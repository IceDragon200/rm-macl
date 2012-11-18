@echo off
rd /S /Q  src(backup)
mkdir src(backup)
xcopy \Y \E \R \U src/* src(backup)/*
set batroot=%CD%
start /wait mk_skp_bat.rb
cd %batroot%
start /wait mk_skps_files.bat
cd %batroot%
del /Q _skp\
move /Y *.skpck _skp\
echo 'Removing mk_skps_files.bat'
del /Q mk_skps_files.bat
