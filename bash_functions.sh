
GDATE=/usr/bin/date
if [ -z "$WSL_DISTRO_NAME" ] ; then
  #echo "apple?"
  GDATE=/usr/bin/gdate
  # apple
  function cl {
     cd $(dirname $(gfind $HOME/Library/Caches/JetBrains/*/tomcat/* -wholename '*/tomcat/*.log' -printf "%T@ %p\n" | sort -n | tail -1 | awk '{print $2}'))
  }
else
  #echo "WSL $WSL_DISTRO_NAME"
  # wsl
 function clw {
     cd $(dirname $(find $WHOME/AppData/Local/JetBrains/*/tomcat/* -wholename '*/tomcat/*.log' -printf "%T@ %p\n" | sort -n | tail -1 | awk '{print $2}'))
   }
  function clu {
       cd $(dirname $(find $HOME/.cache/JetBrains/*/tomcat/* -wholename '*/tomcat/*.log' -printf "%T@ %p\n" | sort -n | tail -1 | awk '{print $2}'))
     }
  function cl {
     clw
  }
fi



function xless() {
    xmllint -format $1 | less
}

function d () {
    if [ "$1" == "" ]; then
        dirs -l -v | awk "FNR != 1 {print}"
    else
        cd `dirs +$1 | sed "s|~|$HOME|"`
    fi
}

function pd () {
    local pwd=`pwd`
    d $1
    pushd $pwd
}

function po () {
    popd +$1
}

function killport() {
    PORT=`lsof -i :$1 | tail -1 | awk '{print $2}'`
    echo killing $PORT
    kill -9  $PORT
}



function proml {
    case $TERM in
        xterm-color*)
            if [ `whoami` == "root" ]
            then
                ifroot='#'
            else
                ifroot=''
            fi
            dirs=`d | wc -l | sed "s/ //g"`
            thejobs=`jobs | awk '$2 == "Stopped" {printf "%s ", $3}'`
            title="$NAME $dirs $ifroot$thejobs`pwd | sed s-^$HOME-~-`"
            echo -ne "\033]0; merlango $title\007"
            ;;
        *)
            ;;
    esac

}



trim() {
    local -n var=$1 # -n: nameref
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"
}



oc_ps1() {
    config=~/.kube/config
    # collect both times in seconds-since-the-epoch
    one_day_ago=$($GDATE -d 'now - 1 days' +%s)
    file_time=$($GDATE -r "$config" +%s)
    if (( file_time > one_day_ago )) ; then
        # Get current context
        CONTEXT=$(cat $config 2>/dev/null| grep -o '^current-context: [^/]*' | cut -d' ' -f2)
        if [ -n "$CONTEXT" ]; then
            echo "(${CONTEXT##*-})"
        fi
    fi
}

git_branch() {
    _git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$_git_branch" ]; then
        git_status=$(git status --porcelain 2>/dev/null | wc -l)
        trim git_status
        if [ "$git_status" == "0" ] ; then
            git_status=""
        else
            git_status=",$git_status"
        fi
        echo "(${_git_branch}${git_status})"
    fi
}

git_log_for_date() {
    start=$1
    end=$2
    if [ -z "$start" ] ; then
        start=$(date -I)
    fi
    if [ -z "$end" ] ; then
        echo "no end"
        end=$(date -d "$day +1 days" -I)
    fi
    EMP='\033[23;90m'       # emphasis
    NC='\033[0m' # No Color

    #echo "git log --after=${start}T00:00:00 --before=${end}T00:00:00 --reverse"
    for dir in `find . -name ".git" -type d`; do
        parent=$(dirname $dir)
        tempfile=/tmp/$(basename $parent).$day.log
        (cd $parent ; git log --after="${start}T00:00:00" --before="${end}T00:00:00" --reverse) > $tempfile
        if (( $(cat $tempfile | wc -l) >  0 )) ; then
            echo -e "${EMP}$parent${NC}"
	    cat $tempfile
        fi
        rm $tempfile
    done
}

git_log_npo_for_date() {
    start=$1
    end=$2
    if [ -z "$end" ] ; then
        echo "no end"
        end=$(date -d "$start +1 days" -I)
    fi
    dirs=("npo" "github/npo-poms" "github/vpro/vpro-shared")
    while [[ "$start" != "$end" ]]; do

        current_end=$(date --date "$start + 1 day" -I)
        echo "$start - $current_end ${dirs[*]}"
        for dir in ${dirs[@]}; do
            (cd ~/$dir ; git_log_for_date $start $current_end )
	done
        start=$current_end
    done
}

function ts() {
    input=$1
    re='^[0-9]+L?$'
    if [[ $input == "" ]] ; then
        nanoseconds=$(date  +%s%N)
        echo $((nanoseconds / 1000000))
    elif [[ $input =~ $re ]] ; then
        input=${input//L/}
        if (( $input > 9999999999 )) ; then
            input=$((input / 1000))
        fi
        date --date="@$input" -Iseconds
    else
        nanoseconds=$(date --date="$input" +%s%N)
        echo $((nanoseconds / 1000000))
    fi
}

function git_clean_branches() {

   git fetch -p && for branch in $(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'); do git branch -D $branch; done


   for b in `git branch --merged | egrep -v "(^\*|master|main)"`; do echo $b ; git branch -d $b ; done
}
