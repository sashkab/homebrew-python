# homebrew-python

## Deprecation notice

Due to Apple's removal of i386 SDK from the Command Line Tools for XCode 10 for macOS 10.13 and not inclusion in to same tools under 10.14, there is no way to
compile and build universal binaries on macOS any longer.

This project is deprecated and no longer supported.

## About this project

This [Homebrew](http://brew.sh) tap provides formulae to install multiple [universal] Python versions. For building universal (i.e i386/x86_64) formulae it uses [sashkab/universal](https://github.com/sashkab/homebrew-universal) tap.

Python Version | Latest revision
---------------|----------------
Python 2.7     | 2.7.15
Python 3.3     | 3.3.6
Python 3.4     | 3.4.6
Python 3.5     | 3.5.5
Python 3.6     | 3.6.6
Python 3.7     | 3.7.0

## Installing formulae

```bash
brew install sashkab/python/pythonXY
```

Or

```bash
brew tap sashkab/python
brew install pythonXY
```

### Python 2.7

Universal Python 2.7 will be installed into `/usr/local/opt/python27`, as a keg, i.e without linking into `/usr/local/bin` in order to avoid conflicts with the python formulae.

```bash
brew install sashkab/python/python27  [--universal]
/usr/local/opt/python27/bin/pip2.7 install -U pip setuptools
```

You can use it to create a virtual environment by passing full path to the Python executable:

```bash
virtualenv -p /usr/local/opt/python27/bin/python2.7 <path to venv>
```

### Python 3.X

Replace `X` in example below with either `3` for Python 3.3, `4` for Python 3.4, `5` for Python 3.5, `6` for Python 3.6, or `7` for Python 3.7.

```bash
brew install sashkab/python/python3X  [--universal]
pip3.X install -U pip setuptools
```

## Acknowledgement

This repository started as a fork of the [zoidbergwill/homebrew-python][1].

[1]: https://github.com/zoidbergwill/homebrew-python
