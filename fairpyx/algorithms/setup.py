# setup.py

from setuptools import setup
from Cython.Build import cythonize

setup(
    ext_modules = cythonize("improve_student_best_bundles.pyx")
)
