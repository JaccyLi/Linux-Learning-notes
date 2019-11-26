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
		call setline(4,"#Author:			    steveli")
		call setline(5,"#QQ:				    1049103823")
		call setline(6,"#Data:			        ".strftime("%Y-%m-%d"))
		call setline(7,"#FileName:		        ".expand("%"))
		call setline(8,"#Personal Blog:		    https://suosuoli.cn")
		call setline(9,"#CSDN Blog:		        https://blog.csdn.net/YouOops")
		call setline(10,"#Description:		    ".expand("%"))
		call setline(11,"#Copyright (C):	        ".strftime("%Y")." Steve,All rights reserved.")
		call setline(12,"#*******************************************************************************")
		call setline(13,"#Fontcolor#red(31):green(32):yellow(33):blue(34):purple(35):cyan(36):white(37)")
		call setline(14,"#Backcolor#red(41):green(42):yellow(43):blue(44):purple(45):cyan(46):white(47)")
		call setline(15,"#*******************************************************************************")
        call setline(16,"#########################")
        call setline(17,"# . /etc/init.d/functions")
        call setline(18,"# success")
        call setline(19,"# passed")
        call setline(20,"# warning")
        call setline(21,"# failure")
        call setline(22,"#########################")
        call setline(23,"")
		endif
endfunc
autocmd BufNewFile * normal G


execute pathogen#infect()
syntax on
filetype plugin indent on

let mapleader=","
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)
