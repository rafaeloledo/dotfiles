^+/:: Send "{/}"
+!PgDn:: Send "+{End}"
!PgUp:: Send "{Home}"
+!PgUp:: Send "+{Home}"

CapsLock::Ctrl

#=::SendEvent "{Volume_Up}"
#-::SendEvent "{Volume_Down}"
#r::SendEvent "{Alt down}{Space down}{Space up}{Alt up}"
#Enter::Run "C:\dev\scoop\apps\wezterm\current\wezterm-gui.exe"
#o::Run "C:\dev\scoop\apps\obsidian\current\Obsidian.exe"
#n::Run "C:\dev\scoop\apps\neovide\current\neovide.exe"
#b::Run "chrome.exe"
#m::Run "soundvolumeview.exe /Switch 3- Fifine Microphone"
#q::RunWait "wscript C:\dev\dotfiles\win32\kill-process.vbs " WinGetPID("A")
#a::RunWait "neovide C:\sync\anotacoes"
#+c::RunWait "C:\dev\scoop\apps\scrcpy\current\scrcpy-noconsole.vbs --disable-screensaver --turn-screen-off --no-audio-playback"

!r::Reload
!c::RunWait "C:\dev\scoop\apps\scrcpy\current\scrcpy-noconsole.vbs --disable-screensaver --turn-screen-off"
!F1::SendEvent "{Media_Prev}"
!F3::SendEvent "{Media_Next}"
!F2::SendEvent "{Media_Play_Pause}"
!/::Send "{?}"
!PgDn::Send "{End}"

!e:: {
    RunWait "taskkill /F /IM explorer.exe"
    Run "explorer.exe"
}

#HotIf WinActive("ahk_exe explorer.exe")
	#q::SendEvent "{Ctrl down}{w down}{w up}{Ctrl down}"
#HotIf

#HotIf not (WinActive("ahk_exe League of Legends.exe") or
WinActive("ahk_exe LeagueClientUx.exe"))
  !h:: SendEvent "{Left}"
  !j:: SendEvent "{Down}"
  !k:: SendEvent "{Up}"
  !l:: SendEvent "{Right}"
#HotIf

#HotIf not WinActive("ahk_exe League of Legends.exe")
  !1:: SendEvent "{LWin down}{LCtrl down}{Left down}{LWin up}{LCtrl up}{Left up}"
  !2:: SendEvent "{LWin down}{LCtrl down}{Right down}{LWin up}{LCtrl up}{Right up}"
#HotIf

#HotIf WinActive("ahk_exe League of Legends.exe")
	Esc::`
	#+q::Esc
	!1::F1
	!2::F2
	!3::F3
	!4::F4

	#m::SendEvent "{enter}{/}mute all{enter}"
	#q::SendEvent "{Alt down}{F4}{Alt up}"
#HotIf

#HotIf WinActive("ahk_exe devenv.exe") or
WinActive("ahk_exe Code.exe")
	!+R:: SendEvent "{F5}"
	!R:: SendEvent "{Ctrl down}{F5}{Ctrl up}"
#HotIf

#HotIf WinActive("ahk_exe msedge.exe")
	^p::^p
#HotIf

#HotIf WinActive("ahk_exe chrome.exe")
	!o:: {
    SendEvent "{Ctrl down}{l down}{l up}{Ctrl up}"
    SendEvent "{Ctrl down}{c down}{c up}{Ctrl up}"
    RepoURL := A_Clipboard
    RegExMatch(RepoURL, "/([^/]+)(?:\.git)?$", &repoName)
    RunWait "C:\dev\dotfiles\win32\clone_repo.vbs " RepoURL
    RunWait "C:\dev\dotfiles\win32\open_repo.vbs " "C:\dev\repos\gh\" repoName[1]
	}
#HotIf

#HotIf WinActive("ahk_exe ELEMENTCLIENT.exe") or
WinActive("ahk_exe elementclient_64.exe") or
WinActive("Perfect World")
	!3:: {
	    loop {
        SendEvent "{F3}"
        Sleep 100
      if GetKeyState("Esc", "P")
		    break
	    }
	}

	`:: {
	    SendEvent "{Alt down}{Esc down}{Alt up}{Esc up}"
	    Click "Right"
	}

	+LButton:: {
	    Click "Left"
	    Click "Left"
	}

	!D:: {
	    SendEvent "{l}{l}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{l}"
	    Sleep 30
	    SendEvent "{``}{``}{7}{8}{9}{``}"
	}

	!A:: {
	    SendEvent "{l}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{l}{l}"
	    Sleep 30
	    SendEvent "{``}{7}{8}{9}{``}{``}"
	}

	!I:: {
	    loop 10 {
        SendEvent "{Alt down}{Esc down}{Alt up}{Esc up}"
        Click "Right"
        Sleep 130
        SendEvent "{1}"
	    }
	}

	!R:: {
	    loop 10 {
        SendEvent "{Alt down}{Esc down}{Alt up}{Esc up}"
        Click "Right"
        Sleep 130
        SendEvent "{F12}"
	    }
	}

	!1::Send "{F1}"
	!2::Send "{F2}"
	!4::Send "{F4}"
	!C::Send "{F12}"
#HotIf
