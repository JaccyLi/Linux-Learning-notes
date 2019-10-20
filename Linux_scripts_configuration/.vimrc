set number
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab 
set ignorecase
set cursorline
set autoindent
autocmd BufNewFile *.sh exec ":call SetTitle()"
func SetTitle()
	if expand("%:e") == 'sh'
		call setline(1,"#!/bin/bash")
		call setline(2,"#")
		call setline(3,"#*******************************************************************************")
		call setline(4,"#Author:			steveli")
		call setline(5,"#QQ:				1049103823")
		call setline(6,"#Data:			    ".strftime("%Y-%m-%d"))
		call setline(7,"#FileName:		    ".expand("%"))
		call setline(8,"#URL:		        https://blog.csdn.net/YouOops")
		call setline(9,"#Description:		".expand("%"))
		call setline(10,"#Copyright (C):	    ".strftime("%Y")." All rights reserved")
		call setline(11,"#*******************************************************************************")
		call setline(12,"#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)")
		call setline(13,"#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)")
		call setline(14,"#*******************************************************************************")
        call setline(15,"#")
        call setline(16,"")
		endif
endfunc
autocmd BufNewFile * normal G
