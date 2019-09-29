HOW LOGIN PROCESS WORK IN LINUX?
  

Today we will see one basic concept, which is neglected by many Linux users if they are not programmers like system admins. A simple question is "what happens at the time login process in Linux?" Many people know Linux booting process in which init process will take care of booting up a Linux machine. In this post we will see what happens after init process completes executing /etc/rc.local file and til we get PS1 prompt so that we can start executing our desired commands.


 
AN OVERVIEW OF LOGIN PROCESS
	Init creates the getty process
	getty process initiates login command
	login command try to check user credentials
	getty creates user shell process
	getty read shell property files
	getty provides you with PS1 prompt


Let us learn above things in detail by breaking them in to steps:

Step0: Once init process completes run-level execution and executing commands in /etc/rc.local, it will start a process called getty. Getty is the process which will take care of complete login process.

Step1: The getty process initiates login command and gives users with login: prompt display on the terminal screen and wait’s for user to enter username. Once user enter his login name, this in-turn will prompt for user password. The password what user typed will be hidden and will not be shown on screen.

Step2: Now getty will check user credentials by verifying it with /etc/passwd and /etc/shadow file, if password matches it will initiates user properties gathering else getty will terminate login process and re-initiates once again with new login: prompt. This is done for three times in most Linux/Unix flavors. If user failed to enter correct password for three consecutive times, getty disable terminal for 10 seconds by using PAM module to control unauthorised logins.

Step3: Now the getty process read the user properties like username, UID, GID, home directory, user shell from /etc/passwd file to respective system variables $USER, $UID, $GID, $HOME and $SHELL.

Step4: Once it gathers all the properties and before the start of user shell it read /etc/motd file and display it’s content as banner message to user.

Step5: Now getty process reads /etc/profile file for shell related settings and for importing any alias or some sort of variables which we have to set for user shell.

Step6: Once it completes reading /etc/profile file, it will read user home directory content and change user shell properties according to .bashrc, .bash_profile if his default shell is bash. The getty process get shell details from /etc/passwd file.

Step7: Getty now starts a software, which is called as user shell for interacting with user directly. The getty process get this information from $SHELL variable which it already parsed from /etc/passwd file. Now it presents PS1 prompt for user to execute their commands.

From here on-words user can start executing their commands at the terminal. All the above stuff is monitored by kernel in the background. In our next posts we will see how log out process and shutdown process works in detail.