#!/usr/bin/env bash
set -euo pipefail

msvc_base=${msvc_base:-/tmp/msvc}
export WINEPREFIX=$msvc_base/pfx
_msvc_base=$WINEPREFIX/drive_c/MSVC

if [ ! -d "$msvc_base" ]; then
  mkdir "$msvc_base"
  $msvc_wine_exec wineboot -i
  cp --no-preserve=mode -r $msvc_extracted_dir $_msvc_base
fi

_target_exec=$_msvc_base/tools/VC/Tools/MSVC/$msvc_tools_version/bin/Host$msvc_host/$msvc_target/$msvc_exe.exe
_sdk_libs=$_msvc_base/sdk/10/Lib/$msvc_sdk_version/um/$msvc_target/
_ucrt_libs=$_msvc_base/sdk/10/Lib/$msvc_sdk_version/ucrt/$msvc_target/
_crt_libs=$_msvc_base/sdk/VC/Tools/MSVC/$msvc_tools_version/lib/$msvc_target/

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

echo exec $msvc_wine_exec $_target_exec $_args
exec $msvc_wine_exec $_target_exec $_args
