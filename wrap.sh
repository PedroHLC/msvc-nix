#!/usr/bin/env bash
set -euo pipefail

_target_exec=$msvc_extracted_dir/tools/VC/Tools/MSVC/$msvc_tools_version/bin/Host$msvc_host/$msvc_target/$msvc_exe.exe
_sdk_libs=$msvc_extracted_dir/sdk/10/Lib/$msvc_sdk_version/um/$msvc_target/
_ucrt_libs=$msvc_extracted_dir/sdk/10/Lib/$msvc_sdk_version/ucrt/$msvc_target/
_crt_libs=$msvc_extracted_dir/sdk/VC/Tools/MSVC/$msvc_tools_version/lib/$msvc_target/

function make_wine_path() {
    v=`realpath "$1"`
    $msvc_wine_exec winepath -w "$v"
}

export LIB="`make_wine_path \"$_sdk_libs\"`;`make_wine_path \"$_ucrt_libs\"`;`make_wine_path \"$_crt_libs\"`"

_args=""
for v in $@; do
    num_of_slash=`tr -dc '/' <<< "$v" | wc -c`
    num_of_colon=`tr -dc ':' <<< "$v" | wc -c`
    if [ "$num_of_slash" -gt "1" ] && [ "$num_of_colon" -eq "0" ]; then
        v=`$msvc_wine_exec winepath -w $v`
    fi
    _args="$_args $v"
done

exec $msvc_wine_exec $_target_exec $_args
