{ pkgs, ... }:
{
  "plugins/Spark.jar" = pkgs.fetchurl rec {
    pname = "spark";
    version = "1.10.172";
    url = "https://ci.lucko.me/job/${pname}/524/artifact/${pname}-bukkit/build/libs/${pname}-${version}-bukkit.jar";
    hash = "sha256:4a37b57559f00c6eea84ee9f026316135b45312748676a1b2640b13c2b844cbd";
  };
  "plugins/Chunky.jar" = pkgs.fetchurl rec {
    pname = "Chunky";
    version = "1.4.40";
    url = "https://cdn.modrinth.com/data/fALzjamp/versions/P3y2MXnd/${pname}-Bukkit-${version}.jar";
    hash = "sha256:2a5477fc80f71012e15ade1ce34dbeb836e17623b28db112492c0f1443c09721";
  };
  "plugins/ViaVersion.jar" = pkgs.fetchurl rec {
    pname = "ViaVersion";
    version = "5.8.0";
    url = "https://github.com/ViaVersion/${pname}/releases/download/${version}/${pname}-${version}.jar";
    hash = "sha256:5c9fd2ab9b3d985e91a98f3fc9872a1817d3e6260a0668c69d786ed4bba6b202";
  };
  "plugins/ViaBackwards.jar" = pkgs.fetchurl rec {
    pname = "ViaBackwards";
    version = "5.8.0";
    url = "https://github.com/ViaVersion/${pname}/releases/download/${version}/${pname}-${version}.jar";
    hash = "sha256:eb79a8616530f6ef5d3e489f0f41d1948e8df25fa9d94612c3b570eef7bbef16";
  };
}
