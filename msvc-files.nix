{ lib
, stdenvNoCC
, fetchurl
, unzip
, msitools
, p7zip
# YOU NEED TO ACCEPT THESE TERMS BEFORE BUILDING
, vsLicenseAccepted ? false # https://www.visualstudio.com/license-terms/mt644918/
, sdkLicenseAccepted ? false # sdk_license.rtf
}:

# NOTE: Directly port of https://github.com/est31/msvc-wine-rust/blob/master/get.sh
let
  dl = path: hash: fetchurl {
    url = "https://download.visualstudio.microsoft.com/download/pr/${path}";
    inherit hash;
  };
in
stdenvNoCC.mkDerivation (final: {
  pname = "msvc-sdk";
  version = "10.0.16299.0";
  outputs = [ "out" "license" ];

  srcs = [
    (dl "100107594/d176ecb4240a304d1a2af2391e8965d4/53174a8154da07099db041b9caffeaee.cab" "sha256-h4fygo9lXJouq4eF97za5CYPO7RXGLeg3ZWERVfaSas=")
    (dl "100107594/d176ecb4240a304d1a2af2391e8965d4/58314d0646d7e1a25e97c902166c3155.cab" "sha256-tcSwBGasDhSidBy1eB+Dii7RJw/lJUfNVRNd9KEgn24=")
    (dl "100107594/d176ecb4240a304d1a2af2391e8965d4/Windows%20SDK%20Desktop%20Libs%20x64-x86_en-us.msi" "sha256-1sPPNkXcteBS2gLErLWO+zlqhbFhNdlGQPVnpaTQsCs=")
    (dl "100107594/d176ecb4240a304d1a2af2391e8965d4/Windows%20SDK%20Desktop%20Libs%20x86-x86_en-us.msi" "sha256-+RjX3JYVufdvAJKe0VLUF8F43UYhyMUw5y7XmNpYy+A=")
    (dl "100107594/d176ecb4240a304d1a2af2391e8965d4/winsdksetup.exe" "sha256-Zk6kh6buGHa3OEw/H1ZoDp3agOgyEqTXYJlHVdOt2c4=")
    (dl "100110573/1a91d4d5ac358c110e7c874fd8c07239/16ab2ea2187acffa6435e334796c8c89.cab" "sha256-aRac4+J7+Kqv3Czx8/TlBB/+fv2fi5G+RwPXXYLl+Zg=")
    (dl "100110573/1a91d4d5ac358c110e7c874fd8c07239/2868a02217691d527e42fe0520627bfa.cab" "sha256-NoxI+DDlhBtdl/M+UfHUiyBk4rhaulzmp+qHjhyRCR8=")
    (dl "100110573/1a91d4d5ac358c110e7c874fd8c07239/6ee7bbee8435130a869cf971694fd9e2.cab" "sha256-8MH0Fih9d3QQcw0jw2XtuNF5hfzoViD8xqELOkRqCDI=")
    (dl "100110573/1a91d4d5ac358c110e7c874fd8c07239/78fa3c824c2c48bd4a49ab5969adaaf7.cab" "sha256-Qo0OdKHx7BPa4hVXg3ZoUEHm7Em/O5LyXL423YYkrpY=")
    (dl "100110573/1a91d4d5ac358c110e7c874fd8c07239/7afc7b670accd8e3cc94cfffd516f5cb.cab" "sha256-zQxqcdHGGIfoyu9p1qqftjeq41ZF3RwIKt3FrQijtsw=")
    (dl "100110573/1a91d4d5ac358c110e7c874fd8c07239/80dcdb79b8a5960a384abe5a217a7e3a.cab" "sha256-Qn7wk+g+xKb5FC8+EYRixFQx63jQI5QSXPmhoEYTMz4=")
    (dl "100110573/1a91d4d5ac358c110e7c874fd8c07239/96076045170fe5db6d5dcf14b6f6688e.cab" "sha256-QmOTcss1eliu1FekqyCCytK5TIkySIWO7ZZY5Ma5B9Q=")
    (dl "100110573/1a91d4d5ac358c110e7c874fd8c07239/a1e2a83aa8a71c48c742eeaff6e71928.cab" "sha256-YQBXK45b1x32P/I85HbTYCjU7fCaD/tJIjRWYbcK1uk=")
    (dl "100110573/1a91d4d5ac358c110e7c874fd8c07239/b2f03f34ff83ec013b9e45c7cd8e8a73.cab" "sha256-sG/njOTvmfvwPCNt+4kZuwyfUs4XyGrbJRXfezx1fxg=")
    (dl "100110573/1a91d4d5ac358c110e7c874fd8c07239/beb5360d2daaa3167dea7ad16c28f996.cab" "sha256-gl8TU3HHj7pooDwteFIOv35B6LGuh8s5Y8JGvGp80N0=")
    (dl "100110573/1a91d4d5ac358c110e7c874fd8c07239/f9ff50431335056fb4fbac05b8268204.cab" "sha256-IRt+Fm4I+nXWBuVUcdWNIxuCY4hfHLBbgaiB7iktiIs=")
    (dl "100110573/1a91d4d5ac358c110e7c874fd8c07239/Universal%20CRT%20Headers%20Libraries%20and%20Sources-x86_en-us.msi" "sha256-15uUkCcKF3A5vXDTYsZzZTKfhjl1Ikjg5C5th7C2FCk=")
    (dl "100120735/59fd0bbd7af55837187bbf971d485bec/05047a45609f311645eebcac2739fc4c.cab" "sha256-i9uSA0SWqlQU/JbB9kkZcVn1YIoa591CdKnpS7yhuVE=")
    (dl "100120735/59fd0bbd7af55837187bbf971d485bec/0b2a4987421d95d0cb37640889aa9e9b.cab" "sha256-Rfg49oYhEAo5zR/9UsQFlFz2pFTftk2CdnstwSZMz3Y=")
    (dl "100120735/59fd0bbd7af55837187bbf971d485bec/13d68b8a7b6678a368e2d13ff4027521.cab" "sha256-SWGGuR1BIpfcZXyPo57znA42qJ7jewXweuzsmnEUQmU=")
    (dl "100120735/59fd0bbd7af55837187bbf971d485bec/463ad1b0783ebda908fd6c16a4abfe93.cab" "sha256-LpHmiBXBDhAXaB4vNaC4okGbyVbYOzgb80qTbNErzHs=")
    (dl "100120735/59fd0bbd7af55837187bbf971d485bec/5a22e5cde814b041749fb271547f4dd5.cab" "sha256-KtYSGn/7DQL6jNm5x5NnCvcXg6TyKN6hoaevD7KhVxU=")
    (dl "100120735/59fd0bbd7af55837187bbf971d485bec/ba60f891debd633ae9c26e1372703e3c.cab" "sha256-t+Dny9UIeFvt8FvMuYqeWQ+Vg0uMZHbHT+e82F75XEM=")
    (dl "100120735/59fd0bbd7af55837187bbf971d485bec/e10768bb6e9d0ea730280336b697da66.cab" "sha256-OExW37gSA1Cf3JeKmL7VBKoIhZsn23/ZGvIpXzCLJNI=")
    (dl "100120735/59fd0bbd7af55837187bbf971d485bec/f9b24c8280986c0683fbceca5326d806.cab" "sha256-4H8MkWTHGSQWmiFeuH78+BR7qUiRflKowKAWzO65Eu8=")
    (dl "100120735/59fd0bbd7af55837187bbf971d485bec/Windows%20SDK%20for%20Windows%20Store%20Apps%20Libs-x86_en-us.msi" "sha256-9LC/R7lspduaCB8nAym37sOeE2ILzbsIN3emwUZSh0A=")
    (dl "10933200/2185d21eb8245d7c79a5e74ade047c1a/microsoft.visualcpp.crt.x64.store.vsix" "sha256-JvpdmEMLQ8nht3LWenluTDN/oN3O7ZVyk21ucO/xSs4=")
    (dl "10933295/e2c969895aaa4974d7d5819e9ee4cdc4/microsoft.visualcpp.crt.x86.store.vsix" "sha256-p7iubDaxSrFwSNXr6p02dhATVGPgLYcALdAc83+ve/E=")
    (dl "11436915/aff3326c9d694e3f92617dcb3827e9f7/microsoft.visualcpp.tools.hostx86.targetx86.vsix" "sha256-pAtSRn0zWUFJR+UpS2OF9q+VtJwqdl4Pf0dJrIJvOpM=")
    (dl "11436965/d360453cfd1f34b6164afe24d1edc4b2/microsoft.visualcpp.tools.hostx86.targetx64.vsix" "sha256-J0H0Iz/H5aX8cyRTPljmPzLQ9DKXXTOjr/0M5KqKygw=")
    (dl "11437778/36f212a9738f5888c73f46e0d25c1db7/microsoft.visualcpp.tools.hostx64.targetx64.vsix" "sha256-tdLPEVNjt2okWM6gF9XF70P7AyZDs1Lje/3ddAjwYWA=")
    (dl "11437792/ade27216a21adb0795b71f57d979f758/microsoft.visualcpp.tools.hostx64.targetx86.vsix" "sha256-K7/KrvmhusuUfXRDHSXiksnNHK7ftI9OIXUt4H5bdHE=")
    (dl "7b52e873-c823-471c-b1e9-ca1224f499fa/99c51d13947424b8bda524668316827157aa30ed87d67be04a41a68a1c64cba8/microsoft.visualc.14.11.crt.x86.desktop.vsix" "sha256-mcUdE5R0JLi9pSRmgxaCcVeqMO2H1nvgSkGmihxky6g=")
    (dl "7b52e873-c823-471c-b1e9-ca1224f499fa/9c227b392eca05884a090216cc7ab600cce804ccdc0e01d0731c6bdc5a36c837/microsoft.visualc.14.11.crt.x64.desktop.vsix" "sha256-nCJ7OS7KBYhKCQIWzHq2AMzoBMzcDgHQcxxr3Fo2yDc=")
  ];

  dontUnpack = true;
  dontBuild = true;
  nativeBuildInputs = [ msitools unzip p7zip ];

  installPhase = ''
    runHook preInstall

    extracted="$PWD/extracted/sdk"
    dl="$PWD/dl"
    mkdir -p "$extracted" "$dl" "$license"

    for _src in $srcs; do
      if [[ "$_src" == *.exe ]]; then
        7z x -i\!u2 -so "$_src" > "$license/sdk_license.rtf"
      fi
    done

  '' + lib.strings.optionalString (!sdkLicenseAccepted) ''
    echo "Need to accept $license/sdk_license.rtf" > /dev/stderr
    exit 1

  '' + ''
    for _src in $srcs; do
      if [[ "$_src" == *.cab ]]; then
        cp "$_src" "$dl/$(stripHash "$_src")"
      fi
    done

    for _src in $srcs; do
      if [[ "$_src" == *.vsix ]]; then
        unzip "$_src" 'Contents/*' -d "$extracted"
        cp -Ra "$extracted/Contents/." "$extracted"
        rm -rf "$extracted/Contents"
      fi
    done

    for _src in $srcs; do
      if [[ "$_src" == *.msi ]]; then
        cp "$_src" "$dl/$(stripHash "$_src")"
        msiextract --directory "$extracted/" "$dl/$(stripHash "$_src")"
        cp -RT "$extracted"/Program\ Files/* "$extracted"
        rm -rf "$extracted"/Program\ Files
      fi
    done

    mv "$extracted" "$out"

    runHook postInstall
  '';

  dontFixup = true;
  dontStrip = true;
  dontPatchELF = true;
  dontPatchShebangs = true;

  passthru.toolsVersion = "14.11.25503";
  meta = {
    license = lib.licenses.unfree;
    broken = !vsLicenseAccepted;
  };
})
