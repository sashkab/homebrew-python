# homebrew-python

This [Homebrew](http://brew.sh) tap provides formulae to install multiple Python versions.

We currently provide Python 3.3.6, Python 3.4.6, Python 3.5.3 and Python 3.6.1. 
We support building universal (i.e i386/x86_64) versions of these formulae using [sashkab/universal](https://github.com/sashkab/homebrew-universal) tap.

## Installing formulae

```bash
brew install sashkab/python/pythonXY
```

Or

```bash
brew tap sashkab/python
brew install pythonXY
```

### Python 3.3

```bash
brew install sashkab/python/python33  [--universal]
pip3.3 install -U pip setuptools
```

### Python 3.4

```bash
brew install sashkab/python/python34  [--universal]
pip3.4 install -U pip setuptools
```

### Python 3.5

```bash
brew install sashkab/python/python35 [--universal]
pip3.5 install -U pip setuptools
```

### Python 3.6

```bash
brew install sashkab/python/python36 [--universal]
pip3.6 install -U pip setuptools
```
