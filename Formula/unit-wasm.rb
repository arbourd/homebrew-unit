class UnitWasm < Formula
  desc "Ruby module for Unit application server"
  homepage "https://unit.nginx.org"
  url "https://unit.nginx.org/download/unit-1.31.1.tar.gz"
  sha256 "9df604d49cb57ac0103202efb0f9373e3e48a7dd888c94af10d4f96ccded7d71"
  head "https://hg.nginx.org/unit", using: :hg

  depends_on "openssl"
  depends_on "unit@1.31.1"
  depends_on "wasmtime"

  def install
    system "./configure",
              "--prefix=#{prefix}",
              "--sbindir=#{bin}",
              "--logdir=#{var}/log",
              "--log=#{var}/log/unit/unit.log",
              "--runstatedir=#{var}/run",
              "--pid=#{var}/run/unit/unit.pid",
              "--control=unix:#{var}/run/unit/control.sock",
              "--modules=#{HOMEBREW_PREFIX}/lib/unit/modules",
              "--statedir=#{var}/state/unit",
              "--tmpdir=/tmp",
              "--openssl",
              "--cc-opt=-I#{Formula["openssl"].opt_prefix}/include -DNXT_HAVE_ISOLATION_ROOTFS=1",
              "--ld-opt=-L#{Formula["openssl"].opt_prefix}/lib"

    inreplace "build/autoconf.data",
        "NXT_MODULESDIR='#{HOMEBREW_PREFIX}/lib/unit/modules'",
        "NXT_MODULESDIR='#{lib}/unit/modules'"

    system "./configure", "wasm", "--module=wasm",
      "--include-path=#{HOMEBREW_PREFIX}/usr/include/",
      "--lib-path=#{HOMEBREW_PREFIX}/lib/"
    system "make", "wasm-install"
  end
end
