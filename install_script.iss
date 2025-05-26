;InnoSetupVersion=6.3.0 (Unicode)

[Setup]
AppName=CPUID HWMonitor
AppVerName=CPUID HWMonitor 1.57
AppId=CPUID HWMonitor
AppVersion=1.57
AppPublisher=CPUID, Inc.
DefaultDirName={pf}\CPUID\HWMonitor
DefaultGroupName=CPUID\HWMonitor
UninstallDisplayIcon={app}\HWMonitor.exe
OutputBaseFilename=tmpjwxy4d.tmp
Compression=lzma
ArchitecturesInstallIn64BitMode=x64
DisableDirPage=auto
DisableProgramGroupPage=auto
WizardImageFile=embedded\WizardImage0.bmp,embedded\WizardImage1.bmp
WizardSmallImageFile=embedded\WizardSmallImage0.bmp,embedded\WizardSmallImage1.bmp,embedded\WizardSmallImage2.bmp,embedded\WizardSmallImage3.bmp,embedded\WizardSmallImage4.bmp,embedded\WizardSmallImage5.bmp,embedded\WizardSmallImage6.bmp

[Files]
Source: "{app}\HWMonitor,1.exe"; DestDir: "{app}"; DestName: "HWMonitor.exe"; Check: "not Is64BitInstallMode"; 
Source: "{app}\HWMonitor,2.exe"; DestDir: "{app}"; DestName: "HWMonitor.exe"; Check: "IsX64"; 
Source: "{app}\hwm_readme.txt"; DestDir: "{app}"; 

[Registry]
Root: HKLM; Subkey: "Software\CPUID"; Flags: uninsdeletekeyifempty 
Root: HKLM; Subkey: "Software\CPUID\HWMonitor"; Flags: uninsdeletekey 
Root: HKLM; Subkey: "Software\CPUID\HWMonitor"; ValueName: "PATH"; ValueType: String; ValueData: "{app}"; 
Root: HKLM; Subkey: "Software\CPUID\HWMonitor"; ValueName: "PRODUCT_NAME"; ValueType: String; ValueData: "CPUID HWMonitor"; 
Root: HKLM; Subkey: "Software\CPUID\HWMonitor"; ValueName: "VERSION"; ValueType: String; ValueData: "1.57"; 

[Run]
Filename: "{app}\hwm_readme.txt"; Flags: shellexec skipifdoesntexist postinstall skipifsilent nowait

[Icons]
Name: "{group}\HWMonitor"; Filename: "{app}\HWMonitor.exe"; WorkingDir: "{app}"; 
Name: "{group}\Uninstall HWMonitor"; Filename: "{uninstallexe}"; 
Name: "{commondesktop}\CPUID HWMonitor"; Filename: "{app}\HWMonitor.exe"; WorkingDir: "{app}"; Tasks: desktopicon; 

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"; 

[UninstallDelete]
Type: files; Name: "{app}\*.ini"; 

[CustomMessages]
default.NameAndVersion=%1 version %2
default.AdditionalIcons=Additional shortcuts:
default.CreateDesktopIcon=Create a &desktop shortcut
default.CreateQuickLaunchIcon=Create a &Quick Launch shortcut
default.ProgramOnTheWeb=%1 on the Web
default.UninstallProgram=Uninstall %1
default.LaunchProgram=Launch %1
default.AssocFileExtension=&Associate %1 with the %2 file extension
default.AssocingFileExtension=Associating %1 with the %2 file extension...
default.AutoStartProgramGroupDescription=Startup:
default.AutoStartProgram=Automatically start %1
default.AddonHostProgramNotFound=%1 could not be located in the folder you selected.%n%nDo you want to continue anyway?

[Languages]
; These files are stubs
; To achieve better results after recompilation, use the real language files
Name: "default"; MessagesFile: "embedded\default.isl"; 
