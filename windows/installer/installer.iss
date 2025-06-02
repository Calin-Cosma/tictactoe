[Setup]
AppName=tictactoe
AppVersion=1.0
DefaultDirName={pf}\tictactoe
OutputDir=..\
OutputBaseFilename=tictactoeinstaller
Compression=lzma
SolidCompression=yes

[Files]
; Navigate up two levels from installer to reach Release folder
Source: "..\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs

[Icons]
Name: "{group}\tictactoe"; Filename: "{app}\tictactoe.exe"
