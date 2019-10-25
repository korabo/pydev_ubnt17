docker build -f Dockerfile -t korabo/pydev:ubnt17 ./
: docker run --rm -it korabo/pydev:ubnt17 bash
: docker save korabo/pydev:ubnt17 > korabo_pydev-ubnt17.tar
:  docker load < korabo_pydev-ubnt17.tar
