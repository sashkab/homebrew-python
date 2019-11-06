# homebrew-python

## About this project

This [Homebrew](http://brew.sh) tap provides formulae to install multiple Python versions.

Python Version | Latest revision
---------------|----------------
Python 2.7     | 2.7.17
Python 3.5     | 3.5.9
Python 3.6     | 3.6.9
Python 3.7     | 3.7.5
Python 3.8     | 3.8.0

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

Python 2.7 will be installed into `/usr/local/opt/python27`, as a keg, i.e without linking into `/usr/local/bin` in order to avoid conflicts with the python formulae.

**python27 formulae will be removed on or around January 1, 2020**, see [#46][46] for details.

```bash
brew install sashkab/python/python27
/usr/local/opt/python27/bin/pip2.7 install -U pip setuptools
```

You can use it to create a virtual environment by passing full path to the Python executable:

```bash
virtualenv -p /usr/local/opt/python27/bin/python2.7 <path to venv>
```

### Python 3.X

Replace `X` in example below with either `5` for Python 3.5, `6` for Python 3.6, or `7` for Python 3.7.

```bash
brew install sashkab/python/python3X
pip3.X install -U pip setuptools
```

### Python 3.8

Python 3.8 will be installed into `/usr/local/opt/python@3.8`, as a keg, i.e without linking into `/usr/local/bin` in order to avoid conflicts with the python formulae.

```bash
brew install sashkab/python/python@3.8
pip3.8 install -U pip setuptools
```

You can use it to create a virtual environment by passing full path to the Python executable:

```bash
/usr/local/opt/python@3.8/bin/python3.8 -mvenv <path to venv>
```

## Acknowledgement

This repository started as a fork of the [zoidbergwill/homebrew-python][1].

[1]: https://github.com/zoidbergwill/homebrew-python
[46]: https://github.com/sashkab/homebrew-python/issues/46
