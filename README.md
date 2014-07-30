# go-install


Install GO programming language and configure workspace in the current working directory



## Requirements

At this moment, the script is only tested in Ubuntu 14.04 64-bit.


## Instruction

1. Create your workspace directory (preferably in your $HOME directory, ex: `~/go`)
2. Get the script and make it executable : `chmod +x install.sh`
3. run it : `./install.sh`

The script should download GO if it is not currently installed (or found) and install it automatically. The GO binary will be added to the PATH environment automatically through `/etc/profile`.

The script will also add the worspace paths to `~/.profile` and create the `bin`, `pkg` and `src` folder automatically.


## Limitations

Currently, there is not auto-remove or auto-clean. Removing go (in `/usr/local/go`) and undoing all the changes that the script has made (in `/etc/profile` and `~/.profile`) must be made manually.


## License

Do whatever you want with this. I am not responsible for the mess you do.
