{ pkgs }:
{
  # Velocity Proxy - Latest 3.4.0-SNAPSHOT
  velocity = pkgs.fetchurl {
    url = "https://api.papermc.io/v2/projects/velocity/versions/3.4.0-SNAPSHOT/builds/559/downloads/velocity-3.4.0-SNAPSHOT-559.jar";
    hash = "sha256-zMSfcXUeziZWjTR2OS1hMMi0Py5fOogxMyW5J4pSur0=";
  };

  # Geyser - Bedrock to Java translation
  geyser = pkgs.fetchurl {
    url = "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/velocity";
    hash = "sha256-p2CLx+q1Zb5st3nXEWQgQpDGTBzfIlE2D5O66IG58Ww=";
  };

  # Floodgate - Account bridging for Bedrock players
  floodgate = pkgs.fetchurl {
    url = "https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/velocity";
    hash = "sha256-JJFZZVqa6P64PGlz7KhkfgExajDOnLPfGDpoS39W/Bc=";
  };
}
