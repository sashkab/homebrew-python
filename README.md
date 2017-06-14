# homebrew-python

This [Homebrew](http://brew.sh) tap provides formulae to install multiple [universal] Python versions. It currently provides Python 2.7.13, Python 3.3.6, Python 3.4.6, Python 3.5.3 and Python 3.6.1. For building universal (i.e i386/x86_64) formulae it uses [sashkab/universal](https://github.com/sashkab/homebrew-universal) tap.

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

Replace `X` in example below with either `3` for Python 3.3, `4` for Python 3.4, `5` for Python 3.5, or `6` for Python 3.6.

```bash
brew install sashkab/python/python3X  [--universal]
pip3.X install -U pip setuptools
```

## Acknowledgement

This repository started as a fork of the [zoidbergwill/homebrew-python][1].

[1]: https://github.com/zoidbergwill/homebrew-python
