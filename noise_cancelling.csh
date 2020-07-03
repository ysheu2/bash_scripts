for g in */functional

do

echo $g 

#concatenating all volumes
3dTcat -prefix $g/daf1.nii $g/daf1/wa*.hdr
3dTcat -prefix $g/daf2.nii $g/daf2/wa*.hdr
3dTcat -prefix $g/faf1.nii $g/faf1/wa*.hdr
3dTcat -prefix $g/faf2.nii $g/faf2/wa*.hdr

#high pass filtering cut-off frequency 0.01hz
3dFourier -highpass 0.01 -prefix $g/tmp_hp_daf1.nii $g/daf1.nii
3dFourier -highpass 0.01 -prefix $g/tmp_hp_daf2.nii $g/daf2.nii
3dFourier -highpass 0.01 -prefix $g/tmp_hp_faf1.nii $g/faf1.nii
3dFourier -highpass 0.01 -prefix $g/tmp_hp_faf2.nii $g/faf2.nii

#calculating mean of original time-series
3dTstat -mean -prefix $g/tmp_mean_daf1.nii $g/daf1.nii
3dTstat -mean -prefix $g/tmp_mean_daf2.nii $g/daf2.nii
3dTstat -mean -prefix $g/tmp_mean_faf1.nii $g/faf1.nii
3dTstat -mean -prefix $g/tmp_mean_faf2.nii $g/faf2.nii 

#adding the mean back
3dcalc -prefix $g/daf1.hp0.01.nii -a $g/tmp_mean_daf1.nii -b $g/tmp_hp_daf1.nii -expr a+b
3dcalc -prefix $g/daf2.hp0.01.nii -a $g/tmp_mean_daf2.nii -b $g/tmp_hp_daf2.nii -expr a+b
3dcalc -prefix $g/faf1.hp0.01.nii -a $g/tmp_mean_faf1.nii -b $g/tmp_hp_faf1.nii -expr a+b
3dcalc -prefix $g/faf2.hp0.01.nii -a $g/tmp_mean_faf2.nii -b $g/tmp_hp_faf2.nii -expr a+b

#spatial smoothing
3dmerge -doall -1blur_fwhm 5 -prefix $g/daf1.hp0.01.blr5.nii $g/daf1.hp0.01.nii
3dmerge -doall -1blur_fwhm 5 -prefix $g/daf2.hp0.01.blr5.nii $g/daf2.hp0.01.nii
3dmerge -doall -1blur_fwhm 5 -prefix $g/faf1.hp0.01.blr5.nii $g/faf1.hp0.01.nii
3dmerge -doall -1blur_fwhm 5 -prefix $g/faf2.hp0.01.blr5.nii $g/faf2.hp0.01.nii

#converting to time-series to percentage signal change units
3dTstat -mean -prefix $g/tmp_daf1.nii $g/daf1.hp0.01.blr5.nii
3dTstat -mean -prefix $g/tmp_daf2.nii $g/daf2.hp0.01.blr5.nii
3dTstat -mean -prefix $g/tmp_faf1.nii $g/faf1.hp0.01.blr5.nii
3dTstat -mean -prefix $g/tmp_faf2.nii $g/faf2.hp0.01.blr5.nii

#creating percentage signal change dataset (time-series -mean)/mean*100
3dcalc -prefix $g/daf1.hp0.01.blr5_psc.nii -a $g/daf1.hp0.01.blr5.nii -b $g/tmp_daf1.nii -expr '(a-b)/b*100'

#censoring out fluctuations more than 3.5% signal change
3dcalc -prefix $g/daf1.thresh3.5.nii -a $g/daf1.hp0.01.blr5_psc.nii -expr 'a*step(3.5-abs(a))'

#making a mask and apply to the thresholded brain image
3dAutomask -prefix $g/mask.nii $g/daf1/wmeanaV0001.hdr #the wmean image only exists in daf1
3dcalc -prefix $g/daf1/daf1.thresh3.5_bet.nii -a $g/daf1.thresh3.5.nii -b $g/mask.nii -expr "a*b" 
3dcalc -prefix $g/daf2/daf2.thresh3.5_bet.nii -a $g/daf2.thresh3.5.nii -b $g/mask.nii -expr "a*b"
3dcalc -prefix $g/faf1/faf1.thresh3.5_bet.nii -a $g/faf1.thresh3.5.nii -b $g/mask.nii -expr "a*b"
3dcalc -prefix $g/faf2/faf2.thresh3.5_bet.nii -a $g/faf2.thresh3.5.nii -b $g/mask.nii -expr "a*b"

rm tmp*.nii

done

