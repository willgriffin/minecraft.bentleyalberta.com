{ pkgs }:
let
  minecraftVersion = "1.21.1";
  fabricLoaderVersion = "0.18.4";
  installerVersion = "1.1.1";
in {
  # Fabric Server Launcher
  fabricServer = pkgs.fetchurl {
    url = "https://meta.fabricmc.net/v2/versions/loader/${minecraftVersion}/${fabricLoaderVersion}/${installerVersion}/server/jar";
    hash = "sha256-YGkfY/kNWs4ojo8JZOKmnDyqnaFIp9G6ecjAC8zwJaM=";
  };

  # Fabric API - Required by most mods
  fabricApi = pkgs.fetchurl {
    url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/m6zu1K31/fabric-api-0.116.7+1.21.1.jar";
    hash = "sha256-CAGMxIyXQVo4AWoA29Wix6Rgumt6BRaQqMs9u16EgqQ=";
  };

  # FabricProxy-Lite - Velocity modern forwarding support
  fabricProxyLite = pkgs.fetchurl {
    url = "https://cdn.modrinth.com/data/8dI2tmqs/versions/KqB3UA0q/FabricProxy-Lite-2.10.1.jar";
    hash = "sha256-NnN7Ysel37Z5rD+san2xD5pCMxf7oZV0vE1HK0cRx0I=";
  };

  # Version metadata for CI/CD
  meta = {
    inherit minecraftVersion fabricLoaderVersion installerVersion;
    fabricApiVersion = "0.116.7+1.21.1";
    fabricProxyLiteVersion = "2.10.1";
  };
}
