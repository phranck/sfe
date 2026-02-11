class Sfe < Formula
  desc "SF Symbols Extractor - Extract individual SVG files with embedded metadata from SF Symbols 7.3"
  homepage "https://github.com/phranck/sfe"
  url "https://github.com/phranck/sfe/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "c025ded1682fc088fddcf750f7f8b1574e186b46b3d683b2af2c5d7c2a6339f6"
  license "MIT"

  def install
    bin.install "sfe"
    (share/"sfe").install ".data/names.txt", ".data/info.txt"
    (share/"sfe"/"categories").install Dir[".data/categories/*.txt"]
    (share/"sfe"/"monochrome").install ".data/monochrome/svgs.txt"
    (share/"sfe"/"dualtone").install ".data/dualtone/svgs.txt"
  end

  test do
    system bin/"sfe", "--help"
  end
end
