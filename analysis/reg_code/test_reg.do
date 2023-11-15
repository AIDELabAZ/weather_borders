* Project: Beyond Borders
* Created on: 15 November 2023
* Created by: jdm
* Stata v.18.0

* does
	* runs regressions using extraction method three

* assumes
	* cleaned, merged (weather), and appended (waves) data
	* customsave.ado

* TO DO:
	* complete

	
* **********************************************************************
* 0 - setup
* **********************************************************************

* define paths
	global		source	= 	"$data/regression_data"
	global		results = 	"$data/results_data"
	global		logout 	= 	"$data/regression_data/logs"

* open log	
	cap log close
	log 	using 		"$logout/test_reg", append

	
* **********************************************************************
* 1 - read in cross country panel and drop unnecessary variables
* **********************************************************************

* read in data file
	use			"$source/lsms_panel.dta", clear

* drop aez with only a few observations
	drop		if aez ==321
	
* drop non-contiguous countries
	drop		if country == 1
	
* drop non-extraction method 3
	drop		*_x0 *_x1 *_x2 *_x4 *_x5 *_x6 *_x7 *_x8 *_x9
	
* drop temperature
	drop		*tp*
	
* drop all but mean, total, rainy days, z-score, dry spell
	drop		v02* v03* v04* v06* v09* v10* v11* v12* v13*
	
* set panel dimensions
	xtset 		hhid year
	
* **********************************************************************
* 2 - run niger/nigeria regressions
* **********************************************************************

preserve

* keep if niger or nigeria
	keep		if country == 4 | country == 5

	
* **********************************************************************
* 2.1 - run pooled country regressions
* **********************************************************************
	
* simple pooled regressions
	reg 		lntf_yld v01_rf1_x3, vce(cluster hhid)
	xtreg 		lntf_yld v01_rf1_x3, fe vce(cluster hhid)
	
* aez dummies
	reg 		lntf_yld v01_rf1_x3 i.aez, vce(cluster hhid)
	xtreg 		lntf_yld v01_rf1_x3 i.aez, fe vce(cluster hhid)
	
* country dummies (Nigeria gets dropped for colinearity)
	reg 		lntf_yld v01_rf1_x3 i.country, vce(cluster hhid)
	xtreg 		lntf_yld v01_rf1_x3 i.country, fe vce(cluster hhid)

* year dummies (2014 gets dropped for colinearity)	
	reg 		lntf_yld v01_rf1_x3 i.year, vce(cluster hhid)
	xtreg 		lntf_yld v01_rf1_x3 i.year, fe vce(cluster hhid)
	
* year and country dummies (Nigeria & 2014 gets dropped for colinearity)	
	reg 		lntf_yld v01_rf1_x3 i.year i.country, vce(cluster hhid)
	xtreg 		lntf_yld v01_rf1_x3 i.year i.country, fe vce(cluster hhid)
		
	
* **********************************************************************
* 2.2 - run country regressions
* **********************************************************************
	
* slope of weather varies by country
	reg 		lntf_yld c.v01_rf1_x3#i.country, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.country, fe vce(cluster hhid)

* aez dummies
	reg 		lntf_yld c.v01_rf1_x3#i.country i.aez, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.country i.aez, fe vce(cluster hhid)

* country dummies (Nigeria gets dropped for colinearity)
	reg 		lntf_yld c.v01_rf1_x3#i.country i.country, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.country i.country, fe vce(cluster hhid)

* year dummies (2014 gets dropped for colinearity)	
	reg 		lntf_yld c.v01_rf1_x3#i.country i.year, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.country i.year, fe vce(cluster hhid)
	
* year and country dummies (Nigeria & 2014 gets dropped for colinearity)	
	reg 		lntf_yld c.v01_rf1_x3#i.country i.year i.country, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.country i.year i.country, fe vce(cluster hhid)	
	
	
* **********************************************************************
* 2.3 - run aez regressions
* **********************************************************************
	
* slope of weather varies by country
	reg 		lntf_yld c.v01_rf1_x3#i.aez, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.aez, fe vce(cluster hhid)

* aez dummies (Nigeria gets dropped for colinearity)
	reg 		lntf_yld c.v01_rf1_x3#i.aez i.aez, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.aez i.aez, fe vce(cluster hhid)
	
