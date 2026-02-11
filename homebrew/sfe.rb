class Sfe < Formula
  desc "SF Symbols Extractor - Extract individual SVG files with embedded metadata from SF Symbols 7.3"
  homepage "https://github.com/phranck/sfe"
  url "https://github.com/phranck/sfe/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "3405809730c17e11a2fc8194b13cac4edbb7f72a952e15cae8ea96fe0044db6c"
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
