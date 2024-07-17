@echo off

::Set the code page to utf-8.
chcp 65001
cls

set adlUrl=adl.exe
set runTimeUrl=./
set metaDataUrl=META-INF/AIR/application.xml
set rootDirectoryUrl=./

set arg=-runtime %runTimeUrl% -nodebug %metaDataUrl% %rootDirectoryUrl%

::Run command.
%adlUrl% %arg%