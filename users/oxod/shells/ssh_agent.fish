if status --is-interactive
  if test -f ~/.ssh/environment
    source ~/.ssh/environment
  end

  if test \( "$SSH_AGENT_PID" != "" \) -a \( "$SSH_AUTH_SOCK" != "" \) -a \( -S "$SSH_AUTH_SOCK" \)
    if string match -rv "/run/user/.*" "$SSH_AUTH_SOCK" >/dev/null
      if ps -p "$SSH_AGENT_PID" >/dev/null
        set -e SSH_ASKPASS
        exit
      end
    end
  end

  if test "$SSH_AGENT_PID" != ""
    kill -s TERM "$SSH_AGENT_PID" 2>/dev/null
  end
  
  set a (ssh-agent) >/dev/null
  set s (string match -r '.*=[^;]*' $a)
  rm ~/.ssh/environment 2> /dev/null
  for l in $s
    set v (string replace -r '=' ' ' $l)
    eval "set -x" $v 
    echo "set -x " $v >> ~/.ssh/environment
    ssh-add 2> /dev/null
  end
end
