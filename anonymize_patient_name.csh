for g in */raw/*.par

do

echo $g;

#find the variable "Patient name" and delete that entire row, and then output the new file with '_new' as extension
grep -vwE "Patient name" $g > $g'_new'
 
#remove the original par file that has the patient's name
rm $g

#get rid of the new par file's '_new' extension (par and rec has to share the same name)
mv $g'_new' $g

done
