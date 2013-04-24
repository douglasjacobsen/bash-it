SCM_THEME_PROMPT_PREFIX=""
SCM_THEME_PROMPT_SUFFIX=""

SCM_THEME_PROMPT_DIRTY=" ${bold_red}✗${normal}"
SCM_THEME_PROMPT_CLEAN=" ${bold_green}✓${normal}"
SCM_GIT_CHAR="${bold_green}±${normal}"

case $TERM in
        xterm*)
        TITLEBAR="${cyan}\w${normal}"
        ;;
        *)
        TITLEBAR=""
        ;;
esac

parse_git_dirty () {
	DIRTY=${SCM_THEME_PROMPT_CLEAN}
	git diff --no-ext-diff --quiet --exit-code || DIRTY=${SCM_THEME_PROMPT_DIRTY}
	if [ git ls-files --others --exclude-standard --error-unmatch -- ':/*' > /dev/null 2> /dev/null ]; then
		DIRTY=${SCM_THEME_PROMPT_DIRTY}
	fi
	echo $DIRTY
}
parse_git_branch () {
	if [[ -f .git/HEAD ]]; then GIT=yes
	elif which git &> /dev/null && [[ -n "$(git symbolic-ref HEAD 2> /dev/null)" ]]; then GIT=yes
	fi

	if [ -z $GIT ];
	then
		return
	else
		br_name=`git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1/"`
		echo "$purple[${SCM_GIT_CHAR}$purple][$blue$br_name $(parse_git_dirty)$purple]"
	fi
}

prompt() {
    my_ps_host="${bold_yellow}\h${normal}";
    my_ps_user="${red}\u${normal}";
    my_ps_root="${red}\u${normal}";
    my_ps_path="${cyan}\w${normal}";

	if [[ -z "$THEME_PROMPT_CLOCK_FORMAT" ]]
	then
		clock="${green}\t${normal}"
	else
		clock="${green}$THEME_PROMPT_CLOCK_FORMAT${normal}"
	fi

    PS1="\[\e]0;\u@\h: \w\a\]${purple}┌─[$my_ps_root${purple}][$my_ps_host${purple}][${my_ps_path}${purple}]$(parse_git_branch)${purple}[$clock${purple}]
${purple}└─▪ ${reset_color}"
}


# Define PS1
PROMPT_COMMAND=prompt

PS2="${purple}└─▪ ${reset_color}"
PS3=">> "
