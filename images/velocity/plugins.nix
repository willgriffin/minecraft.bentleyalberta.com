{ pkgs }:
{
  # Velocity Proxy - Latest 3.4.0-SNAPSHOT
  velocity = pkgs.fetchurl {
    url = "https://api.papermc.io/v2/projects/velocity/versions/3.4.0-SNAPSHOT/builds/559/downloads/velocity-3.4.0-SNAPSHOT-559.jar";
    hash = "sha256-1gdsaa52gf956cqqhfjz5qzv9j1hc4nkjxilimb2dkhyfmqrzi6c";
  };

  # Geyser - Bedrock to Java translation
  geyser = pkgs.fetchurl {
    url = "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/velocity";
    hash = "sha256-0v7ip60yiflk1wv528nz3i6cd42241j13mvrnxnbwrdmxb3qnq57";
  };

  # Floodgate - Account bridging for Bedrock players
  floodgate = pkgs.fetchurl {
    url = "https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/velocity";
    hash = "sha256-05zwarzlns1s33gv776f61m320bycjlfqwv97jwgxs4sb9jmk494";
  };
}
