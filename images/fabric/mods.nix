{ pkgs }:
let
  minecraftVersion = "1.21.1";
  fabricLoaderVersion = "0.18.4";
  installerVersion = "1.1.1";
in {
  # Fabric Server Launcher
  fabricServer = pkgs.fetchurl {
    url = "https://meta.fabricmc.net/v2/versions/loader/${minecraftVersion}/${fabricLoaderVersion}/${installerVersion}/server/jar";
    hash = "sha256-18r5y360ph68g6xd39s8l6fslg4wlvi682cgiqlcwnhdz5iiysb0";
  };

  # Fabric API - Required by most mods
  fabricApi = pkgs.fetchurl {
    url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/m6zu1K31/fabric-api-0.116.7+1.21.1.jar";
    hash = "sha256-1942higbngfbm281c1bsdfx61967lbaxn03a04w5lhcpik28q088";
  };

  # FabricProxy-Lite - Velocity modern forwarding support
  fabricProxyLite = pkgs.fetchurl {
    url = "https://cdn.modrinth.com/data/8dI2tmqs/versions/KqB3UA0q/FabricProxy-Lite-2.10.1.jar";
    hash = "sha256-0hn7253jnisdpis9b8gv2wrl56hgn5ynmb1zmiwvdpx5qxi7nwrn";
  };

  # Version metadata for CI/CD
  meta = {
    inherit minecraftVersion fabricLoaderVersion installerVersion;
    fabricApiVersion = "0.116.7+1.21.1";
    fabricProxyLiteVersion = "2.10.1";
  };
}
