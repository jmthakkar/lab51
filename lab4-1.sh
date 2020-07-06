#!/bin/sh
goodexit()
{
if [ -s temp ]
then rm temp
exit
fi
exit
}
goodexit1()
{
if [ -s temp ]
then rm temp
exit
fi
exit
}
badexit()
{
if [ -s temp ]
then rm temp
exit 1
fi
exit 1
}
badexit1()
{
if [ -s temp ]
then rm temp
exit 1
fi
exit 1
}
l()
{
cat temp
}
ci()
{
echo Found courses are:
while read -r files
do
course=$(grep "COURSE NAME:" $files | cut -b 14-)
credit=$(grep "CREDITS:" $files | cut -b 11-)
echo $course has $credit credits
done <temp
}
course_info()
{
echo Found courses are:
  # The $course_files variable contains list of all courses.
  for course in $course_files
  do
     # read can read from files. d1 and d2 are summy variables which contain
     # "COURSE and "NAME:" entries. The $course_name variable gets the course name entry 
     read d1 d2 course_name < $course
     
     # To find credit, first, we need to find the credit line and then look for the credit number 
     credits=`grep "CREDITS:[[:space:]]* [0-9]" $course | grep -o [0-9]` 
     echo $course_name has $credits credits.
  done
}
sl()
{
echo List:
while read -r temp; do
course=$(grep "[0-9]\{6\}" "$temp" -o >>_2)
done <temp
sort -u _2
rm _2
}
sc()
{
echo List of unique Student numbers:
while read -r file; do
course=$(grep "[0-9]\{6\}" "$file" -o >>_2)
done <temp
echo There are $(sort -u _2 | wc -l) registered students in all courses.
rm _2

}
cc()
{
echo There are $(cat temp | wc -l) course files.
}
help_fun()
{
echo "l or list: lists found courses
ci: gives the name of all courses plus number of credits
sl: gives a unique list of all students registered in all courses
sc: gives the total number of unique students registered in all courses
cc: gives the total numbers of found course files.
h or help: prints the current message.
q or quit: exits from the script"
rm temp
}
if [ $1 ]
then

files=$(find "$1" -type f -name "*.rec" -perm -444> temp)
if [ ! "$(cat temp | wc -l)" = 0 ]; then
while true; do
printf "command: " # print as per instructions
read -r input # read the input from the user
if [ $input = q ] || [ $input = Quit ] || [ $input = quit ]
then echo good bye
 goodexit
elif [ $input = l ] || [ $input = list ] || [ $input = List ] || [ $input = el ]
then l
elif [ $input = h ] || [ $input = help ]
then help_fun
elif [ $input = ci ]
then ci
elif [ $input = sl ]
then sl
elif [ $input = cc ]
then cc
elif [ $input = sc ]
then sc
else
echo unrecognized command!
fi
done
else 
echo There is no readable files.
fi
else bad input try again!
fi
