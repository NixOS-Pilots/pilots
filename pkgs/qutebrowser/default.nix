{ stdenv
, lib
, fetchFromGitHub
, fetchzip
, python3
, wrapQtAppsHook
, glib-networking
, asciidoc
, docbook_xml_dtd_45
, docbook_xsl
, libxml2
, libxslt
, withPdfReader ? true
, pipewireSupport ? stdenv.isLinux
, pipewire
, qtwayland
, qtbase
, qtwebengine
, enableWideVine ? false
, widevine-cdm
  # can cause issues on some graphics chips
, enableVulkan ? false
, vulkan-loader
, ...
}:

let
  isQt6 = lib.versions.major qtbase.version == "6";
  pdfjs = let version = "4.0.379"; in
    fetchzip {
      url = "https://github.com/mozilla/pdf.js/releases/download/v${version}/pdfjs-${version}-dist.zip";
      hash = "sha256-Ymc/8PWFTQP08XlJsz+aB8Mwxm+p0bq4GRPvg8FDZ00=";
      stripRoot = false;
    };
  version = "unstable-2024-03-24-93b8438";
in
python3.pkgs.buildPythonPackage {
  pname = "qutebrowser" + lib.optionalString (!isQt6) "-qt5";
  inherit version;
  src = fetchFromGitHub {
    owner = "qutebrowser";
    repo = "qutebrowser";
    rev = "93b8438ebc418d880fb3f0d4eb5ae86df08488dc";
    hash = "sha256-h0thhffr38OQszJbz9fNbOTdACEXWDFeN8dMkUaR6GY=";
  };

  # Needs tox
  doCheck = false;

  buildInputs = [
    qtbase
    glib-networking
  ];

  nativeBuildInputs = [
    wrapQtAppsHook
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
    libxml2
    libxslt
    python3.pkgs.pygments
  ];

  propagatedBuildInputs = with python3.pkgs; ([
    pyyaml
    (if isQt6 then pyqt6-webengine else pyqtwebengine)
    jinja2
    pygments
    # scripts and userscripts libs
    tldextract
    beautifulsoup4
    readability-lxml
    pykeepass
    stem
    pynacl
    # extensive ad blocking
    adblock
    # for the qute-bitwarden user script to be able to copy the TOTP token to clipboard
    pyperclip
  ] ++ lib.optional stdenv.isLinux qtwayland
  );

  patches = [
    ./fix-restart.patch
  ];

  dontWrapQtApps = true;

  postPatch = ''
    substituteInPlace qutebrowser/misc/quitter.py --subst-var-by qutebrowser "$out/bin/qutebrowser"

    sed -i "s,/usr,$out,g" qutebrowser/utils/standarddir.py
  '' + lib.optionalString withPdfReader ''
    sed -i "s,/usr/share/pdf.js,${pdfjs},g" qutebrowser/browser/pdfjs.py
  '';

  installPhase = ''
    runHook preInstall

    make -f misc/Makefile \
      PYTHON=${python3.pythonOnBuildForHost.interpreter} \
      PREFIX=. \
      DESTDIR="$out" \
      DATAROOTDIR=/share \
      install

    runHook postInstall
  '';

  postInstall = ''
    # Patch python scripts
    buildPythonPath "$out $propagatedBuildInputs"
    scripts=$(grep -rl python "$out"/share/qutebrowser/{user,}scripts/)
    for i in $scripts; do
      patchPythonScript "$i"
    done
  '';

  preFixup =
    let
      libPath = lib.makeLibraryPath [ pipewire ];
    in
    ''
      makeWrapperArgs+=(
        # Force the app to use QT_PLUGIN_PATH values from wrapper
        --unset QT_PLUGIN_PATH
        "''${qtWrapperArgs[@]}"
        # avoid persistant warning on starup
        --set QT_STYLE_OVERRIDE Fusion
        ${lib.optionalString pipewireSupport ''--prefix LD_LIBRARY_PATH : ${libPath}''}
        ${lib.optionalString enableVulkan ''
          --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [vulkan-loader]}
          --set-default QSG_RHI_BACKEND vulkan
        ''}
        ${lib.optionalString enableWideVine ''--add-flags "--qt-flag widevine-path=${widevine-cdm}/share/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so"''}
        --set QTWEBENGINE_RESOURCES_PATH "${qtwebengine}/resources"
      )
    '';

  meta = with lib; {
    homepage = "https://github.com/qutebrowser/qutebrowser";
    changelog = "https://github.com/qutebrowser/qutebrowser/blob/v${version}/doc/changelog.asciidoc";
    description = "Keyboard-focused browser with a minimal GUI";
    license = licenses.gpl3Plus;
    mainProgram = "qutebrowser";
    platforms = if enableWideVine then [ "x86_64-linux" ] else qtwebengine.meta.platforms;
    maintainers = with maintainers; [ kev ];
  };
}
