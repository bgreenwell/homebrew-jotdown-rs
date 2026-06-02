class JotdownRs < Formula
  desc "A minimalist, command-line jotting utility that's fast, private, and git-friendly."
  homepage "https://github.com/bgreenwell/jotdown-rs"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bgreenwell/jotdown-rs/releases/download/v0.2.0/jotdown-rs-aarch64-apple-darwin.tar.xz"
      sha256 "3cc46c291beba01c510ff72d01c0c6b196b8acd09795bf86b57f119a102d783b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bgreenwell/jotdown-rs/releases/download/v0.2.0/jotdown-rs-x86_64-apple-darwin.tar.xz"
      sha256 "c14187124e104af9b35dfb933b4156e2f80cec7684300431059b0eac335a860f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bgreenwell/jotdown-rs/releases/download/v0.2.0/jotdown-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9e850291897e79b31fa1403f963d807282936dd11a59c5d32065dc0cc95bc1e4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bgreenwell/jotdown-rs/releases/download/v0.2.0/jotdown-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "928cf5c0db54d3f3ed44f4f28c34a1058117996035687fc966a8022cf72df7ad"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "jd" if OS.mac? && Hardware::CPU.arm?
    bin.install "jd" if OS.mac? && Hardware::CPU.intel?
    bin.install "jd" if OS.linux? && Hardware::CPU.arm?
    bin.install "jd" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
