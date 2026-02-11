class Sfe < Formula
  include Language::Python::Virtualenv

  desc "SF Symbols Extractor - Extract individual SVG files from SF Symbols 7.2"
  homepage "https://github.com/phranck/sfe"
  url "https://github.com/phranck/sfe/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "3774b05ad4c1ea0e132a34a55c17b05b0956417524d871fd038fad725880fd2a"
  license "MIT"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/sfe", "--help"
  end
end
