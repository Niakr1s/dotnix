# This is my nixos dotfiles for future me

## Installation

Consider reading the [article](https://qfpl.io/posts/installing-nixos/) about installing nixos to properly configure disks and enable encryption.

Then there is a great [article](https://www.tonybtw.com/tutorial/nixos-from-scratch/) from TonyBtw about how to use flakes.

This configuration should be cloned into `/home/nea/.dotnix` directory. AFterwards, run `sudo nixos-rebuild switch --flake /home/nea/.dotnix#desktop` and you are gtg.
