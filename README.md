# homebrew-python

## About this project

This [Homebrew](http://brew.sh) tap provides formulae to install multiple Python versions.

Python Version | Latest revision
---------------|----------------
Python 3.6     | 3.6.14
Python 3.7     | 3.7.12
Python 3.8     | 3.8.12

## Installing formulae

Replace `X` in examples below with minor version of Python --  `5` for Python 3.5, `6` for Python 3.6, `7` for Python 3.7, or `8` for Python 3.8.

Python 3.X will be installed into `/usr/local/opt/python@3.X`, as a keg, i.e without linking into `/usr/local/bin` in order to avoid conflicts with the python formulae.

```bash
brew install sashkab/python/python@3.X
```

You can use it to create a virtual environment by passing full path to the Python executable:

```bash
/usr/local/opt/python@3.X/bin/python3.X -mvenv <path to venv>
```

In order to update to latest version of `pip`, `setuptools` and `wheel`, use following command:

```bash
/usr/local/opt/python@3.X/bin/python3.X -mpip install -U pip setuptools wheel
```

## Python 2.7

Python 2.7 has been removed from this repository in early January 2020 after it reached end-of-life. See #46 for details.

## Acknowledgement

This repository started as a fork of the [zoidbergwill/homebrew-python][1].

[1]: https://github.com/zoidbergwill/homebrew-python
[46]: https://github.com/sashkab/homebrew-python/issues/46
