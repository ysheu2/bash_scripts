	mkdir TBSS/L1
	mkdir TBSS/L2
	mkdir TBSS/L3
	mkdir TBSS/MD
	mkdir TBSS/RD

for k in *_??????
#for k in MRI#:999999. this script will cp and rename the L1, L2, L3, MD, RD images for later processing of these parameters. 

do
	echo $k

	folder=$(awk 'BEGIN{f=substr(ARGV[1],1,9);print f}' $k)
	echo $folder
	
	cp $k/dti_L1.nii.gz TBSS/L1/$folder'_dti_FA.nii.gz'
	cp $k/dti_L2.nii.gz TBSS/L2/$folder'_dti_FA.nii.gz'
	cp $k/dti_L3.nii.gz TBSS/L3/$folder'_dti_FA.nii.gz'
	cp $k/dti_MD.nii.gz TBSS/MD/$folder'_dti_FA.nii.gz'

	fslmaths TBSS/L2/$folder'_dti_FA.nii.gz' -add TBSS/L3/$folder'_dti_FA.nii.gz' TBSS/RD/combined_$folder'_dti_FA.nii.gz'

	fslmaths TBSS/RD/combined_$folder'_dti_FA.nii.gz' -div 2 TBSS/RD/$folder'_dti_FA.nii.gz'

	rm TBSS/RD/combined_$folder'_dti_FA.nii.gz'

done
