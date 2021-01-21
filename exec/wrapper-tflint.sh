#!/bin/bash +e

_FILES=$(printf '%s' "$1" | jq -r '.[]')

_EXIT_CODE="0"

for _FILE in $_FILES
do
  if [ "${_FILE: -3}" == ".tf" ]; then
    if ! tflint -f checkstyle "$_FILE" -c "$2" > _TFLINT; then
      _EXIT_CODE="1"
    fi

    cat _TFLINT | reviewdog -f=checkstyle -reporter=github-pr-review
  fi
done

exit $_EXIT_CODE
