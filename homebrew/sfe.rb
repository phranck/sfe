class Sfe < Formula
  desc "SF Symbols Extractor - Extract individual SVG files with embedded metadata from SF Symbols 7.2"
  homepage "https://github.com/phranck/sfe"
  url "https://github.com/phranck/sfe/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "7d0858fb2ddeced14e338afa88fff3ff198782462f7e773deed4c8bcfc5ff971"
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
