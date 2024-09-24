# --- subcommands ---

function bashly() {

    function copy() {
    	  local source_file="$1"
        local base_name="$(basename "$source_file")"
        local dest_file="/usr/local/bin/$base_name"

        is not existing "$1" && echo "Error: Source file $source_file not found." && return 1
        # TODO: add the origin to the head of the file
        sudo cp -v "$source_file" "$dest_file"
    }
    
    case "$1" in
        check)
            shellcheck -s bash ./src/root_command.sh
            ;;
        move)
            copy "$2"
            ;;
        *)
            command bashly "$@"
            exit_code=$?
            
            if [ $exit_code -ne 0 ]; then
                echo "Error: subcommand not recognized or 'bashly' command failed."
            fi

            return $exit_code
            ;;
    esac
}

function pman() {

    case "$1" in
        colors)
            echo Default, Indexed
            echo Idea
            echo Not Started
            echo Started, Ongoing
            echo Paused
            echo Completed
            echo Aborted
            ;;
        *)
            command "$0" "$@"
            exit_code=$?
            
            if [ $exit_code -ne 0 ]; then
                echo "Error: subcommand not recognized or '$0 $@' command failed."
            fi

            return $exit_code
            ;;
    esac
}
