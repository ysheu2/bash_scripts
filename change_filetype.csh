for g in *.img

do echo $g

name=$(awk 'BEGIN{f=substr(ARGV[1],1,5);print f}' $g)

mri_convert -i $g -it analyze -ot nii -o $name.nii

done