#!/bin/bash
chmod +x ./install_quarto_extensions.sh
./install_quarto_extensions.sh parmsam/quarto-flashcards parmsam/quarto-quiz quarto-ext/shinylive
rstudio-server start
