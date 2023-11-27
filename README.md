# Path Copier and Converter
These small shell scripts can be used to either copy a WSL2 path in the Windows clipboard
or to convert a WSL2 path into its Windows counterpart

# Required
To use the cpy* scripts, clip.exe must be installed in WSL2

# Usage
Add the files to your shell config
```bash
source '/path/to/the/file/cpyp.sh'
source '/path/to/the/file/cpypw.sh'
source '/path/to/the/file/cnvpw.sh'
```

Now they can be used directly in the shell like this
```bash
> cpypw file.txt
```
