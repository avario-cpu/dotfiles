#Include app-launchers.ahk
#Include delayed-tooltip.ahk

global StreamAppGroups := Map(
  "production", [
    Map("find", (*) => FindWindowByExeAndTitle("Streamer.bot.exe", "production"),
      "start", (*) => ActivateStreamerBot(portableVersion := "production")),
    Map("find", (*) => FindWindowByExeAndTitle("obs64.exe", "", "Portable Mode"),
      "start", (*) => ActivateOBS()),
  ],
  "ftp", [
    Map("find", (*) => FindWindowByExeAndTitle("Streamer.bot.exe", "ftp"),
      "start", (*) => ActivateStreamerBot(portableVersion := "ftp")),
    Map("find", (*) => FindWindowByExeAndTitle("obs64.exe",
      "Portable Mode - Profile: ftp"),
      "start", (*) => ActivateOBSPortable(profile := "ftp")),
    Map("find", (*) => FindWindowByExeAndTitle("obs64.exe",
      "Portable Mode - Profile: vcam"),
      "start", (*) => ActivateOBSPortable(profile := "vcam")),
  ]
)

global QuitStreamDeckScript := StreamingRepoPath .
  "external\streamdeck\utils\quit-streamdeck\quit-streamdeck.vbs"

FindWindowByExeAndTitle(exeName, include := "", exclude := "") {
  prev := DetectHiddenWindows(true)
  try {
    for hwnd in WinGetList("ahk_exe " exeName) {
      title := WinGetTitle(hwnd)
      if (include && !InStr(title, include))
        continue
      if (exclude && InStr(title, exclude))
        continue
      return hwnd
    }
    return 0
  } finally DetectHiddenWindows(prev)
}

CloseStreamApp(app, timeout := 8000) {
  hwnd := app["find"]()
  if !hwnd
    return
  pid := WinGetPID(hwnd)
  for win in WinGetList("ahk_pid " pid)
    WinClose(win)
}

QuitStreamDeck() {
  if FileExist(QuitStreamDeckScript)
    RunWait('wscript.exe "' QuitStreamDeckScript '"')
  else
    MsgBox "quit-streamdeck.vbs not found at:`n" QuitStreamDeckScript
}

CloseStreamApps(group := "production") {
  apps := StreamAppGroups["production"].Clone()
  if group = "all"
    apps.Push(StreamAppGroups["ftp"]*)

  QuitStreamDeck()
  for app in apps
    CloseStreamApp(app)
  DelayedToolTipMsg("Closed stream apps: " group)
}

StartStreamApps(group := "production") {
  apps := StreamAppGroups["production"].Clone()
  if group = "all"
    apps.Push(StreamAppGroups["ftp"]*)

  ActivateStreamDeck()
  for app in apps
    app["start"]()
  DelayedToolTipMsg("Started stream apps: " group)
}
