note
	EIS: "src=http://www.computerhope.com/overview.htm"

deferred class
	FW_CLI_FILE_MANAGER

inherit
	FW_PROCESS_HELPER

	RANDOMIZER

	EXECUTION_ENVIRONMENT

feature -- Access

	path: PATH
			--
		do
			check attached internal_path as al_path then Result := al_path end
		end

feature -- Queries

	has_path: BOOLEAN do Result := attached internal_path end

feature -- Temporary Path

	create_temp_path
			--
		require
			not_has_path: not has_path
		local
			l_dir: DIRECTORY
			l_uuid: STRING
		do
			l_uuid := uuid.out
			create l_dir.make (current_working_path.name.out + "\" + l_uuid)
			l_dir.create_dir
			create internal_path.make_from_separate (l_dir.path)
		ensure
			has_path: has_path
		end

	remove_temp_path
			--
		require
			has_path: has_path
		local
			l_dir: DIRECTORY
		do
			check attached internal_path as al_path then
				create l_dir.make_with_path (al_path)
				l_dir.delete_content
				l_dir.delete
			end
			internal_path := Void
		ensure
			no_path: not has_path
		end

feature -- Internal DOS

	move (a_source_list: ARRAY [PATH]; a_destination: PATH)
			-- `move' `a_source_list' items to `a_destination' (always "suppress" or /Y)
		note
			syntax: "[
				Moves files and renames files and directories.

				To move one or more files:

				MOVE [/Y | /-Y] [drive:][path]filename1[,...] destination

				To rename a directory:

				MOVE [/Y | /-Y] [drive:][path]dirname1 dirname2

				[drive:][path]filename1		Specifies the location and name of the file
												or files you want to move.
				destination					Specifies the new location of the file.
												Destination can consist of a drive letter
												and colon, a directory name, or a
												combination. If you are moving only
												one file, you can also include a filename
												if you want to rename the file when you
												move it.
				[drive:][path]dirname1		Specifies the directory you want to rename.
				dirname2					Specifies the new name of the directory.
				/Y							Suppresses prompting to confirm you want
												to overwrite an existing destination file.
				/-Y							Causes prompting to confirm you want to
												overwrite an existing destination file.
				]"
		require
			has_sources: not a_source_list.is_empty
			destination_exists: (create {DIRECTORY}.make_with_path (a_destination)).exists
		local
			l_cmd: STRING
		do
			create l_cmd.make_from_string ("CMD /C MOVE /Y ")
			across
				a_source_list as ic
			loop
				l_cmd.append_string_general (ic.item.name.out)
				l_cmd.append_character (',')
			end
			l_cmd.remove_tail (1)
			l_cmd.append_character (' ')
			l_cmd.append_string_general (a_destination.name.out)
			output_of_command (l_cmd, "").do_nothing
		ensure
			has_error: last_error = 1 implies attached last_error_result
			last_zero: last_error = 0
		end

	dos_copy (a_source, a_destination: PATH)
			--
		note
			syntax: "[
				Copy syntax
				===========
				Windows Vista and later syntax

				COPY [/D] [/V] [/N] [/Y | /-Y] [/Z] [/L] [/A | /B ] source [/A | /B] [+ source [/A | /B] [+ ...]] [destination [/A | /B]]

				source			Specifies the file or files to be copied.
				/A				Indicates an ASCII text file.
				/B				Indicates a binary file.
				/D				Allow the destination file to be created decrypted.
				destination		Specifies the directory or filename for the new file(s).
				/V				Verifies that new files are written correctly.
				/N				Uses short filename, if available, when copying a file with a non-8dot3 name.
				/Y				Suppresses prompting to confirm you want to overwrite an existing destination file.
				/-Y				Causes prompting to confirm you want to overwrite an existing destination file.
				/Z				Copies networked files in restartable mode.
				/L				If the source is a symbolic link, copy the link to the target instead of the actual file the source link points to.

				The switch /Y may be preset in the COPYCMD environment variable. This may be overridden with /-Y on the command line. Default is to prompt on overwrites unless COPY command is being executed from within a batch script.
				To append files, specify a single file for destination, but multiple files for source (using wildcards or file1+file2+file3 format).
				]"
		local
			l_cmd: STRING
		do
			l_cmd := "CMD /C COPY "
			l_cmd.append_string_general (a_source.name.out)
			l_cmd.append_character (' ')
	--		if a_is_ascii then l_cmd.append_string_general ("/A ") end
	--		if a_is_binary then l_cmd.append_string_general ("/B ") end
			l_cmd.append_string_general (a_destination.name.out)
			l_cmd.append_string_general (" /Y /V")
			output_of_command (l_cmd, "").do_nothing
		ensure
			has_error: last_error = 1 implies attached last_error_result
			last_zero: last_error = 0
		end

