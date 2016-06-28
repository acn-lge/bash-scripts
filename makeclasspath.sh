#!/bin/bash


pathsep=:
dir=.
system=`uname -s`
recur=false

wcn=`echo -n " " | wc -l`
wcc=`echo " \c" | wc -l`

if [ "$wcn" -eq 0 ]; then
   NL="-n"
   NC=""
else
   NL=""
   NC="\\c"
fi

usage="Usage: $0: [-d directory] [-s separator-type] [-p prefix-string]
            where \nseparator-type = [unix|win]"

while getopts d:hHp:rs: name
do
  case $name in
    d) dir=$OPTARG
       ;;

    p) prefix=$OPTARG
       ;;

    s) if [ "$OPTARG" = "win" ]; then
         pathsep=\;
       else
         pathsep=:
       fi
       ;;

    r) recur=true
       ;;

    H|h) echo $usage
       exit 1
       ;;
  esac
done

if [ ! -d $dir ]; then
  echo "ERROR: Cannot location directory [$dir]; cannot continue"
  exit 1
fi

#
#  Two different behaviors depending on whether or not the user wants recursive decent
#
#  If no recursive decent, then a plain shell built-in "for file in" loop is used
#  to generate the list of files.  Then, depending upon whether Windows separators
#  were requested and we're running in Cygwin, cygpath is called.
#
if [ "$recur" = "false" ]; then

   if [ "$system" = "CYGWIN_NT-5.1" -a "$pathsep" = ";" ]; then
      clpth=`for jarfile in $dir/*.jar; do echo ${NL} "\`cygpath -w ${jarfile}\`${pathsep}${NC}"; done | sed "s/${pathsep}\$//g"`
   else
      clpth=`for jarfile in $dir/*.jar; do echo ${NL} "${jarfile}${pathsep}${NC}"; done | sed "s/${pathsep}\$//g"`
   fi

   echo "$clpth"
#
#  If recursive decent is desired, "find" is used instead of the shell built-in.  Otherwise
#  the processing is the same.
#
else

   if [ "$system" = "CYGWIN_NT-5.1" -a "$pathsep" = ";" ]; then
      find $dir -name '*.jar' -depth -exec cygpath -w {} \; | awk "BEGIN{firsttime=1;pathsep=\"$pathsep\"}{if (!firsttime) {printf(\"%s%s\",pathsep,\$1);}else{printf(\"%s\",\$1);firsttime=0}}END{printf(\"\\n\");}"
   else
      find $dir -name '*.jar' -depth -print | awk "BEGIN{firsttime=1;pathsep=\"$pathsep\"}{if (!firsttime) {printf(\"%s%s\",pathsep,\$1);}else{printf(\"%s\",\$1);firsttime=0}}END{printf(\"\\n\");}"
   fi
fi

#
#  All done
#
exit 0

