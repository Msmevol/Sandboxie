## Xdefend Build Instructions

**Based on Sandboxie Classic**

- Original project: [Sandboxie](https://github.com/sandboxie-plus/Sandboxie)
- License: GPL v3
- Maintained by: xdefend_sandboxie

---

### Build Requirements

Xdefend builds under Visual Studio 2019, offering compatibility with Windows 7 through Windows 11.

1) Download [Visual Studio 2019](https://visualstudio.microsoft.com/vs/older-downloads/#visual-studio-2019-and-other-products)
2) In the Visual Studio Installer, tick _Desktop development with C++_
	- This includes the Windows 10 SDK 10.0.19041
3) The _MFC for latest v142 build tools {architecture}_ is also needed. Select it from the side panel or from the individual components tab
4) If you need to build for other platforms, install the corresponding components
	- _MSVC v142 - VS 2019 C++ {architecture} build tools (Latest)_
	- _MFC for latest v142 build tools {architecture}_
5) Install the Windows Driver Kit (WDK) for Windows 10, version 2004 (10.0.19041):
	https://go.microsoft.com/fwlink/?linkid=2128854
6) The VS Solution File, Sandbox.sln, is in the source code root. Open this SLN in Visual Studio.
7) If the WDK Extension doesn't install automatically, install it (can be found in <Windows Kits directory>\10\Vsix\VS2019)
8) If you have a more recent Windows SDK version installed, retarget the solution to 10.0.19041
	- This is for example necessary if VS 2022 is also installed with the default desktop C++ components
9) To compile for x64, it's necessary to first compile `Solution/core/LowLevel` for Win32 (x86)

---

### Source Projects (in alphabetical order)

> Note: the core of Xdefend are the driver (SbieDrv), the service (SbieSvc), and the injection DLL (SbieDll). Study these projects first.

**Common** (\apps\common). Builds common.lib, which contains common GUI objects used by Control and Start projects.

**KmdUtil** (\install\kmdutil). Builds KmdUtil.exe, used during installation to start/stop the driver (SbieDrv.sys).

**LowLevel** (\core\low). Creates LowLevel.dll, used in code injection. Embedded into SbieSvc.exe as a resource.

**Parse** (\msgs). Creates the Xdefend messages files.

**SandboxBITS** (apps\com\BITS). Creates SandboxieBITS.exe (Background Intelligent Transfer Service).

**SandboxCrypto** (apps\com\Crypto). Creates SandboxieCrypto.exe.

**SandboxieInstall** (\install\release). Creates the combined x64/x86 installer XdefendInstall.exe.
> Note: Must be built manually after x64 & x86 installers are completed.

**SandboxRpcSs** (\apps\com\RpcSs). Creates SandboxieRpcSs.exe, wrapper for Remote Procedure Call Sub-System.

**SandboxWUAU** (\apps\com\WUAU). Creates SandboxieWUAU.exe, wrapper for Windows Automatic Update Service.

**SbieControl** (\apps\control). Builds SbieCtrl.exe, the Xdefend Control app displaying real-time sandboxed activity.

**SbieIni** (\apps\ini). Creates SbieIni.exe, utility for querying and updating the xdefend.ini configuration file.

**SboxDcomLaunch** (\apps\com\DcomLaunch). Creates SandboxieDcomLaunch.exe.

**SboxDll** (\core\dll). Creates the injection DLL, injected into every sandboxed process.

**SboxDrv** (\core\drv). Creates the kernel-mode driver.

**SboxHostDll** (\SboxHostDll). Builds the host injection DLL, injected into host processes requiring sandbox redirection.

**SboxMsg** (\msgs). Creates SboxMsg.dll, containing user messages in various languages.

**SboxSvc** (\core\svc). Creates the Xdefend service.

**Start** (\apps\start). Creates start.exe, used to start processes in the sandbox.

---

### License

This project is licensed under GPL v3. See [COPYING](./COPYING) for details.

### Original Project

Based on Sandboxie Classic:
- Repository: https://github.com/sandboxie-plus/Sandboxie
- Copyright 2004-2020 Sandboxie Holdings, LLC
- Copyright 2020-2025 David Xanatos, xanasoft.com

### Contact

- Website: https://xdefend.sandboxie.com
- Maintained by: xdefend_sandboxie
