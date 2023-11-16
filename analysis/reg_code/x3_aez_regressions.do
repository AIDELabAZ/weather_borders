* Project: Beyond Borders
* Created on: November 2023
* Created by: ca
* Edited by: ca
* Edited on: 16 November 2023
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
	loc		source	= 	"$data/regression_data"
	loc		results = 	"$data/results_data"
	loc		logout 	= 	"$data/regression_data/logs"

* open log	
	cap log close
	log 	using 		"`logout'/aez_regressions", append

	
* **********************************************************************
* 1 - read in cross country panel
* **********************************************************************

* read in data file
	use			"`source'/lsms_panel.dta", clear

* drop aez with only a few observations
	drop		if aez ==321
	
* **********************************************************************
* 2 - 
* **********************************************************************

* regs for sat 1
    reg lntf_yld c.v01_rf1_x3##i.country c.v01_rf1_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v05_rf1_x3##i.country c.v05_rf1_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v08_rf1_x3##i.country c.v08_rf1_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v12_rf1_x3##i.country c.v12_rf1_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v14_rf1_x3##i.country c.v14_rf1_x3##i.aez, cluster(hhid)

    reg lntf_yld c.v01_rf2_x3##i.country c.v01_rf2_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v05_rf2_x3##i.country c.v05_rf2_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v08_rf2_x3##i.country c.v08_rf2_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v12_rf2_x3##i.country c.v12_rf2_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v14_rf2_x3##i.country c.v14_rf2_x3##i.aez, cluster(hhid)

    reg lntf_yld c.v01_rf3_x3##i.country c.v01_rf3_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v05_rf3_x3##i.country c.v05_rf3_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v08_rf3_x3##i.country c.v08_rf3_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v12_rf3_x3##i.country c.v12_rf3_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v14_rf3_x3##i.country c.v14_rf3_x3##i.aez, cluster(hhid)

    reg lntf_yld c.v01_rf4_x3##i.country c.v01_rf4_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v05_rf4_x3##i.country c.v05_rf4_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v08_rf4_x3##i.country c.v08_rf4_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v12_rf4_x3##i.country c.v12_rf4_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v14_rf4_x3##i.country c.v14_rf4_x3##i.aez, cluster(hhid)

    reg lntf_yld c.v01_rf5_x3##i.country c.v01_rf5_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v05_rf5_x3##i.country c.v05_rf5_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v08_rf5_x3##i.country c.v08_rf5_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v12_rf5_x3##i.country c.v12_rf5_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v14_rf5_x3##i.country c.v14_rf5_x3##i.aez, cluster(hhid)

    reg lntf_yld c.v01_rf6_x3##i.country c.v01_rf6_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v05_rf6_x3##i.country c.v05_rf6_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v08_rf6_x3##i.country c.v08_rf6_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v12_rf6_x3##i.country c.v12_rf6_x3##i.aez, cluster(hhid)
    reg lntf_yld c.v14_rf6_x3##i.country c.v14_rf6_x3##i.aez, cluster(hhid)


* **********************************************************************
* 3 - 
* **********************************************************************

    reghdfe lntf_yld c.v01_rf1_x3##i.country c.v01_rf1_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v05_rf1_x3##i.country c.v05_rf1_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v08_rf1_x3##i.country c.v08_rf1_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v12_rf1_x3##i.country c.v12_rf1_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v14_rf1_x3##i.country c.v14_rf1_x3##i.aez, absorb(hhid year) cluster(hhid)

    reghdfe lntf_yld c.v01_rf2_x3##i.country c.v01_rf2_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v05_rf2_x3##i.country c.v05_rf2_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v08_rf2_x3##i.country c.v08_rf2_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v12_rf2_x3##i.country c.v12_rf2_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v14_rf2_x3##i.country c.v14_rf2_x3##i.aez, absorb(hhid year) cluster(hhid)

    reghdfe lntf_yld c.v01_rf3_x3##i.country c.v01_rf3_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v05_rf3_x3##i.country c.v05_rf3_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v08_rf3_x3##i.country c.v08_rf3_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v12_rf3_x3##i.country c.v12_rf3_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v14_rf3_x3##i.country c.v14_rf3_x3##i.aez, absorb(hhid year) cluster(hhid)

    reghdfe lntf_yld c.v01_rf4_x3##i.country c.v01_rf4_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v05_rf4_x3##i.country c.v05_rf4_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v08_rf4_x3##i.country c.v08_rf4_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v12_rf4_x3##i.country c.v12_rf4_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v14_rf4_x3##i.country c.v14_rf4_x3##i.aez, absorb(hhid year) cluster(hhid)

    reghdfe lntf_yld c.v01_rf5_x3##i.country c.v01_rf5_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v05_rf5_x3##i.country c.v05_rf5_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v08_rf5_x3##i.country c.v08_rf5_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v12_rf5_x3##i.country c.v12_rf5_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v14_rf5_x3##i.country c.v14_rf5_x3##i.aez, absorb(hhid year) cluster(hhid)

    reghdfe lntf_yld c.v01_rf6_x3##i.country c.v01_rf6_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v05_rf6_x3##i.country c.v05_rf6_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v08_rf6_x3##i.country c.v08_rf6_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v12_rf6_x3##i.country c.v12_rf6_x3##i.aez, absorb(hhid year) cluster(hhid)
    reghdfe lntf_yld c.v14_rf6_x3##i.country c.v14_rf6_x3##i.aez, absorb(hhid year) cluster(hhid)

