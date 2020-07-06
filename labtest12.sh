#!/bin/sh
# First Name : Jimit Last Name: Thakkar Student Number: 215535206
# First Name : Jimit Last Name: Thakkar Student Number: 215535206
# First Name : Jimit Last Name: Thakkar Student Number: 215535206
# First Name : Jimit Last Name: Thakkar Student Number: 215535206
help()
{
  echo "Here are defined commands:
creg: give the list of course names with the total number of students registered in each course.
stc ######: gives the name of all course names in which the student with ###### id registered in.
gpa ######: gives the GPA of the student defined with id ###### using the following formula: (course_1*credit_1 +   . . . + course_n*credit_n) / (credit_1+ . . . + credit_n)
h: prints the current message."
}
help12()
{
  echo "Here are defined commands:
creg: give the list of course names with the total number of students registered in each course.
stc ######: gives the name of all course names in which the student with ###### id registered in.
gpa ######: gives the GPA of the student defined with id ###### using the following formula: (course_1*credit_1 +   . . . + course_n*credit_n) / (credit_1+ . . . + credit_n)
h: prints the current message."
}

help23()
{
  echo "Here are defined commands:
creg: give the list of course names with the total number of students registered in each course.
stc ######: gives the name of all course names in which the student with ###### id registered in.
gpa ######: gives the GPA of the student defined with id ###### using the following formula: (course_1*credit_1 +   . . . + course_n*credit_n) / (credit_1+ . . . + credit_n)
h: prints the current message."
}
if [ $1 ]
then
	if [ ! $2 ]
	then
		echo "You should enter the path name for course files and at least one command.
		Use: lab3.sh path command [arg1 arg2 ...]
		For the list of all commands use:
		Example1: lab3.sh . h
		For the list of number of registered students in each course use:
		Example2: lab3.sh . creg"
	fi
	files=$(find $1 -type f -name "*.rec" -perm -444)
	fileswitht=$(find $1 -type f -name "*.rec" -perm -444) >temp

	if [ "$files" ] 
	then
		command=$2
		command1=$3
		if [ "$command" = h ]
		then help 
		elif [ "$command" = creg ]
		then
			for file in $files
			do
				course=$(sed -n -e '/COURSE/I s/.*\: *//p' $file)
				course=\"${course}\"
				course=`echo $course | sed -e 's/^[[:space:]]*//' | tr [:lower:] [:upper:]`
				regstudents=0
				while read -r line
				do
					if [ ! -z "$line" ]
					then
						regstudents=$((regstudents+1))
					fi
				done <"$file"
				regstudents=$((regstudents-2))
				echo In "$course", $regstudents students register.
			done
		elif [ "$command" = stc ]
		then 
			count=0
			if [ $3 ] && [ ${#3} -eq 6 ]
			then
				if ! grep -q "$command1" $files
				then
					echo The student with id : $command1 is not registered in any course.
				fi
				if grep -q "$command1" $files
				then
					echo The student with id: $command1, is registered in the following courses:
					for file in $files
					do
						course=$(sed -n -e '/COURSE/I s/.*\: *//p' $file)
						course=`echo $course | sed -e 's/^[[:space:]]*//' | tr [:lower:] [:upper:]`
						credit=$(grep -i "CREDITS" $file | grep "[0-9]" -o)
						count=$((count+1))
						echo -e "$count. $course which has $credit credits"	
					done	
				fi	
			else 
				echo The student id should be 6 numbers.			
			fi
		elif [ "$command" = gpa ]
		then 
			if [ $3 ] && [ ${#3} -eq 6 ]
			then
				if ! grep -q "$command1" $files
				then
					echo The student with id : $command1 is not registered in any course.
				else
					top=0
					bottom=0
					for file in $files
					do
						if grep -q "$command1" $file
						then
							grades=$(grep "$3" "$file" | cut -b 7- | xargs)
							credits=$(grep -i "CREDITS" $file | grep "[0-9]" -o)
							for grade in $grades
							do
								top=$(( top + ( grade * credits )))
							done
							bottom=$(( bottom + credits ))				
						fi
					done
					final=$((top / bottom))
					echo "The GPA for the student with id: $command1 is $final."
				fi
			else
				echo The student id should be 6 numbers.
			fi
		fi
	else
		echo There is no readable *.rec file in the specified path or its subdirectories.
	fi
else
	echo "You should enter the path name for course files and at least one command.
	Use: lab3.sh path command [arg1 arg2 ...]
	For the list of all commands use:
	Example1: lab3.sh . h
	For the list of number of registered students in each course use:
	Example2: lab3.sh . creg"
fi
