class Sfe < Formula
  desc "SF Symbols Extractor - Extract individual SVG files from SF Symbols 7.2"
  homepage "https://github.com/phranck/sfe"
  url "https://github.com/phranck/sfe/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "3774b05ad4c1ea0e132a34a55c17b05b0956417524d871fd038fad725880fd2a"
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
