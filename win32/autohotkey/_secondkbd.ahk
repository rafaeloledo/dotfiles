#HotIf WinActive("ahk_exe League of Legends.exe")
	Esc::`
	`::Esc
  !Esc::F1
  #q::Esc
#HotIf

#SuspendExempt
#t::Suspend
#SuspendExempt False


#r:: {
  Reload
} 
