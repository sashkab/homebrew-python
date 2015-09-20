# homebrew-python

This [Homebrew](http://brew.sh) tap provides formulæ to install multiple Python versions.

We currently support Python 3.3.6, Python 3.4.3, and Python 3.5.0.

## How do I install these formulæ?

`brew install zoidbergwill/python/<formula>`

Or `brew tap zoidbergwill/python` and then `brew install <formula>`.

## Usage

```sh
$ brew install python34
$ pip3.4 install -U pip setuptools
```

We don't ever install to `pip3`, `pyvenv`, or `python3`, since we don't know which Python version you want to use in general. Eventually I hope to add support for that somehow, though using [pyenv](https://github.com/yyuu/pyenv) might be a better solution.

## Troubleshooting
Please check the main [Homebrew troubleshooting guide](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Troubleshooting.md#troubleshooting) and then [open an issue in this tap](https://github.com/Homebrew/homebrew-python/issues/new).

## How to submit a new formula
* Fork this repository on GitHub.
* Clone to your Mac.
* Read [Python for Formula Authors](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Python-for-Formula-Authors.md) and look at the other formulæ here.
* In your locally cloned `homebrew-python` repo, create a new branch: `git checkout --branch my_new_formula`
* Write/edit your formula (ruby file). Check [Homebrew's documentation](https://github.com/Homebrew/homebrew/tree/master/share/doc/homebrew#readme) for details.
* Test it locally! `brew install ./my-new-formula.rb`. Does it install? Note, `./<formula>.rb` will target the local file.
* `git push --set-upstream origin my-new-formula` to get it into your GitHub fork as a new branch.
* If you have to change something, add a commit and `git push`.
* On GitHub, select your new branch and then click the "Pull Request" button.
