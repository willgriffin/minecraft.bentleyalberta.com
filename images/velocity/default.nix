{ pkgs, jre }:
let
  plugins = import ./plugins.nix { inherit pkgs; };
in {
  image = pkgs.dockerTools.buildLayeredImage {
    name = "velocity";
    tag = "latest";

    contents = [
      jre
      pkgs.cacert
    ];

    extraCommands = ''
      mkdir -p app/plugins
      cp ${plugins.velocity} app/velocity.jar
      cp ${plugins.geyser} app/plugins/Geyser-Velocity.jar
      cp ${plugins.floodgate} app/plugins/floodgate-velocity.jar
    '';

    config = {
      User = "1000:1000";
      WorkingDir = "/app";
      Entrypoint = [ "${jre}/bin/java" ];
      Cmd = [
        "-Xms512M"
        "-Xmx1G"
        "-XX:+UseG1GC"
        "-XX:G1HeapRegionSize=4M"
        "-XX:+UnlockExperimentalVMOptions"
        "-XX:+ParallelRefProcEnabled"
        "-XX:+AlwaysPreTouch"
        "-jar"
        "velocity.jar"
      ];
      ExposedPorts = {
        "25565/tcp" = {};
        "19132/udp" = {};
      };
      Env = [
        "JAVA_HOME=${jre}"
      ];
    };
  };
}
