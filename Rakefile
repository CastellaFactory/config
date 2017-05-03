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
  task :all => [:git, :vim, :neovim, :fish, :atom, :tmux, :ocaml, :vimperator, :tex]
  task :nox => [:git, :vim, :neovim, :fish, :tmux, :ocaml]

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
    ln_sf "#{home}/.vim", "#{home}/.config/nvim"
    make_symlink 'vim/dot.vimrc', "#{home}/.config/nvim/init.vim"
    make_symlink 'vim/dein.toml', "#{home}/.config/nvim/dein.toml"

  end

  task :fish do
    unless File.directory? "#{home}/.config/fish"
      mkdir_p "#{home}/.config/fish"
    end
    make_symlink 'fish/config.fish', "#{home}/.config/fish/config.fish"
    make_symlink 'fish/functions', "#{home}/.config/fish"
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
    make_symlink 'X/dot.xsession', "#{home}/.xsession"
    make_symlink 'X/dot.xprofile', "#{home}/.xprofile"
    make_symlink 'X/dot.Xresources', "#{home}/.Xresources"
    make_symlink 'X/dot.compton.conf', "#{home}/.compton.conf"
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
