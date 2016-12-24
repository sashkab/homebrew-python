# homebrew-python

This [Homebrew](http://brew.sh) tap provides formulæ to install multiple Python versions.

We currently support Python 3.3.6, Python 3.4.5, Python 3.5.2 and Python 3.6.0.

## How do I install these formulæ?

`brew install sashkab/python/<formula>`

Or `brew tap sashkab/python` and then `brew install <formula>`.

## Usage

```sh
$ brew install python34
$ pip3.4 install -U pip setuptools
```

We make best effort not to conflict with the [python3](https://github.com/Homebrew/homebrew-core/blob/master/Formula/python3.rb) formula in Homebrew, but this is WIP currently.
