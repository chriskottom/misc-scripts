#
#  Manage and use multiple Ruby interpreters installed in a globally-accessible
#  location.
#
#  Usage:
#    - Place script in an accessible location - i.e. /usr/local/bin.
#    - Modify as needed
#    - echo "source /path/to/script/ruby_switcher.sh" >> ~/.bashrc
#
#  Inspired by the ruby_switcher.sh script shared by the nice guys at Relevance.
#    http://thinkrelevance.com
#    http://github.com/relevance/etc/blob/3d607c8ac2f76077f27c3cbc0140b04a89f546be/bash/ruby_switcher.sh
#


export ORIGINAL_PATH=$PATH
export RUBY_BASEDIR=/opt/ruby


#
#  Ruby 1.8.6 functions
#
function use_ruby_186 {
 export MY_RUBY_HOME=$RUBY_BASEDIR/ruby-1.8.6-p369
 export GEM_HOME=$RUBY_BASEDIR/gems/ruby/1.8
 update_path
}

function install_ruby_186 {
  install_ruby_from_source "1.8" "6" "369" &&
  use_ruby_186 && install_rake && popd
}


#
#  Ruby 1.8.7 functions
#
function use_ruby_187 {
 export MY_RUBY_HOME=$RUBY_BASEDIR/ruby-1.8.7-p174
 export GEM_HOME=$RUBY_BASEDIR/gems/ruby/1.8
 update_path
}

function install_ruby_187 {
  install_ruby_from_source "1.8" "7" "174" &&
  use_ruby_187 && install_rake && popd
}


#
#  Ruby 1.9.1 functions
#
function use_ruby_191 {
 export MY_RUBY_HOME=$RUBY_BASEDIR/ruby-1.9.1-p243
 export GEM_HOME=$RUBY_BASEDIR/gems/ruby/1.9
 update_path
}

function install_ruby_191 {
  install_ruby_from_source "1.9" "1" "243" &&
  use_ruby_191 && install_rake && popd
}


#
#  Ruby 1.9.2 functions
#
function use_ruby_192 {
 export MY_RUBY_HOME=$RUBY_BASEDIR/ruby-1.9.2-preview1
 export GEM_HOME=$RUBY_BASEDIR/gems/ruby/1.9
 update_path
}

function install_ruby_192 {
  install_ruby_from_source "1.9" "2" "review1" &&
  use_ruby_192 && install_rake && popd
}


#
#  General functions
#
function install_ruby_from_source {
  local ruby_major=$1
  local ruby_minor=$2
  local patch_level=$3
  local ruby_version="ruby-$1.$2-p$patch_level"
  local url="ftp://ftp.ruby-lang.org/pub/ruby/$ruby_major/$ruby_version.tar.gz"

  mkdir -p /tmp && mkdir -p $RUBY_BASEDIR && rm -rf $RUBY_BASEDIR/$ruby_version &&
  pushd /tmp &&
  curl --silent -L -O $url &&
  tar xzf $ruby_version.tar.gz &&
  cd $ruby_version &&
  ./configure --prefix=$RUBY_BASEDIR/$ruby_version --enable-shared &&
  make && make install && cd /tmp &&
  rm -rf $ruby_version.tar.gz $ruby_version
}
function install_rake {
  gem install -q --no-ri --no-rdoc rake
}
function update_path {
 export PATH=$GEM_HOME/bin:$MY_RUBY_HOME/bin:$ORIGINAL_PATH
 export RUBY_VERSION="$(ruby -v | colrm 11)"
 display_ruby_version
}
function display_ruby_version {
 if [[ $SHELL =~ "bash" ]]; then
   echo "Using `ruby -v`"
 fi
 # On ZSH, show it on the right PS1
 export RPS1=$RUBY_VERSION
}

use_ruby_187