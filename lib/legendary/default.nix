{ lib
, makeDesktopItem
, symlinkJoin
, writeShellScriptBin

, legendary-gl
, wine
, winetricks

, icon ? null
, location ? "$HOME/Games/${name}"
, meta ? { }
, name ? ""
, pname ? ""
, tricks ? [ ]
, wineFlags ? ""
}:

let
  # concat winetricks args
  tricksString = with builtins;
    if (length tricks) > 0 then
      concatStringsSep " " tricks
    else
      "-V";

  script = writeShellScriptBin pname ''
    export DXVK_HUD=compiler
    export WINEESYNC=1
    export WINEFSYNC=1
    export WINEPREFIX="${location}"

    PATH=${wine}/bin:${winetricks}/bin:${legendary-gl}/bin:$PATH

    if [ ! -d "$WINEPREFIX" ]; then
      # install tricks
      winetricks -q ${tricksString}
      wineserver -k
    fi

    legendary update ${name} --base-path ${location}
    ${gamemode}/bin/gamemoderun legendary launch ${name} --base-path ${location}
    wineserver -w
  '';

  desktopItems = makeDesktopItem {
    name = pname;
    exec = "${script}/bin/${pname}";
    inherit icon;
    desktopName = name;
    categories = "Game;";
  };
in
symlinkJoin {
  name = pname;
  paths = [ desktopItems script ];

  inherit meta;
}
