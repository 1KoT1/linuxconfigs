#!/bin/bash

mapfile -t konsole_windows < <(qdbus "org.kde.konsole*")

for i in "${!konsole_windows[@]}"; do
	is_active=$(qdbus "${konsole_windows[$i]}" /konsole/MainWindow_1 org.qtproject.Qt.QWidget.isActiveWindow)
	if [ "$is_active" == "true" ]; then
		active_window="${konsole_windows[$i]}"
		break
	fi
done

exit_code_pipe_name="`mktemp`"
rm "$exit_code_pipe_name"
mkfifo "$exit_code_pipe_name"

# Redirect the stdin if there is the "-" argument
for A in $@; do
	if [ "$A" == "-" ]; then
		stdin_pipe_name="`mktemp`"
		rm "$stdin_pipe_name"
		mkfifo "$stdin_pipe_name"
		cat <&0 > "$stdin_pipe_name" 2> /dev/null &
		redirect_stdin="cat \"$stdin_pipe_name\" |"
	fi
done

new_session=$(qdbus "${konsole_windows[$i]}" /Windows/1 org.kde.konsole.Window.newSession "Profile 1" "`pwd`")
qdbus "${konsole_windows[$i]}" /Sessions/$new_session org.kde.konsole.Session.runCommand "$redirect_stdin `printf "%q " "$@"` ; echo \$? > \"$exit_code_pipe_name\" && exit"

exit_code=`cat "$exit_code_pipe_name"`
rm "$exit_code_pipe_name"
rm "$stdin_pipe_name" 2> /dev/null
exit $exit_code
