{ pkgs, jre }:
let
  mods = import ./mods.nix { inherit pkgs; };
in {
  image = pkgs.dockerTools.buildLayeredImage {
    name = "fabric";
    tag = "latest";

    contents = [
      jre
      pkgs.cacert
      pkgs.busybox  # For debugging (ls, cat, sh, etc.)
    ];

    extraCommands = ''
      mkdir -p app/mods app/config app/scripts app/world app/logs
      cp ${mods.fabricServer} app/fabric-server-launcher.jar
      cp ${mods.fabricApi} app/mods/fabric-api.jar
      cp ${mods.fabricProxyLite} app/mods/FabricProxy-Lite.jar

      # Create eula.txt
      echo "eula=true" > app/eula.txt

      # Set ownership for user 1000 (server needs to write files)
      chown -R 1000:1000 app
    '';

    config = {
      User = "1000:1000";
      WorkingDir = "/app";
      Entrypoint = [ "${jre}/bin/java" ];
      Cmd = [
        "-Xms4G"
        "-Xmx8G"
        "-XX:+UseG1GC"
        "-XX:+ParallelRefProcEnabled"
        "-XX:MaxGCPauseMillis=200"
        "-XX:+UnlockExperimentalVMOptions"
        "-XX:+DisableExplicitGC"
        "-XX:+AlwaysPreTouch"
        "-XX:G1NewSizePercent=30"
        "-XX:G1MaxNewSizePercent=40"
        "-XX:G1HeapRegionSize=8M"
        "-XX:G1ReservePercent=20"
        "-XX:G1HeapWastePercent=5"
        "-XX:G1MixedGCCountTarget=4"
        "-XX:InitiatingHeapOccupancyPercent=15"
        "-XX:G1MixedGCLiveThresholdPercent=90"
        "-XX:G1RSetUpdatingPauseTimePercent=5"
        "-XX:SurvivorRatio=32"
        "-XX:+PerfDisableSharedMem"
        "-XX:MaxTenuringThreshold=1"
        "-jar"
        "fabric-server-launcher.jar"
        "nogui"
      ];
      ExposedPorts = {
        "25565/tcp" = {};
        "25575/tcp" = {};  # RCON
      };
      Volumes = {
        "/app/world" = {};
        "/app/scripts" = {};
        "/app/config" = {};
      };
      Env = [
        "JAVA_HOME=${jre}"
      ];
    };
  };
}
