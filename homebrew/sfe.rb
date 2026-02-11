class Sfe < Formula
  desc "SF Symbols Extractor - Extract individual SVG files with embedded metadata from SF Symbols 7.3"
  homepage "https://github.com/phranck/sfe"
  url "https://github.com/phranck/sfe/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "3c591475c99e5d12fd7538d51ff1f21fd0b23199fb550cb08f9f9cd2e29b5116"
  license "MIT"

  def install
    bin.install "sfe"
    (share/"sfe").install ".data/names.txt", ".data/info.txt"
    (share/"sfe"/"categories").install Dir[".data/categories/*.txt"]
    (share/"sfe"/"monochrome").install ".data/monochrome/svgs.txt"
    (share/"sfe"/"hierarchical").install ".data/hierarchical/svgs.txt"
    (share/"sfe"/"palette").install ".data/palette/svgs.txt"
    (share/"sfe"/"multicolor").install ".data/multicolor/svgs.txt"
  end

  test do
    system bin/"sfe", "--help"
  end
end
