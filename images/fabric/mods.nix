{ pkgs }:
let
  minecraftVersion = "1.21.11";
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
    url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/DdVHbeR1/fabric-api-0.141.1+1.21.11.jar";
    hash = "sha256-ald/g72LM8lAQSfRZTGsycQZX0feA5WVfJ1M0J17mMY=";
  };

  # FabricProxy-Lite - Velocity modern forwarding support
  fabricProxyLite = pkgs.fetchurl {
    url = "https://cdn.modrinth.com/data/8dI2tmqs/versions/nR8AIdvx/FabricProxy-Lite-2.11.0.jar";
    hash = "sha256-68er6vbAOsYZxwHrszLeaWbG2D7fq/AkNHIMj8PQPNw=";
  };

  # Version metadata for CI/CD
  meta = {
    inherit minecraftVersion fabricLoaderVersion installerVersion;
    fabricApiVersion = "0.141.1+1.21.11";
    fabricProxyLiteVersion = "2.11.0";
  };
}
