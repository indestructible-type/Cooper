#!/bin/bash
export PYTHONV=$(python3 -c 'import sys; v=sys.version_info; print(f"python{v.major}.{v.minor}")')
export SUBMODULE_INIT=$(git submodule status | grep ^- | wc -l)
declare _PYTHONPATH _PYTHONPATH2 _OLDPYTHONPATH
_PYTHONPATH="py/local/lib/$PYTHONV/dist-packages"
_PYTHONPATH2="${_PYTHONPATH/local}"
_PYTHONPATH3="${_PYTHONPATH/dist-packages/site-packages}"
_PYTHONPATH4="${_PYTHONPATH2/dist-packages/site-packages}"
_PYTHONPATH="${PWD}/${_PYTHONPATH}"
_PYTHONPATH2="${PWD}/${_PYTHONPATH2}"
_PYTHONPATH3="${PWD}/${_PYTHONPATH3}"
_PYTHONPATH4="${PWD}/${_PYTHONPATH4}"
_OLDPYTHONPATH="$(python3 -c "import sys; print(':'.join(sys.path)[1:])")"
export PYTHONPATH="$(eval echo "${_PYTHONPATH}:${_PYTHONPATH2}:${_PYTHONPATH3}:${_PYTHONPATH4}:${_OLDPYTHONPATH}")"
export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python
if test $SUBMODULE_INIT -gt 0; then
  git submodule init
  git submodule update --recursive
fi
if [ ! -d py ]; then
  pip install -U --prefix=py git+https://github.com/ctrlcctrlv/sfdnormalize git+https://github.com/MFEK/sfdLib.py
fi
