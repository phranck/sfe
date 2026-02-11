class Sfe < Formula
  desc "SF Symbols Extractor - Extract individual SVG files with embedded metadata from SF Symbols 7.2"
  homepage "https://github.com/phranck/sfe"
  url "https://github.com/phranck/sfe/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "c6dad117b1e68733ce38e18fffc6c05e0d941f01ee706d581005b19aff99cf2c"
  license "MIT"

  def install
    bin.install "sfe"
    (share/"sfe").install ".data/names.txt", ".data/info.txt"
    (share/"sfe"/"categories").install Dir[".data/categories/*.txt"]
    (share/"sfe"/"hierarchical").install ".data/hierarchical/svgs.txt"
    (share/"sfe"/"monochrome").install ".data/monochrome/svgs.txt"
  end

  test do
    system bin/"sfe", "--help"
  end
end
