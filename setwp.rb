# typed: false
# frozen_string_literal: true

require "language/go"

class Setwp < Formula
  desc "Command-line utility to set wallpaper on Yosemite and up"

  homepage "https://github.com/alexcormier/setwp"
  url "https://github.com/alexcormier/setwp/archive/v1.1.2.tar.gz"
  sha256 "747ac9fc45fa0e2517f70f3342e235e794c926b47c1a8ad897ac87b6fc83f743"
  head "https://github.com/alexcormier/setwp.git"

  bottle do
    root_url "https://github.com/alexcormier/setwp/releases/download/v1.1.2"
    sha256 cellar: :any, yosemite:   "337f0e61289f417ba601a16b21cb70fdfbe4a93b0a00bb09c051bc25086e07f8"
    sha256 cellar: :any, el_capitan: "337f0e61289f417ba601a16b21cb70fdfbe4a93b0a00bb09c051bc25086e07f8"
    sha256 cellar: :any, sierra:     "337f0e61289f417ba601a16b21cb70fdfbe4a93b0a00bb09c051bc25086e07f8"
  end

  depends_on "go" => :build
  depends_on macos: :yosemite

  go_resource "github.com/docopt/docopt-go" do
    url "https://github.com/docopt/docopt-go.git",
        revision: "784ddc588536785e7299f7272f39101f7faccc3f"
  end

  go_resource "github.com/mattn/go-sqlite3" do
    url "https://github.com/mattn/go-sqlite3.git",
        revision: "47fc4e5e9153645da45af6a86a5bce95e63a0f9e"
  end

  # needed for go-sqlite3
  go_resource "golang.org/x/net" do
    url "https://github.com/golang/net.git",
        revision: "054b33e6527139ad5b1ec2f6232c3b175bd9a30c"
  end

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/alexcormier/"
    ln_s buildpath, buildpath/"src/github.com/alexcormier/setwp"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "setwp"

    bin.install "setwp"
    bash_completion.install "completion/setwp-completion.bash"
    zsh_completion.install "completion/setwp-completion.zsh" => "_setwp"
  end

  test do
    assert_equal `#{bin}/setwp --version`.strip, "setwp version #{version}"
  end
end
