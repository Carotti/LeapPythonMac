Python3+ Leap Motion SDK on Mac

Requirements (install with brew):
* C++ compiler (tested with clang 4.2.1)
* swig

Clone this repo and download the latest version of the [Leap Motion SDK](https://developer.leapmotion.com/sdk/v2) into it.

Then just run, replacing `<python>` with whichever version of python you want to make bindings for (tested with python3.6)
```sh
make all PYTHON=<python>
```

And making sure your Leap Motion is plugged in, you should be able to run the sample program
```sh
<python> Sample.py
```