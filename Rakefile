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
  task :all => [:git, :vim, :neovim, :atom, :tmux, :ocaml, :vimperator, :tex, :ag]
  task :nox => [:git, :vim, :neovim, :tmux, :ocaml, :ag]

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

    next unless installed? 'git'
    unless File.directory? "#{home}/.vim/dein"
      mkdir_p "#{home}/.vim/dein/repos/github.com"
      chdir "#{home}/.vim/dein/repos/github.com" do
        sh "git clone git://github.com/Shougo/dein.vim.git Shougo/dein.vim"
      end
    end
    make_symlink 'vim/dein.toml', "#{home}/.vim/dein.toml"
  end

  task :neovim do
    unless File.directory? "#{home}/.config/nvim"
      mkdir_p "#{home}/.config/nvim"
      mkdir "#{home}/.config/nvim/undo"
      mkdir "#{home}/.config/nvim/backups"
      ln_sf "#{home}/.config/nvim", "#{home}/nvim"
    end

    make_symlink 'neovim/init.vim', "#{home}/.config/nvim/init.vim"
    ln_sf "#{home}/.config/nvim/init.vim", "#{home}/.config/nvim/nvimrc"

    next unless installed? 'git'
    unless File.directory? "#{home}/.config/nvim/dein"
      mkdir_p "#{home}/.config/nvim/dein/repos/github.com"
      chdir "#{home}/.config/nvim/dein/repos/github.com" do
        sh "git clone git://github.com/Shougo/dein.vim.git Shougo/dein.vim"
      end
    end
    make_symlink 'neovim/dein.toml', "#{home}/nvim/dein.toml"
  end

  task :atom do
    unless File.directory? "#{home}/.atom"
      mkdir_p "#{home}/.atom"
    end

    make_symlink 'atom/config.cson', "#{home}/.atom/config.cson"
    make_symlink 'atom/init.coffee', "#{home}/.atom/init.coffee"
    make_symlink 'atom/keymap.cson', "#{home}/.atom/keymap.cson"
    make_symlink 'atom/snippets.cson', "#{home}/.atom/snippets.cson"
    make_symlink 'atom/styles.less', "#{home}/.atom/styles.less"
    make_symlink 'atom/atom-packages', "#{home}/.atom/atom-packages"
  end

  task :tmux do
    make_symlink 'tmux/dot.tmux.conf', "#{home}/.tmux.conf"
  end

  task :ocaml do
    make_symlink 'ocaml/dot.ocamlinit', "#{home}/.ocamlinit"
  end

  task :vimperator do
    make_symlink 'vimperator/dot.vimperatorrc', "#{home}/.vimperatorrc"
  end

  task :tex do
    make_symlink 'tex/dot.latexmkrc', "#{home}/.latexmkrc"
  end

  task :ag do
    make_symlink 'ag/dot.agignore', "#{home}/.agignore"
  end

end

namespace :linux do
  desc 'set up dotfiles for Linux'

  task :gentoo do
    if File.exist? "/etc/gentoo-release"
      make_symlink 'gentoo/etc/eix-sync.conf', '/etc/eix-sync.conf'
      make_symlink 'gentoo/etc/portage/make.conf', '/etc/portage/make.conf'
      if File.exist? "/sys/class/power_supply/BAT0" then
        make_symlink 'gentoo/etc/portage/make.conf_laptop', '/etc/portage/make.conf.local'
      else
        make_symlink 'gentoo/etc/portage/make.conf_desktop', '/etc/portage/make.conf.local'
      end

      make_symlink 'gentoo/etc/portage/package.accept_keywords', '/etc/portage/package.accept_keywords'

      unless File.directory? '/etc/portage/package.use'
        if File.exist? '/etc/portage/package.use'
          mv '/etc/portage/package.use', '/etc/portage/package.use.old'
          puts 'Your package.use is moved to package.use.old.'
        end
        mkdir_p '/etc/portage/package.use'
      end

      make_symlink 'gentoo/etc/portage/package.use/my_package.use', '/etc/portage/package.use/my_package.use'
      make_symlink 'gentoo/etc/portage/package.use/package.use', '/etc/portage/package.use/package.use'
      if File.exist? "/sys/class/power_supply/BAT0" then
        make_symlink 'gentoo/etc/portage/package.use/laptop.use', '/etc/portage/package.use/laptop.use'
      else
        make_symlink 'gentoo/etc/portage/package.use/desktop.use', '/etc/portage/package.use/desktop.use'
      end

      unless File.directory? '/etc/portage/repos.conf'
        mkdir_p '/etc/portage/repos.conf'
      end
      make_symlink 'gentoo/etc/portage/repos.conf/gentoo.conf', '/etc/portage/repos.conf/gentoo.conf'
      make_symlink 'gentoo/etc/portage/repos.conf/layman.conf', '/etc/portage/repos.conf/layman.conf'
      unless File.exist? "/etc/portage/repos.conf/local.conf"
        copy("#{$this_script_dir}/gentoo/etc/portage/repos.conf/local.conf", '/etc/portage/repos.conf/local.conf')
        puts 'If you have local overlay, edit /etc/portage/repos.conf/local.conf.'
      end
    end
  end


  task :setup => ['common:all', :xmonad, :X, :notification]
  task :setup_nox => ['common:nox', :notification]

  task :xmonad do
    unless File.directory? "#{home}/.xmonad"
      mkdir "#{home}/.xmonad"
    end
    make_symlink 'xmonad/xmonad.hs', "#{home}/.xmonad/xmonad.hs"
    if File.directory? "/sys/class/power_supply/BAT0" then
      make_symlink 'xmonad/dot.xmobarrc_laptop', "#{home}/.xmobarrc"
    else
      make_symlink 'xmonad/dot.xmobarrc_desktop', "#{home}/.xmobarrc"
    end
    make_symlink 'xmonad/dot.stalonetrayrc', "#{home}/.stalonetrayrc"
  end

  task :X do
    make_symlink 'X/dot.xprofile', "#{home}/.xprofile"
    make_symlink 'X/dot.Xresources', "#{home}/.Xresources"
    make_symlink 'X/dot.compton.conf', "#{home}/.compton.conf"
    make_symlink 'X/dot.Xmodmap', "#{home}/.Xmodmap"
  end

  task :notification do
    puts '----------------------------------------------'
    puts 'If you using gentoo, exec "sudo rake gentoo".'
    puts '----------------------------------------------'
  end

end

namespace :mac do
  desc 'set up dotfiles for Mac OS X'
  task :setup => ['common:all']
end

case platform
when /mswin(?!ce)|mingw|cygwin|bccwin/
  raise 'Windows is not supported.'
when /linux/
  desc 'Linux'
  task :setup => ['linux:setup']
  task :setup_nox => ['linux:setup_nox']
  task :gentoo => ['linux:gentoo']
when /darwin/
  desc 'MacOSX'
  task :setup => ['mac:setup']
else
  raise 'Unknown platform.'
end
