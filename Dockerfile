FROM ruby:2.3.1

RUN apt-get update && apt-get install -y vim

# setup the vim directory
RUN mkdir -p /root/.vim/bundle
ADD fixtures/vimrc /root/.vimrc
RUN git clone https://github.com/scrooloose/nerdtree.git /root/.vim/bundle/nerdtree
RUN git clone https://github.com/tpope/vim-commentary.git /root/.vim/bundle/vim-commentary
RUN git clone https://github.com/tpope/vim-unimpaired.git /root/.vim/bundle/vim-unimpaired
RUN git clone https://github.com/VundleVim/Vundle.vim.git /root/.vim/bundle/Vundle.vim

# create an alias for running vundle_migrator
RUN echo 'alias vundle_migrator="/usr/src/app/bin/vundle_migrator -l /root/.vimrc"' >> /root/.bashrc

# set up the working directory
WORKDIR /usr/src/app
ADD . /usr/src/app

RUN bundle install --local
