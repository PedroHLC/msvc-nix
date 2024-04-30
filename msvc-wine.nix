{ lib
, stdenvNoCC
, makeWrapper
, wineWowPackages
, wine ? wineWowPackages.stable
, msvc
}:

# NOTE: Directly port of https://github.com/est31/msvc-wine-rust/blob/master/linker-scripts/linker.sh
let
  host = "x64";
in
stdenvNoCC.mkDerivation (final: {
  pname = "msvc-wine";
  inherit (msvc) version passthru meta;

  src = ./wrap.sh;

  nativeBuildInputs = [ makeWrapper ];
  dontUnpack = true;
  dontBuild = true;

  preparePhase = ''
    runHook prePrepare

    patchShebangs wrap.sh

    runHook postPrepare
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    for _target in 'x86 i686-pc-windows' 'x64 x86_64-pc-windows'; do
      read -a target <<< "$_target"
      for exe in bscmake cl cvtres dumpbin editbin ifc lib link ml mspdbcmf mspdbsrv nmake undname xdcmake; do
        echo "''${target[1]}-msvc-$exe"
        makeWrapper $src "$out/bin/''${target[1]}-msvc-$exe" \
          --set msvc_host ${host} \
          --set msvc_exe "$exe" \
          --set msvc_target "''${target[0]}" \
          --set msvc_wine_exec '${wine}/bin/wine' \
          --set msvc_tools_version '${final.passthru.toolsVersion}' \
          --set msvc_sdk_version '${final.version}' \
          --set msvc_extracted_dir '${msvc}'
      done
    done

    runHook postInstall
  '';
})
