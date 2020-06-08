
*set up


*change working directory as needed
cd "/Users/abdoulayecisse/Desktop/Fostering/Data/DHS"


local southern_africa Angola Lesotho Madagascar Malawi Mozambique Namibia South_Africa Zambia Zimbabwe

local west_africa Benin Burkina_Faso Ivory_Coast Ghana  Mali Niger Nigeria1 Nigeria2 Senegal

local central_africa Cameroon Congo

local east_africa Burundi Ethiopia Kenya Rwanda Tanzania Uganda 

local regions west_africa central_africa east_africa southern_africa

**** CHILD FOSTERING PREVALENCE FROM LATEST DHS SURVEYS, BY COUNTRY AND REGION

*for each cutoff age, get the share of HH fostering by country and by region 

foreach region of local regions{
	
	forvalues i = 12(3)18{

		foreach country of local `region'{
			
			cd "/Users/abdoulayecisse/Desktop/Fostering/Data/DHS"
			import excel "DHS `country'", firstrow clear
			
			*clean variables
			rename HHID hh_id
			egen year = max(YEAR)
			keep if YEAR == year
		    gen country = "`country'"
			
			*get the share of HHs that foster in children
		    gen fostered = (HHAGE <= `i' & MOTHERLINENO == 0 & FATHERLINENO == 0)
		    bys country year hh_id: egen hh_foster_in = max(fostered)
		    gen weighted_foster_in = HHWEIGHT * hh_foster_in
			
			*get the share of children that are fostered into HHs
			egen no_children = sum(HHAGE <= `i'), by(country year hh_id)
			egen no_fostered = sum(fostered == 1), by(country year hh_id)
			gen share_fostered = no_fostered / no_children
			gen weighted_share_fostered = HHWEIGHT * share_fostered
		
		
		    keep weighted_foster_in weighted_share_fostered country year hh_id
		
		    collapse (mean) weighted_foster_in weighted_share_fostered, by(country year hh_id)
		    collapse (mean) weighted_foster_in weighted_share_fostered, by(country year)
			
			*combine the results into one table per region and per age threshold
			cd "/Users/abdoulayecisse/Desktop/Fostering/Output"
			capture confirm file "fostering_`i'_`region'_latest.dta"
			if _rc==0{
				append using "fostering_`i'_`region'_latest.dta"
				save "fostering_`i'_`region'_latest.dta", replace
			}
		    else{
				save "fostering_`i'_`region'_latest.dta", replace
			}
	   }
	   
	   dataout, save(fostering_`i'_`region'_latest) tex replace
	}
}


**** CHILD FOSTERING PREVALENCE BY YEAR, COUNTRY AND REGION

*for each cutoff age, get the share of HH fostering by country by year and by region 
foreach region of local regions{
	
	forvalues i = 12(3)18{

		foreach country of local `region'{
			
			cd "/Users/abdoulayecisse/Desktop/Fostering/Data/DHS"
			import excel "DHS `country'", firstrow clear
			
			*clean variables
			rename (YEAR HHID) (year hh_id)
		    gen country = "`country'"
			
			*get the share of HHs that foster in children
		    gen fostered = (HHAGE <= `i' & MOTHERLINENO == 0 & FATHERLINENO == 0)
		    bys country year hh_id: egen hh_foster_in = max(fostered)
		    gen weighted_foster_in = HHWEIGHT * hh_foster_in
			
			*get the share of children that are fostered into HHs
			egen no_children = sum(HHAGE <= `i'), by(country year hh_id)
			egen no_fostered = sum(fostered == 1), by(country year hh_id)
			gen share_fostered = no_fostered / no_children
			gen weighted_share_fostered = HHWEIGHT * share_fostered
		
		    keep weighted_foster_in weighted_share_fostered country year hh_id
		
		    collapse (mean) weighted_foster_in weighted_share_fostered, by(country year hh_id)
		    collapse (mean) weighted_foster_in weighted_share_fostered, by(country year)
			
			*combine the results into one table per region and per age threshold
			cd "/Users/abdoulayecisse/Desktop/Fostering/Output"
			capture confirm file "fostering_`i'_`region'.dta"
			if _rc==0{
				append using "fostering_`i'_`region'.dta"
				save "fostering_`i'_`region'.dta", replace
			}
		    else{
				save "fostering_`i'_`region'.dta", replace
			}
	   }
	   
	   dataout, save(fostering_`i'_`region') tex replace
	}
}


