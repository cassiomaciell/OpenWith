#define MyAppIdentifier "OpenWith"
#define MyAppName "Open-With"
#define MyAppDescription "Open different URLs using different browsers and arguments"
#define MyAppIcon "{autopf}\Open With\open-with.exe,0"
#define MyAppExe "open-with.exe"

[Setup]
AppName={#MyAppName}
AppVersion=1.0.0
WizardStyle=modern
DefaultDirName={autopf}\{#MyAppName}
PrivilegesRequired=lowest
OutputBaseFilename={#MyAppName}-setup
SetupIconFile=app.ico
UninstallDisplayIcon={app}\{#MyAppExe}

[Files]
Source: ".\dist\{#MyAppExe}"; DestDir: "{app}"; Flags: ignoreversion

[Registry]
Root: HKCU; Subkey: "Software\Clients\StartMenuInternet\{#MyAppIdentifier}"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Clients\StartMenuInternet\{#MyAppIdentifier}"; ValueType: string; ValueName: ""; ValueData: "{#MyAppName}"; Flags: uninsdeletevalue
Root: HKCU; Subkey: "Software\Clients\StartMenuInternet\{#MyAppIdentifier}\Capabilities"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Clients\StartMenuInternet\{#MyAppIdentifier}\Capabilities"; ValueType: string; ValueName: "ApplicationDescription"; ValueData: "{#MyAppDescription}"; Flags: uninsdeletevalue
Root: HKCU; Subkey: "Software\Clients\StartMenuInternet\{#MyAppIdentifier}\Capabilities"; ValueType: string; ValueName: "ApplicationIcon"; ValueData: "{#MyAppIcon}"; Flags: uninsdeletevalue
Root: HKCU; Subkey: "Software\Clients\StartMenuInternet\{#MyAppIdentifier}\Capabilities"; ValueType: string; ValueName: "ApplicationName"; ValueData: "{#MyAppName}"; Flags: uninsdeletevalue
Root: HKCU; Subkey: "Software\Clients\StartMenuInternet\{#MyAppIdentifier}\Capabilities\URLAssociations"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Clients\StartMenuInternet\{#MyAppIdentifier}\Capabilities\URLAssociations"; ValueType: string; ValueName: "https"; ValueData: "{#MyAppIdentifier}"; Flags: uninsdeletevalue
Root: HKCU; Subkey: "Software\Clients\StartMenuInternet\{#MyAppIdentifier}\Capabilities\URLAssociations"; ValueType: string; ValueName: "http"; ValueData: "{#MyAppIdentifier}"; Flags: uninsdeletevalue
Root: HKCU; Subkey: "Software\RegisteredApplications"; ValueType: string; ValueName: "{#MyAppName}"; ValueData: "Software\Clients\StartMenuInternet\{#MyAppIdentifier}\Capabilities"; Flags: uninsdeletevalue
Root: HKCU; Subkey: "Software\Classes\{#MyAppIdentifier}\shell\open\command"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\{#MyAppIdentifier}\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExe}"" %1"; Flags: uninsdeletevalue

[CustomMessages]
InitConfig=Init {#MyAppName} config
OpenConfig=Open {#MyAppName} config

[Run]
Filename: {app}\{#MyAppExe}; Parameters: "--init --show-config"; Description: {cm:InitConfig}; Flags: nowait postinstall skipifsilent
Filename: "ms-settings:defaultapps?registeredAppUser={#MyAppName}"; Flags: shellexec runasoriginaluser

[Code]
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  ErrorCode: Integer;
begin
  if CurUninstallStep = usDone then
  begin
    ShellExec('', 'ms-settings:defaultapps', '', '', SW_SHOW, ewNoWait, ErrorCode);
    MsgBox('Don''t forget to select your default browser.', mbInformation, MB_OK);
  end;
end;