# homebrew-python

## About this project

This [Homebrew](http://brew.sh) tap provides formulae to install multiple Python versions.

Python Version | Latest revision
---------------|----------------
Python 2.7     | 2.7.17
Python 3.5     | 3.5.9
Python 3.6     | 3.6.10
Python 3.7     | 3.7.6
Python 3.8     | 3.8.1

## Installing formulae

```bash
brew install sashkab/python/python@X.Y
```

or

```bash
brew tap sashkab/python
brew install python@X.Y
```

Where `X` is a major version of Python `2` or `3`, and `Y` is minor.

### Python 2.7

Python 2.7 will be installed into `/usr/local/opt/python@2.7`, as a keg, i.e without linking into `/usr/local/bin` in order to avoid conflicts with the python formulae.

**python@2.7 formulae will be removed on or around January 1, 2020**, see [#46][46] for details.

```bash
brew install sashkab/python/python@2.7
/usr/local/opt/python@2.7/bin/pip2.7 install -U pip setuptools
```

You can use it to create a virtual environment by passing full path to the Python executable:

```bash
virtualenv -p /usr/local/opt/python@2.7/bin/python2.7 <path to venv>
```

### Python 3.X

Replace `X` in example below with either `5` for Python 3.5, `6` for Python 3.6, `7` for Python 3.7, or `8` for Python 3.8.

Python 3.X will be installed into `/usr/local/opt/python@3.X`, as a keg, i.e without linking into `/usr/local/bin` in order to avoid conflicts with the python formulae.

```bash
brew install sashkab/python/python@3.X
pip3.X install -U pip setuptools
```

You can use it to create a virtual environment by passing full path to the Python executable:

```bash
/usr/local/opt/python@3.X/bin/python3.X -mvenv <path to venv>
```

## Acknowledgement

This repository started as a fork of the [zoidbergwill/homebrew-python][1].

[1]: https://github.com/zoidbergwill/homebrew-python
[46]: https://github.com/sashkab/homebrew-python/issues/46
