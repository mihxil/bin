# hele algemene dingen. Moeten altijd werken. Ook voor su en root:
alias ls='ls -FG'
alias r='reset'
alias mv='mv -i -v'
alias cp='cp -i -v'
#alias rm='rm -v'

alias j='jobs'
alias par='tar hzc --exclude=CVS -f'
alias ppar='tar zc --exclude=CVS --exclude=WEB-INF -f'
alias di='disown -h'


alias Cd='pushd .;cd'
alias i='dirs -l -v'


alias g="grep --exclude-dir=.svn -r -n "
alias pp='python -mjson.tool'
alias e='emacsclient -n'
#alias e='open -a Emacs.app; open -a Emacs.app'

# stupid windows explorer sometimes needs restart because dock gets messed up
alias kill_explorer="taskkill.exe /F /IM explorer.exe ; explorer.exe & disown"

alias h='history | tail -20'
alias pcd='pushd .; cd'
alias ncdu="ncdu --color off"


umask 002
set bell-style visible
shopt -s histappend



export DATE=date
export PYTHONIOENCODING="UTF-8"
#export PG=/Library/PostgreSQL/latest
#export PG=/Library/PostgreSQL/13
export PSQL_HISTORY=${HOME}/.pg_history
export HISTCONTROL=ignoreboth:erasedups
export LESSCHARSET=utf-8
export LC_ALL=
export LC_CTYPE=en_US.UTF-8
export LC_COLLATE=en_US.UTF-8
export EDITOR=emacsclient


