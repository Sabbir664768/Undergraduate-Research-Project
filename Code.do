
*Change Directory
cd "D:\My research\Research Project\Clean"

**v744a v744b v744c v744d v744e
gen violence=.
replace violence =1 if ( v744a ==1 | v744b ==1 | v744c ==1 | v744d ==1 | v744e==1)
replace violence =0 if ( v744a ==0 & v744b ==0 & v744c ==0 & v744d ==0 & v744e==0)

label define vio 1 "Yes" 3 "No"
label values vio violence
label variable violence "domestic violence"


drop if v137==0
recode v137  1=1 2=2 3/max=3 
label define v  1 "one" 2 "two" 3 "three " 4 "four"  5 "five or above"
label value v137 v
tab v137
tab v137, nolabel

 
tab h22
recode h22 0=0 1=1 8=.
tab h22
tab h22, nolabel

tab v717
tab v717, nolabel
recode v717 (0 = 0) (1 = 3) (3 = 4) (4 = 1) (5 = 1) (6 = 4) (7 = 4) (8 = 2) (9 = 2)
label define occ 0 "Did not work" 1 "Agriculture" 2 "Manual Labour" 3 "Professional/technical/managerial" 4 "Others"
label values v717 occ
tab v717


tab v705
tab v705, nolabel
recode v705 (0 = 0) (1 = 3) (3 = 4) (4 = 1) (5 = 1) (6 = 4) (7 = 4) (8 = 2) (9 = 2) (98=.)
tab v705
label define occup 0 "Did not work" 1 "Agriculture" 2 "Manual Labour" 3 "Professional/technical/managerial" 4 "Others"
label values v705 occup

codebook hw1
recode hw1 min/12 =1 13/24=2 25/36=3 37/48=4 49/max=5
label define h1 1 "one year old" 2 "two year old" 3 "three year old" 4 "four year old" 5 "five year old"
label value hw1 h1
tab hw1


*to be added

gen wt=(v005/1000000)
**to be added
label variable wt "sampling weight"
**
rename v007 survey_year
label variable survey_year "year of interview"
 
rename v000 country
label variable country "country code"

egen psuid = group(survey_year v024 v021 )
label variable psuid "primary sampling unit(created)"

egen strataid = group(survey_year v024 v022)
label variable strataid "stratification used in sample design"
**
svyset psuid, strata(strataid) weight(wt)  singleunit(scaled)



gen stunted = v440  < -200

gen wasted = hw10< -200

gen underweight = hw8 < -200


keep malnutrition wt strataid psuid hw1 v025 v705 v717 v106 v190 v137 h22 h11 v401 s469a

gen malnutrition=.
replace malnutrition =1 if ( stunted ==1 | wasted==1 | underweight ==1)
replace malnutrition =0 if ( stunted ==0 & wasted ==0 & underweight ==0 )
label define mal 1 "Yes" 3 "No"
label values mal malnutrition
label variable malnutrition "nutrition status of the children"
recode h11 0=0 8=. 2=1


tab s469a
tab s469a 
tab s469a , nolabel
recode s469a  min/12 =1 13/24=2 25/36=3 
label define month 1 "one years breastfed" 2 "two years breastfed" 3 "Three years breastfed" 
label value s469a month

***v025 v137 v190 v401 v705 v717 h11 h22 hw1 s469a malnutrition


svy: tab v025 malnutrition, row col count percent
svy: tab v137 malnutrition, row col count percent
svy: tab v190 malnutrition, row col count percent
svy: tab v401 malnutrition, row col count percent
svy: tab v705 malnutrition, row col count percent
svy: tab v717 malnutrition, row col count percent
svy: tab h11  malnutrition, row col count percent
svy: tab h22 malnutrition, row col count percent
svy: tab hw1 malnutrition, row col count percent
svy: tab s469a malnutrition, row col count percent


svy: logistic malnutrition i.v025 
svy: logistic malnutrition i.v137
svy: logistic malnutrition i.v190
svy: logistic malnutrition i.v401
svy: logistic malnutrition i.v705 
svy: logistic malnutrition i.v717
svy: logistic malnutrition i.h11
svy: logistic malnutrition i.h22 
svy: logistic malnutrition i.hw1
svy: logistic malnutrition i.s469a


svy: logistic malnutrition i.v025 i.v137 i.v190 i.v401 i.v705 i.v717 i.h11 i.h22  i.hw1 i.s469a

svy: logistic malnutrition i.h22 i.hw1 i.v717 i.v705 i.v401 i.v190
