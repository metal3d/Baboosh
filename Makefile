all: doc

doc: man pdf

man:
	rst2man doc/man.rst > doc/baboosh.man

pdf:
	sed -r 's/^(["a-zA-Z].*)::/\1\n\n.. code-block:: bash    /g' doc/man.rst | tee | rst2pdf -o doc/Baboosh-starting-guide.pdf
