#! /usr/bin/env sh
wget https://github.com/OpenRefine/OpenRefine/releases/download/2.6-beta.1/openrefine-linux-2.6-beta.1.tar.gz
tar xzvf openrefine-linux-2.6-beta.1.tar.gz
rm openrefine-linux-2.6-beta.1.tar.gz
mv openrefine-linux-2.6-beta.1 ~/openrefine

echo 'alias refine="sh ~/openrefine/refine -i 0.0.0.0"' >> ~/.bashrc
source ~/.bashrc
