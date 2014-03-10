require 'fileutils'
require 'rbconfig'
include FileUtils
include RbConfig

$this_script_dir = File.expand_path(File.dirname(__FILE__))
home = File.expand_path('~')

# platform
platform = CONFIG["target_os"].downcase


def command_exists?(cmd)
  paths = ENV['PATH'].split(':').uniq
  paths.any? do |path|
    p = "#{path}/#{cmd}"
    File.exists?(p) && File.executable?(p)
  end
end

def installed?(name)
  unless command_exists? name
    puts "#{name} is not installed. task is skipped."
    false
  else
    true
  end
end

def make_symlink(src, dest)
  ln_sf "#{$this_script_dir}/#{src}", dest
end


namespace :common do
  task :all => [:git, :vim, :zsh, :tmux, :OCaml, :Vimperator]

  task :git do
    make_symlink 'git/dot.gitconfig', "#{home}/.gitconfig"
    make_symlink 'git/dot.gitignore', "#{home}/.gitignore"
  end

  task :vim do
    unless File.directory? "#{home}/.vim"
      mkdir "#{home}/.vim"
      ln_sf "#{home}/.vim", "#{home}/vim"
      mkdir "#{home}/.vim/undo"
      mkdir "#{home}/.vim/backups"
    end

    make_symlink 'vim/dot.vimrc', "#{home}/.vim/vimrc"
    make_symlink 'vim/dot.gvimrc', "#{home}/.vim/gvimrc"
    make_symlink 'vim/dot.vimrc_practice', "#{home}/.vim/vimrc_practice"

    next unless installed? 'git'
    unless File.directory? "#{home}/.vim/bundle"
      mkdir "#{home}/.vim/bundle"
      chdir "#{home}/.vim/bundle" do
        sh "git clone git://github.com/Shougo/neobundle.vim.git"
      end
    end
  end

  task :zsh do
    unless File.directory? "#{home}/.zsh"
      mkdir "#{home}/.zsh"
      mkdir "#{home}/.zsh/plugins"
    end

    make_symlink 'zsh/dot.zshenv', "#{home}/.zshenv"
    make_symlink 'zsh/dot.zshrc', "#{home}/.zsh/.zshrc"

    next unless installed? 'git'
    chdir "#{home}/.zsh/plugins" do
    unless File.directory? "#{home}/.zsh/plugins/zaw"
      sh "git clone git://github.com/zsh-users/zaw.git"
    end
    end
  end

  task :tmux do
    unless File.directory? "#{home}/.config"
      mkdir "#{home}/.config"
    end
    make_symlink 'tmux/powerline', "#{home}/.config"
  end

  task :OCaml do
    make_symlink 'dotfiles/dot.ocamlinit', "#{home}/.ocamlinit"
  end

  task :Vimperator do
    make_symlink 'dotfiles/dot.vimperatorrc', "#{home}/.vimperatorrc"
  end

end

namespace :linux do
  desc 'set up dotfiles for Linux'
  task :setup => ['common:all', :tmux, :vim, :zsh, :xmodmap, :awesome, :xmonad, :X]

  task :tmux do
    make_symlink 'tmux/dot.tmux.conf.linux', "#{home}/.tmux.conf"
  end

  task :zsh do
    make_symlink 'zsh/dot.zshenv.linux', "#{home}/.zsh/.zshenv"
    make_symlink 'zsh/dot.zprofile.linux', "#{home}/.zsh/.zprofile"
    make_symlink 'zsh/dot.zshrc.linux', "#{home}/.zsh/.zshrc.linux"
  end

  task :xmodmap do
    make_symlink 'dotfiles/dot.Xmodmap', "#{home}/.Xmodmap"
  end

  task :awesome do
    next unless installed? 'awesome'
    unless File.directory? "#{home}/.config/awesome"
      mkdir_p "#{home}/.config/awesome"
    end
    make_symlink 'awesome/rc.lua', "#{home}/.config/awesome/rc.lua"
  end

  task :xmonad do
    next unless installed? 'xmonad'
    unless File.directory? "#{home}/.xmonad"
      mkdir "#{home}/.xmonad"
    end
    make_symlink 'xmonad/xmonad.hs', "#{home}/.xmonad/xmonad.hs"
    make_symlink 'dotfiles/dot.xmobarrc', "#{home}/.xmobarrc"
    make_symlink 'dotfiles/dot.stalonetrayrc', "#{home}/.stalonetrayrc"
    make_symlink 'dotfiles/dot.fehbg', "#{home}/.fehbg"
  end

  task :X do
    make_symlink 'dotfiles/dot.xprofile', "#{home}/.xprofile"
    make_symlink 'dotfiles/dot.Xresources', "#{home}/.Xresources"
    make_symlink 'dotfiles/dot.xsession', "#{home}/.xsession"
    make_symlink 'dotfiles/dot.compton.conf', "#{home}/.compton.conf"
  end

end

namespace :mac do
  desc 'set up dotfiles for Mac OS X'
  task :setup => ['common:all', :zsh, :tmux]

  task :zsh do
    make_symlink 'zsh/dot.zshenv.mac', "#{home}/.zsh/.zshenv"
    make_symlink 'zsh/dot.zprofile.mac', "#{home}/.zsh/.zprofile"
    make_symlink 'zsh/dot.zshrc.mac', "#{home}/.zsh/.zshrc.mac"
  end

  task :tmux do
    make_symlink 'tmux/dot.tmux.conf.mac', "#{home}/.tmux.conf"
  end

end

case platform
when /mswin(?!ce)|mingw|cygwin|bccwin/
  raise 'Windows is not supported'
when /linux/
  desc 'Linux'
  task :setup => ['linux:setup']
when /darwin/
  desc 'MacOSX'
  task :setup => ['mac:setup']
else
  raise 'Unknown platform'
end
