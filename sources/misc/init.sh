#!/bin/bash
export PYTHONV=$(python3 -c 'import sys; v=sys.version_info; print(f"python{v.major}.{v.minor}")')
export SUBMODULE_INIT=$(git submodule status | grep ^- | wc -l)
export PYTHONPATH="py/local/lib/$PYTHONV/dist-packages:$(python3 -c "import sys; print(':'.join(sys.path)[1:])")"
if test $SUBMODULE_INIT -gt 0; then
  git submodule init
  git submodule update --recursive
fi
if [ ! -d py ]; then
  pip install -U --prefix=py git+https://github.com/ctrlcctrlv/sfdnormalize git+https://github.com/MFEK/sfdLib.py
fi
