class Sfe < Formula
  desc "SF Symbols Extractor - Extract individual SVG files from SF Symbols 7.2"
  homepage "https://github.com/phranck/sfe"
  url "https://github.com/phranck/sfe/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "fac0a278d36d69281b42aba747fcdd9617ee329e4b187e9afe264ced44745766"
  license "MIT"

  def install
    bin.install "sfe"
    (share/"sfe").install "names.txt", "info.txt"
    (share/"sfe"/"hierarchical").install "hierarchical/svgs.txt"
    (share/"sfe"/"monochrome").install "monochrome/svgs.txt"
  end

  test do
    system bin/"sfe", "--help"
  end
end