* country dummies (Nigeria gets dropped for colinearity)
	reg 		lntf_yld c.v01_rf1_x3#i.aez i.country, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.aez i.country, fe vce(cluster hhid)

* year dummies (2014 gets dropped for colinearity)	
	reg 		lntf_yld c.v01_rf1_x3#i.aez i.year, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.aez i.year, fe vce(cluster hhid)
	
* year and country dummies (Nigeria & 2014 gets dropped for colinearity)	
	reg 		lntf_yld c.v01_rf1_x3#i.aez i.year i.country, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.aez i.year i.country, fe vce(cluster hhid)		

* year, country, and aez dummies (Nigeria & 2014 gets dropped for colinearity)	
	reg 		lntf_yld c.v01_rf1_x3#i.aez i.year i.country i.aez, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.aez i.year i.country i.aez, fe vce(cluster hhid)			
restore
	

* **********************************************************************
* 2 - run malawi/tanzania/uganda regressions
* **********************************************************************

preserve

* drop if niger or nigeria
	drop		if country == 4 | country == 5

	
* **********************************************************************
* 2.1 - run pooled country regressions
* **********************************************************************
	
* simple pooled regressions
	reg 		lntf_yld v01_rf1_x3, vce(cluster hhid)
	xtreg 		lntf_yld v01_rf1_x3, fe vce(cluster hhid)
	
* aez dummies
	reg 		lntf_yld v01_rf1_x3 i.aez, vce(cluster hhid)
	xtreg 		lntf_yld v01_rf1_x3 i.aez, fe vce(cluster hhid)
	
* country dummies 
	reg 		lntf_yld v01_rf1_x3 i.country, vce(cluster hhid)
	xtreg 		lntf_yld v01_rf1_x3 i.country, fe vce(cluster hhid)

* year dummies 	
	reg 		lntf_yld v01_rf1_x3 i.year, vce(cluster hhid)
	xtreg 		lntf_yld v01_rf1_x3 i.year, fe vce(cluster hhid)
	
* year and country dummies 	
	reg 		lntf_yld v01_rf1_x3 i.year i.country, vce(cluster hhid)
	xtreg 		lntf_yld v01_rf1_x3 i.year i.country, fe vce(cluster hhid)
		
	
* **********************************************************************
* 2.2 - run country regressions
* **********************************************************************
	
* slope of weather varies by country
	reg 		lntf_yld c.v01_rf1_x3#i.country, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.country, fe vce(cluster hhid)

* aez dummies
	reg 		lntf_yld c.v01_rf1_x3#i.country i.aez, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.country i.aez, fe vce(cluster hhid)

* country dummies 
	reg 		lntf_yld c.v01_rf1_x3#i.country i.country, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.country i.country, fe vce(cluster hhid)

* year dummies 	
	reg 		lntf_yld c.v01_rf1_x3#i.country i.year, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.country i.year, fe vce(cluster hhid)
	
* year and country dummies 	
	reg 		lntf_yld c.v01_rf1_x3#i.country i.year i.country, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.country i.year i.country, fe vce(cluster hhid)	
	
	
* **********************************************************************
* 2.3 - run aez regressions
* **********************************************************************
	
* slope of weather varies by country
	reg 		lntf_yld c.v01_rf1_x3#i.aez, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.aez, fe vce(cluster hhid)

* aez dummies 
	reg 		lntf_yld c.v01_rf1_x3#i.aez i.aez, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.aez i.aez, fe vce(cluster hhid)
	
* country dummies 
	reg 		lntf_yld c.v01_rf1_x3#i.aez i.country, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.aez i.country, fe vce(cluster hhid)

* year dummies 
	reg 		lntf_yld c.v01_rf1_x3#i.aez i.year, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.aez i.year, fe vce(cluster hhid)
	
* year and country dummies 
	reg 		lntf_yld c.v01_rf1_x3#i.aez i.year i.country, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.aez i.year i.country, fe vce(cluster hhid)		

* year, country, and aez dummies
	reg 		lntf_yld c.v01_rf1_x3#i.aez i.year i.country i.aez, vce(cluster hhid)
	xtreg 		lntf_yld c.v01_rf1_x3#i.aez i.year i.country i.aez, fe vce(cluster hhid)			
restore
	
	
	
	
	
	
	
	
	
