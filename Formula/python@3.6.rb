class PythonAT36 < Formula
  desc "Interpreted, interactive, object-oriented programming language"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.6.10/Python-3.6.10.tar.xz"
  sha256 "0a833c398ac8cd7c5538f7232d8531afef943c60495c504484f308dac3af40de"
  head "https://github.com/python/cpython.git", :branch => "3.6"

  # setuptools remembers the build flags python is built with and uses them to
  # build packages later. Xcode-only systems need different flags.
  pour_bottle? do
    reason <<~EOS
      The bottle needs the Apple Command Line Tools to be installed.
        You can install them, if desired, with:
          xcode-select --install
    EOS
    satisfy { MacOS::CLT.installed? }
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "gdbm"
  depends_on "openssl@1.1"
  depends_on "readline"
  depends_on "sqlite"
  depends_on "xz"

  skip_clean "bin/pip3", "bin/pip-3.4", "bin/pip-3.5", "bin/pip-3.6"
  skip_clean "bin/easy_install3", "bin/easy_install-3.4", "bin/easy_install-3.5", "bin/easy_install-3.6"

  resource "setuptools" do
    url "https://pypi.org/packages/source/s/setuptools/setuptools-42.0.2.zip"
    sha256 "c5b372090d7c8709ce79a6a66872a91e518f7d65af97fca78135e1cb10d4b940"
  end

  resource "pip" do
    url "https://www.pypi.org/packages/source/p/pip/pip-19.3.1.tar.gz"
    sha256 "21207d76c1031e517668898a6b46a9fb1501c7a4710ef5dfd6a40ad9e6757ea7"
  end

  resource "wheel" do
    url "https://pypi.org/packages/source/w/wheel/wheel-0.33.6.tar.gz"
    sha256 "10c9da68765315ed98850f8e048347c3eb06dd81822dc2ab1d4fde9dc9702646"
  end

  def install
    # Unset these so that installing pip and setuptools puts them where we want
    # and not into some other Python the user has installed.
    ENV["PYTHONHOME"] = nil
    ENV["PYTHONPATH"] = nil

    xy = (buildpath/"configure.ac").read.slice(/PYTHON_VERSION, (3\.\d)/, 1)
    lib_cellar = prefix/"Frameworks/Python.framework/Versions/#{xy}/lib/python#{xy}"

    args = %W[
      --prefix=#{prefix}
      --enable-ipv6
      --datarootdir=#{share}
      --datadir=#{share}
      --enable-framework=#{frameworks}
      --enable-loadable-sqlite-extensions
      --without-ensurepip
      --with-dtrace
    ]

    args << "--without-gcc" if ENV.compiler == :clang

    cflags   = []
    ldflags  = []
    cppflags = []

    if MacOS.sdk_path_if_needed
      # Help Python's build system (setuptools/pip) to build things on SDK-based systems
      # The setup.py looks at "-isysroot" to get the sysroot (and not at --sysroot)
      cflags  << "-isysroot #{MacOS.sdk_path}"
      ldflags << "-isysroot #{MacOS.sdk_path}"

      if DevelopmentTools.clang_build_version < 1000
        cflags  << "-I/usr/include" # find zlib
      end

      # For the Xlib.h, Python needs this header dir with the system Tk
      # Yep, this needs the absolute path where zlib needed a path relative
      # to the SDK.
      cflags << "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
    end
    # Avoid linking to libgcc https://mail.python.org/pipermail/python-dev/2012-February/116205.html
    args << "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"

    # We want our readline and openssl@1.1! This is just to outsmart the detection code,
    # superenv makes cc always find includes/libs!
    inreplace "setup.py" do |s|
      s.gsub! "do_readline = self.compiler.find_library_file(lib_dirs, 'readline')",
              "do_readline = '#{Formula["readline"].opt_lib}/libhistory.dylib'"
      s.gsub! "/usr/local/ssl", Formula["openssl@1.1"].opt_prefix
    end

    inreplace "setup.py" do |s|
      s.gsub! "sqlite_setup_debug = False", "sqlite_setup_debug = True"
      s.gsub! "for d_ in inc_dirs + sqlite_inc_paths:",
              "for d_ in ['#{Formula["sqlite"].opt_include}']:"
    end

    # Allow python modules to use ctypes.find_library to find homebrew's stuff
    # even if homebrew is not a /usr/local/lib. Try this with:
    # `brew install enchant && pip install pyenchant`
    inreplace "./Lib/ctypes/macholib/dyld.py" do |f|
      f.gsub! "DEFAULT_LIBRARY_FALLBACK = [", "DEFAULT_LIBRARY_FALLBACK = [ '#{HOMEBREW_PREFIX}/lib',"
      f.gsub! "DEFAULT_FRAMEWORK_FALLBACK = [", "DEFAULT_FRAMEWORK_FALLBACK = [ '#{HOMEBREW_PREFIX}/Frameworks',"
    end

    args << "CFLAGS=#{cflags.join(" ")}" unless cflags.empty?
    args << "LDFLAGS=#{ldflags.join(" ")}" unless ldflags.empty?
    args << "CPPFLAGS=#{cppflags.join(" ")}" unless cppflags.empty?

    system "./configure", *args
    system "make"

    ENV.deparallelize do
      # Tell Python not to install into /Applications (default for framework builds)
      system "make", "altinstall", "PYTHONAPPSDIR=#{prefix}"
      system "make", "frameworkinstallextras", "PYTHONAPPSDIR=#{pkgshare}"
    end

    # Any .app get a " 3" attached, so it does not conflict with python 2.x.
    Dir.glob("#{prefix}/*.app") { |app| mv app, app.sub(/\.app$/, " 3.6.app") }

    # Prevent third-party packages from building against fragile Cellar paths
    inreplace Dir[lib_cellar/"**/_sysconfigdata_m_darwin_darwin.py",
                  lib_cellar/"config*/Makefile",
                  frameworks/"Python.framework/Versions/3*/lib/pkgconfig/python-3.?.pc"],
              prefix, opt_prefix

    # Help third-party packages find the Python framework
    inreplace Dir[lib_cellar/"config*/Makefile"],
              /^LINKFORSHARED=(.*)PYTHONFRAMEWORKDIR(.*)/,
              "LINKFORSHARED=\\1PYTHONFRAMEWORKINSTALLDIR\\2"

    # Fix for https://github.com/Homebrew/homebrew-core/issues/21212
    inreplace Dir[lib_cellar/"**/_sysconfigdata_m_darwin_darwin.py"],
              %r{('LINKFORSHARED': .*?)'(Python.framework/Versions/3.\d+/Python)'}m,
              "\\1'#{opt_prefix}/Frameworks/\\2'"

    # A fix, because python and python3 both want to install Python.framework
    # and therefore we can't link both into HOMEBREW_PREFIX/Frameworks
    # https://github.com/Homebrew/homebrew/issues/15943
    ["Headers", "Python", "Resources"].each { |f| rm(prefix/"Frameworks/Python.framework/#{f}") }
    rm prefix/"Frameworks/Python.framework/Versions/Current"

    # Symlink the pkgconfig files into HOMEBREW_PREFIX so they're accessible.
    (lib/"pkgconfig").install_symlink Dir["#{frameworks}/Python.framework/Versions/#{xy}/lib/pkgconfig/*"]

    # Remove the site-packages that Python created in its Cellar.
    (prefix/"Frameworks/Python.framework/Versions/#{xy}/lib/python#{xy}/site-packages").rmtree

    %w[setuptools pip wheel].each do |r|
      (libexec/r).install resource(r)
    end
  end

  def post_install
    ENV.delete "PYTHONPATH"

    xy = (prefix/"Frameworks/Python.framework/Versions").children.min.basename.to_s
    site_packages = HOMEBREW_PREFIX/"lib/python#{xy}/site-packages"
    site_packages_cellar = prefix/"Frameworks/Python.framework/Versions/#{xy}/lib/python#{xy}/site-packages"

    # Fix up the site-packages so that user-installed Python software survives
    # minor updates, such as going from 3.3.2 to 3.3.3:

    # Create a site-packages in HOMEBREW_PREFIX/lib/python#{xy}/site-packages
    site_packages.mkpath

    # Symlink the prefix site-packages into the cellar.
    site_packages_cellar.unlink if site_packages_cellar.exist?
    site_packages_cellar.parent.install_symlink site_packages

    # Write our sitecustomize.py
    rm_rf Dir["#{site_packages}/sitecustomize.py[co]"]
    (site_packages/"sitecustomize.py").atomic_write(sitecustomize)

    # Remove old setuptools installations that may still fly around and be
    # listed in the easy_install.pth. This can break setuptools build with
    # zipimport.ZipImportError: bad local file header
    # setuptools-0.9.8-py3.3.egg
    rm_rf Dir["#{site_packages}/setuptools*"]
    rm_rf Dir["#{site_packages}/distribute*"]
    rm_rf Dir["#{site_packages}/pip[-_.][0-9]*", "#{site_packages}/pip"]

    %w[setuptools pip wheel].each do |pkg|
      (libexec/pkg).cd do
        system bin/"python3.6", "-s", "setup.py", "--no-user-cfg", "install",
               "--force", "--verbose", "--install-scripts=#{bin}",
               "--install-lib=#{site_packages}",
               "--single-version-externally-managed",
               "--record=installed.txt"
      end
    end

    rm_rf [bin/"pip", bin/"easy_install"]
    mv bin/"wheel", bin/"wheel3"

    # Install unversioned symlinks in libexec/bin.
    {
      "easy_install" => "easy_install-#{xy}",
      "pip"          => "pip3",
      "wheel"        => "wheel3",
    }.each do |unversioned_name, versioned_name|
      (libexec/"bin").install_symlink (bin/versioned_name).realpath => unversioned_name
    end

    # post_install happens after link
    %W[pip3.6 pip#{xy} easy_install-#{xy} wheel3].each do |e|
      (HOMEBREW_PREFIX/"bin").install_symlink bin/e
    end

    # Help distutils find brewed stuff when building extensions
    include_dirs = [HOMEBREW_PREFIX/"include", Formula["openssl@1.1"].opt_include,
                    Formula["sqlite"].opt_include]
    library_dirs = [HOMEBREW_PREFIX/"lib", Formula["openssl@1.1"].opt_lib,
                    Formula["sqlite"].opt_lib]

    cfg = prefix/"Frameworks/Python.framework/Versions/#{xy}/lib/python#{xy}/distutils/distutils.cfg"

    cfg.atomic_write <<~EOS
      [install]
      prefix=#{HOMEBREW_PREFIX}

      [build_ext]
      include_dirs=#{include_dirs.join ":"}
      library_dirs=#{library_dirs.join ":"}
    EOS
  end

  def sitecustomize
    xy = (prefix/"Frameworks/Python.framework/Versions").children.min.basename.to_s

    <<~EOS
      # This file is created by Homebrew and is executed on each python startup.
      # Don't print from here, or else python command line scripts may fail!
      # <https://docs.brew.sh/Homebrew-and-Python>
      import re
      import os
      import sys

      if sys.version_info[0] != 3:
          # This can only happen if the user has set the PYTHONPATH for 3.x and run Python 2.x or vice versa.
          # Every Python looks at the PYTHONPATH variable and we can't fix it here in sitecustomize.py,
          # because the PYTHONPATH is evaluated after the sitecustomize.py. Many modules (e.g. PyQt4) are
          # built only for a specific version of Python and will fail with cryptic error messages.
          # In the end this means: Don't set the PYTHONPATH permanently if you use different Python versions.
          exit('Your PYTHONPATH points to a site-packages dir for Python 3.x but you are running Python ' +
               str(sys.version_info[0]) + '.x!\\n     PYTHONPATH is currently: "' + str(os.environ['PYTHONPATH']) + '"\\n' +
               '     You should `unset PYTHONPATH` to fix this.')

      # Only do this for a brewed python:
      if os.path.realpath(sys.executable).startswith('#{rack}'):
          # Shuffle /Library site-packages to the end of sys.path
          library_site = '/Library/Python/#{xy}/site-packages'
          library_packages = [p for p in sys.path if p.startswith(library_site)]
          sys.path = [p for p in sys.path if not p.startswith(library_site)]
          # .pth files have already been processed so don't use addsitedir
          sys.path.extend(library_packages)

          # the Cellar site-packages is a symlink to the HOMEBREW_PREFIX
          # site_packages; prefer the shorter paths
          long_prefix = re.compile(r'#{rack}/[0-9\._abrc]+/Frameworks/Python\.framework/Versions/#{xy}/lib/python#{xy}/site-packages')
          sys.path = [long_prefix.sub('#{HOMEBREW_PREFIX/"lib/python#{xy}/site-packages"}', p) for p in sys.path]

          # Set the sys.executable to use the opt_prefix, unless explicitly set
          # with PYTHONEXECUTABLE:
          if 'PYTHONEXECUTABLE' not in os.environ:
              sys.executable = '#{opt_bin}/python#{xy}'
    EOS
  end

  def caveats
    if prefix.exist?
      xy = (prefix/"Frameworks/Python.framework/Versions").children.min.basename.to_s
    else
      xy = version.to_s.slice(/(3\.\d)/) || "3.6"
    end
    <<~EOS
      You can install Python packages with
        pip3.6 install <package>

      They will install into the site-package directory
        #{HOMEBREW_PREFIX/"lib/python#{xy}/site-packages"}

      See: https://docs.brew.sh/Homebrew-and-Python
    EOS
  end

  test do
    xy = (prefix/"Frameworks/Python.framework/Versions").children.min.basename.to_s
    # Check if sqlite is ok, because we build with --enable-loadable-sqlite-extensions
    # and it can occur that building sqlite silently fails if OSX's sqlite is used.
    system "#{bin}/python#{xy}", "-c", "import sqlite3"
    # Check if some other modules import. Then the linked libs are working.
    system "#{bin}/python#{xy}", "-c", "import tkinter; root = tkinter.Tk()"
    system "#{bin}/python#{xy}", "-c", "import _gdbm"
    system "#{bin}/python#{xy}", "-c", "import zlib"
    system "#{bin}/python#{xy}", "-c", "import ssl"
    system bin/"pip3.6", "list", "--format=columns"
  end
end