feature {NONE} -- Implementation

	internal_path: detachable PATH
			-- `internal_path' as created by `create_temp_path'
			-- and then destroyed by `remove_temp_path'.
			-- Errors between creation and removal will need
			-- manual human attention to clean-up.

;note
	commands: "[
MS-DOS and command line overview

MS-DOS C:\> promptBelow is a listing of each of the
MS-DOS and Windows command line commands listed on
Computer Hope and a brief explanation about each
command. This list contains every command ever made
available, which means not all the commands are
going to work with your version of MS-DOS or
Windows. Click on the command to view a full
help page.

Command			Description	Type
=======			========================================================
ansi.sys		Defines functions that change display graphics, control cursor movement, and reassign keys.	File
append			Causes MS-DOS to look in other directories when editing a file or running a command.		External
arp				Displays, adds, and removes arp information from network devices.							External
assign			Assign a drive letter to an alternate letter.												External
assoc			View the file associations.																	Internal
at				Schedule a time to execute commands or programs.											External
atmadm			Lists connections and addresses seen by Windows ATM call manager.	Internal
attrib			Display and change file attributes.	External
batch			Recovery console command that executes a series of commands in a file.	Recovery
bcdedit			Modify the boot configuration data store.	External
bootcfg			Recovery console command that allows a user to view, modify, and rebuild the boot.ini	Recovery
break			Enable and disable CTRL + C feature.	Internal
cacls			View and modify file ACL's.	External
call			Calls a batch file from another batch file.	Internal
cd				Changes directories.	Internal
chcp			Supplement the International keyboard and character set information.	External
chdir			Changes directories.	Internal
chkdsk			Check the hard drive running FAT for errors.	External
chkntfs			Check the hard drive running NTFS for errors.	External
choice			Specify a listing of multiple options within a batch file.	External
cls				Clears the screen.	Internal
cmd				Opens the command interpreter.	Internal
color			Change the foreground and background color of the MS-DOS window.	Internal
command			Opens the command interpreter.	Internal
comp			Compares files.	External
compact			Compresses and uncompress files.	External
control			Open Control Panel icons from the MS-DOS prompt.	External
convert			Convert FAT to NTFS.	External
copy			Copy one or more files to an alternate location.	Internal
ctty			Change the computers input/output devices.	Internal
date			View or change the systems date.	Internal
debug			Debug utility to create assembly programs to modify hardware settings.	External
defrag			Re-arrange the hard drive to help with loading programs.	External
del				Deletes one or more files.	Internal
delete			Recovery console command that deletes a file.	Internal
deltree			Deletes one or more files or directories.	External
dir				List the contents of one or more directory.	Internal
disable			Recovery console command that disables Windows system services or drivers.	Recovery
diskcomp		Compare a disk with another disk.	External
diskcopy		Copy the contents of one disk and place them on another disk.	External
doskey			Command to view and execute commands that have been run in the past.	External
dosshell		A GUI to help with early MS-DOS users.	External
drivparm		Enables overwrite of original device drivers.	Internal
echo			Displays messages and enables and disables echo.	Internal
edit			View and edit files.	External
edlin			View and edit files.	External
emm386			Load extended Memory Manager.	External
enable			Recovery console command to enable a disable service or driver.	Recovery
endlocal		Stops the localization of the environment changes enabled by the setlocal command.	Internal
erase			Erase files from computer.	Internal
exit			Exit from the command interpreter.	Internal
expand			Expand a Microsoft Windows file back to it's original format.	External
extract			Extract files from the Microsoft Windows cabinets.	External
fasthelp		Displays a listing of MS-DOS commands and information about them.	External
fc				Compare files.	External
fdisk			Utility used to create partitions on the hard drive.	External
find			Search for text within a file.	External
findstr			Searches for a string of text within a file.	External
fixboot			Writes a new boot sector.	Recovery
fixmbr			Writes a new boot record to a disk drive.	Recovery
for				Boolean used in batch files.	Internal
format			Command to erase and prepare a disk drive.	External
ftp				Command to connect and operate on an FTP server.	External
fType			Displays or modifies file types used in file extension associations.	Recovery
goto			Moves a batch file to a specific label or location.	Internal
graftabl		Show extended characters in graphics mode.	External
help			Display a listing of commands and brief explanation.	External
if				Allows for batch files to perform conditional processing.	Internal
ifshlp.sys		32-bit file manager.	External
ipconfig		Network command to view network adapter settings and assigned values.	External
keyb			Change layout of keyboard.	External
label			Change the label of a disk drive.	External
lh				Load a device driver in to high memory.	Internal
listsvc			Recovery console command that displays the services and drivers.	Recovery
loadfix			Load a program above the first 64k.	External
loadhigh		Load a device driver in to high memory.	Internal
lock			Lock the hard drive.	Internal
logoff			Logoff the currently profile using the computer.	External
logon			Recovery console command to list installations and enable administrator login.	Recovery
map				Displays the device name of a drive.	Recovery
md				Command to create a new directory.	Internal
mem				Display memory on system.	External
mkdir			Command to create a new directory.	Internal
mklink			Creates a symbolic link.	Internal
mode			Modify the port or display settings.	External
more			Display one page at a time.	External
move			Move one or more files from one directory to another directory.	Internal
msav			Early Microsoft Virus scanner.	External
msd				Diagnostics utility.	External
mscdex			Utility used to load and provide access to the CD-ROM.	External
nbtstat			Displays protocol statistics and current TCP/IP connections using NBT	External
net				Update, fix, or view the network or network settings	External
netsh			Configure dynamic and static network information from MS-DOS.	External
netstat			Display the TCP/IP network protocol statistics and information.	External
nlsfunc			Load country specific information.	External
nslookup		Look up an IP address of a domain or host on a network.	External
path			View and modify the computers path location.	Internal
pathping		View and locate locations of network latency.	External
pause			Command used in batch files to stop the processing of a command.	Internal
ping			Test and send information to another network computer or network device.	External
popd			Changes to the directory or network path stored by the pushd command.	Internal
power			Conserve power with computer portables.	External
print			Prints data to a printer port.	External
prompt			View and change the MS-DOS prompt.	Internal
pushd			Stores a directory or network path in memory so it can be returned to at any time.	Internal
qbasic			Open the QBasic.	External
rd				Removes an empty directory.	Internal
ren				Renames a file or directory.	Internal
rename			Renames a file or directory.	Internal
rmdir			Removes an empty directory.	Internal
robocopy		A robust file copy command for the Windows command line.	External
route			View and configure Windows network route tables.	External
runas			Enables a user to run a program as a different user.	External
scandisk		Run the scandisk utility.	External
scanreg			Scan Registry and recover Registry from errors.	External
set				Change one variable or string to another.	Internal
setlocal		Enables local environments to be changed without affecting anything else.	Internal
setver			Change MS-DOS version to trick older MS-DOS programs.	External
share			Installs support for file sharing and locking capabilities.	External
shift			Changes the position of replaceable parameters in a batch program.	Internal
shutdown		Shutdown the computer from the MS-DOS prompt.	External
smartdrv		Create a disk cache in conventional memory or extended memory.	External
sort			Sorts the input and displays the output to the screen.	External
start			Start a separate window in Windows from the MS-DOS prompt.	Internal
subst			Substitute a folder on your computer for another drive letter.	External
switches		Remove add functions from MS-DOS.	Internal
sys				Transfer system files to disk drive.	External
telnet			Telnet to another computer or device from the prompt.	External
time			View or modify the system time.	Internal
title			Change the title of their MS-DOS window.	Internal
tracert			Visually view a network packets route across a network.	External
tree			View a visual tree of the hard drive.	External
Type			Display the contents of a file.	Internal
undelete		Undelete a file that has been deleted.	External
unformat		Unformat a hard drive.	External
unlock			Unlock a disk drive.	Internal
ver				Display the version information.	Internal
verify			Enables or disables the feature to determine if files have been written properly.	Internal
vol				Displays the volume information about the designated drive.	Internal
xcopy			Copy multiple files, directories, or drives from one location to another.	External
		]"

end
