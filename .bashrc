#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
#PS1='[\u@\h \W]\$ '
PS1='[\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]]\$ '

alias sshcon='ssh 접속아이디@접속주소'
alias bakweb='scp -r 접속아이디@접속주소:~/www ~/; tar -zcvf ~/$(date +%y%m%d)-bakweb.tgz ~/www; rm -rf ~/www'
alias bakdb='ssh 접속아이디@접속주소 mysqldump -u디비아이디 > $(date +%y%m%d).sql; tar -zcvf $(date +%y%m%d)-db.tgz $(date +%y%m%d).sql; rm $(date +%y%m%d).sql'
alias bakall='bakweb; bakdb'

