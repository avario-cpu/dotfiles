LaunchDeadLockMovementScript() {
  scriptPath :=
    "C:\Users\ville\myfiles\deadlock-movement-tracker\deadlock-movement-tracker.ahk"
  Run scriptPath
}

WriteMessageDontResendAllCode() {
  SendText "only resend me the relevant code for this message"
}

WriteMessageWorstUserName() {
  SendText "woertsposzibllen4me"
}

ReplaceSlashes(direction := "/") {
  originalClip := ClipboardAll()
  ClipWait(1)
  currentText := A_Clipboard
  if (direction = "/") {
    newText := StrReplace(currentText, "\", "/")
    A_Clipboard := newText
  }
  else if (direction = "\") {
    newText := StrReplace(currentText, "/", "\")
    A_Clipboard := newText
  }
}
