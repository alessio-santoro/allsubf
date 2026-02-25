#!/bin/bash

run_command_recursively() {
    local command="$1"
    local depth="$2"

    if [ "$depth" -eq 0 ]; then
        return
    fi

    for dir in */; do
        if [ -d "$dir" ]; then

			echo $dir
            cd "$dir" || continue
			eval "$command"
            
            run_command_recursively "$command" $((depth - 1))
			cd ..
			echo ""
        fi
    done
}

depth=1 
while getopts ":d:" opt; do
    case ${opt} in
        d)
            depth=${OPTARG}
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))
command="$@"
run_command_recursively "$command" "$depth"
