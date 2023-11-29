* Project: Beyond Borders
* Created on: 28 November 2023
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

	clear		all

* define paths
	global		source	= 	"$data/regression_data"
	global		results = 	"$data/results_data"
	global		logout 	= 	"$data/regression_data/logs"

* open log	
	cap log close
	log 	using 		"$logout/test_reg", append

/*
* **********************************************************************
* 1 - read in cross country panel keep v01
* **********************************************************************

* read in data file
	use			"$source/lsms_panel.dta", clear

* drop aez with only a few observations
	drop		if aez ==321
	
* drop non-extraction method 1
	drop		*_x0 *_x2 *_x3 *_x4 *_x5 *_x6 *_x7 *_x8 *_x9
	
* drop temperature
	drop		*tp*
	
* drop all but mean
	drop		v02* v03* v04* v05* v06* v07* v08* v09* v10* v11* v12* v13* v14*
	
* set panel dimensions
	xtset 		hhid year
	

* **********************************************************************
* 2 - country and sat regs by aez
* **********************************************************************	
				
* create local of weather variables
	loc		weather 	v*
				
* define loop through levels of country
levelsof 	country		, local(levels)
foreach c of local levels {

	* rainfall			
		foreach 	v of varlist `weather' { 

		* reg weather only
			xtreg 		lntf_yld `v' if country == `c', ///
							fe vce(cluster hhid)
			eststo 		`v'_c`c'
		}
}	

foreach c of local levels {

	* rainfall			
		foreach 	v of varlist `weather' { 

		* reg weather by aez
			xtreg 		lntf_yld c.`v'#i.aez if country == `c', ///
							fe vce(cluster hhid)
			eststo 		`v'_c`c'_aez
		}
}	

* ethiopia, sat 1
	coefplot		 (v01_rf1_x1_c1 v01_rf1_x1_c1_aez, drop(_cons) ///
						rename(v01_rf1_x1 = "Mean" 311.aez#c.v01_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v01_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v01_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v01_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v01_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v01_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v01_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf2_x1_c1 v01_rf2_x1_c1_aez, drop(_cons) ///
						rename(v01_rf2_x1 = "Mean " 311.aez#c.v01_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v01_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v01_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v01_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v01_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v01_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v01_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf3_x1_c1 v01_rf3_x1_c1_aez, drop(_cons) ///
						rename(v01_rf3_x1 = " Mean" 311.aez#c.v01_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v01_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v01_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v01_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v01_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v01_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v01_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf4_x1_c1 v01_rf4_x1_c1_aez, drop(_cons) ///
						rename(v01_rf4_x1 = " Mean " 311.aez#c.v01_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v01_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v01_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v01_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v01_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v01_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v01_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf5_x1_c1 v01_rf5_x1_c1_aez, drop(_cons) ///
						rename(v01_rf5_x1 = "Mean  " 311.aez#c.v01_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v01_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v01_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v01_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v01_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v01_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v01_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf6_x1_c1 v01_rf6_x1_c1_aez, drop(_cons) ///
						rename(v01_rf6_x1 = "  Mean" 311.aez#c.v01_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v01_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v01_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v01_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v01_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v01_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v01_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Rainfall" = "{bf:CHIRPS}" "Rainfall " ///
						= "{bf:CPC}" " Rainfall" = "{bf:MERRA-2}" " Rainfall " ///
						= "{bf:ARC2}" "Rainfall  " = "{bf:ERA-5}" "  Rainfall" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Ethiopia")
						
* malawi , sat 1
	coefplot		 (v01_rf1_x1_c2 v01_rf1_x1_c2_aez, drop(_cons) ///
						rename(v01_rf1_x1 = "Mean" 311.aez#c.v01_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v01_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v01_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v01_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v01_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v01_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v01_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf2_x1_c2 v01_rf2_x1_c2_aez, drop(_cons) ///
						rename(v01_rf2_x1 = "Mean " 311.aez#c.v01_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v01_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v01_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v01_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v01_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v01_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v01_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf3_x1_c2 v01_rf3_x1_c2_aez, drop(_cons) ///
						rename(v01_rf3_x1 = " Mean" 311.aez#c.v01_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v01_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v01_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v01_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v01_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v01_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v01_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf4_x1_c2 v01_rf4_x1_c2_aez, drop(_cons) ///
						rename(v01_rf4_x1 = " Mean " 311.aez#c.v01_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v01_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v01_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v01_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v01_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v01_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v01_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf5_x1_c2 v01_rf5_x1_c2_aez, drop(_cons) ///
						rename(v01_rf5_x1 = "Mean  " 311.aez#c.v01_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v01_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v01_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v01_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v01_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v01_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v01_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf6_x1_c2 v01_rf6_x1_c2_aez, drop(_cons) ///
						rename(v01_rf6_x1 = "  Mean" 311.aez#c.v01_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v01_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v01_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v01_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v01_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v01_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v01_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Rainfall" = "{bf:CHIRPS}" "Rainfall " ///
						= "{bf:CPC}" " Rainfall" = "{bf:MERRA-2}" " Rainfall " ///
						= "{bf:ARC2}" "Rainfall  " = "{bf:ERA-5}" "  Rainfall" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Malawi")
					
* niger , sat 1
	coefplot		 (v01_rf1_x1_c4 v01_rf1_x1_c4_aez, drop(_cons) ///
						rename(v01_rf1_x1 = "Mean" 311.aez#c.v01_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v01_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v01_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v01_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v01_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v01_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v01_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf2_x1_c4 v01_rf2_x1_c4_aez, drop(_cons) ///
						rename(v01_rf2_x1 = "Mean " 311.aez#c.v01_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v01_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v01_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v01_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v01_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v01_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v01_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf3_x1_c4 v01_rf3_x1_c4_aez, drop(_cons) ///
						rename(v01_rf3_x1 = " Mean" 311.aez#c.v01_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v01_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v01_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v01_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v01_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v01_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v01_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf4_x1_c4 v01_rf4_x1_c4_aez, drop(_cons) ///
						rename(v01_rf4_x1 = " Mean " 311.aez#c.v01_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v01_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v01_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v01_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v01_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v01_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v01_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf5_x1_c4 v01_rf5_x1_c4_aez, drop(_cons) ///
						rename(v01_rf5_x1 = "Mean  " 311.aez#c.v01_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v01_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v01_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v01_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v01_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v01_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v01_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf6_x1_c4 v01_rf6_x1_c4_aez, drop(_cons) ///
						rename(v01_rf6_x1 = "  Mean" 311.aez#c.v01_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v01_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v01_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v01_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v01_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v01_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v01_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Rainfall" = "{bf:CHIRPS}" "Rainfall " ///
						= "{bf:CPC}" " Rainfall" = "{bf:MERRA-2}" " Rainfall " ///
						= "{bf:ARC2}" "Rainfall  " = "{bf:ERA-5}" "  Rainfall" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Niger")
						
					
* nigeria , sat 1
	coefplot		 (v01_rf1_x1_c5 v01_rf1_x1_c5_aez, drop(_cons) ///
						rename(v01_rf1_x1 = "Mean" 311.aez#c.v01_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v01_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v01_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v01_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v01_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v01_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v01_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf2_x1_c5 v01_rf2_x1_c5_aez, drop(_cons) ///
						rename(v01_rf2_x1 = "Mean " 311.aez#c.v01_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v01_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v01_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v01_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v01_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v01_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v01_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf3_x1_c5 v01_rf3_x1_c5_aez, drop(_cons) ///
						rename(v01_rf3_x1 = " Mean" 311.aez#c.v01_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v01_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v01_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v01_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v01_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v01_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v01_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf4_x1_c5 v01_rf4_x1_c5_aez, drop(_cons) ///
						rename(v01_rf4_x1 = " Mean " 311.aez#c.v01_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v01_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v01_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v01_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v01_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v01_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v01_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf5_x1_c5 v01_rf5_x1_c5_aez, drop(_cons) ///
						rename(v01_rf5_x1 = "Mean  " 311.aez#c.v01_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v01_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v01_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v01_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v01_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v01_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v01_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf6_x1_c5 v01_rf6_x1_c5_aez, drop(_cons) ///
						rename(v01_rf6_x1 = "  Mean" 311.aez#c.v01_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v01_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v01_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v01_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v01_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v01_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v01_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Rainfall" = "{bf:CHIRPS}" "Rainfall " ///
						= "{bf:CPC}" " Rainfall" = "{bf:MERRA-2}" " Rainfall " ///
						= "{bf:ARC2}" "Rainfall  " = "{bf:ERA-5}" "  Rainfall" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Nigeria")
						
						
* tanzania , sat 1
	coefplot		 (v01_rf1_x1_c6 v01_rf1_x1_c6_aez, drop(_cons) ///
						rename(v01_rf1_x1 = "Mean" 311.aez#c.v01_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v01_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v01_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v01_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v01_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v01_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v01_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf2_x1_c6 v01_rf2_x1_c6_aez, drop(_cons) ///
						rename(v01_rf2_x1 = "Mean " 311.aez#c.v01_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v01_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v01_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v01_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v01_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v01_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v01_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf3_x1_c6 v01_rf3_x1_c6_aez, drop(_cons) ///
						rename(v01_rf3_x1 = " Mean" 311.aez#c.v01_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v01_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v01_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v01_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v01_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v01_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v01_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf4_x1_c6 v01_rf4_x1_c6_aez, drop(_cons) ///
						rename(v01_rf4_x1 = " Mean " 311.aez#c.v01_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v01_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v01_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v01_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v01_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v01_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v01_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf5_x1_c6 v01_rf5_x1_c6_aez, drop(_cons) ///
						rename(v01_rf5_x1 = "Mean  " 311.aez#c.v01_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v01_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v01_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v01_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v01_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v01_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v01_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf6_x1_c6 v01_rf6_x1_c6_aez, drop(_cons) ///
						rename(v01_rf6_x1 = "  Mean" 311.aez#c.v01_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v01_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v01_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v01_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v01_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v01_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v01_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Rainfall" = "{bf:CHIRPS}" "Rainfall " ///
						= "{bf:CPC}" " Rainfall" = "{bf:MERRA-2}" " Rainfall " ///
						= "{bf:ARC2}" "Rainfall  " = "{bf:ERA-5}" "  Rainfall" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Tanzania")
						
* uganda , sat 1
	coefplot		 (v01_rf1_x1_c7 v01_rf1_x1_c7_aez, drop(_cons) ///
						rename(v01_rf1_x1 = "Mean" 311.aez#c.v01_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v01_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v01_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v01_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v01_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v01_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v01_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf2_x1_c7 v01_rf2_x1_c7_aez, drop(_cons) ///
						rename(v01_rf2_x1 = "Mean " 311.aez#c.v01_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v01_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v01_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v01_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v01_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v01_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v01_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf3_x1_c7 v01_rf3_x1_c7_aez, drop(_cons) ///
						rename(v01_rf3_x1 = " Mean" 311.aez#c.v01_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v01_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v01_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v01_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v01_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v01_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v01_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf4_x1_c7 v01_rf4_x1_c7_aez, drop(_cons) ///
						rename(v01_rf4_x1 = " Mean " 311.aez#c.v01_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v01_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v01_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v01_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v01_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v01_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v01_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf5_x1_c7 v01_rf5_x1_c7_aez, drop(_cons) ///
						rename(v01_rf5_x1 = "Mean  " 311.aez#c.v01_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v01_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v01_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v01_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v01_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v01_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v01_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf6_x1_c7 v01_rf6_x1_c7_aez, drop(_cons) ///
						rename(v01_rf6_x1 = "  Mean" 311.aez#c.v01_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v01_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v01_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v01_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v01_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v01_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v01_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Rainfall" = "{bf:CHIRPS}" "Rainfall " ///
						= "{bf:CPC}" " Rainfall" = "{bf:MERRA-2}" " Rainfall " ///
						= "{bf:ARC2}" "Rainfall  " = "{bf:ERA-5}" "  Rainfall" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Uganda")
*/

/*

clear all

* **********************************************************************
* 1 - read in cross country panel keep v05
* **********************************************************************

* read in data file
	use			"$source/lsms_panel.dta", clear

* drop aez with only a few observations
	drop		if aez ==321
	
* drop non-extraction method 1
	drop		*_x0 *_x2 *_x3 *_x4 *_x5 *_x6 *_x7 *_x8 *_x9
	
* drop temperature
	drop		*tp*
	
* drop all but mean
	drop		v01* v02* v03* v04* v06* v07* v08* v09* v10* v11* v12* v13* v14*
	
* set panel dimensions
	xtset 		hhid year
	

* **********************************************************************
* 2 - country and sat regs by aez
* **********************************************************************	
				
* create local of weather variables
	loc		weather 	v*
				
* define loop through levels of country
levelsof 	country		, local(levels)
foreach c of local levels {

	* rainfall			
		foreach 	v of varlist `weather' { 

		* reg weather only
			xtreg 		lntf_yld `v' if country == `c', ///
							fe vce(cluster hhid)
			eststo 		`v'_c`c'
		}
}	

foreach c of local levels {

	* rainfall			
		foreach 	v of varlist `weather' { 

		* reg weather by aez
			xtreg 		lntf_yld c.`v'#i.aez if country == `c', ///
							fe vce(cluster hhid)
			eststo 		`v'_c`c'_aez
		}
}	

* ethiopia, sat 1
	coefplot		 (v05_rf1_x1_c1 v05_rf1_x1_c1_aez, drop(_cons) ///
						rename(v05_rf1_x1 = "Total" 311.aez#c.v05_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v05_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v05_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v05_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v05_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v05_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v05_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf2_x1_c1 v05_rf2_x1_c1_aez, drop(_cons) ///
						rename(v05_rf2_x1 = "Total " 311.aez#c.v05_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v05_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v05_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v05_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v05_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v05_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v05_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf3_x1_c1 v05_rf3_x1_c1_aez, drop(_cons) ///
						rename(v05_rf3_x1 = " Total" 311.aez#c.v05_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v05_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v05_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v05_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v05_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v05_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v05_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf4_x1_c1 v05_rf4_x1_c1_aez, drop(_cons) ///
						rename(v05_rf4_x1 = " Total " 311.aez#c.v05_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v05_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v05_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v05_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v05_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v05_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v05_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf5_x1_c1 v05_rf5_x1_c1_aez, drop(_cons) ///
						rename(v05_rf5_x1 = "Total  " 311.aez#c.v05_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v05_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v05_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v05_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v05_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v05_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v05_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf6_x1_c1 v05_rf6_x1_c1_aez, drop(_cons) ///
						rename(v05_rf6_x1 = "  Total" 311.aez#c.v05_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v05_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v05_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v05_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v05_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v05_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v05_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Total" = "{bf:CHIRPS}" "Total " ///
						= "{bf:CPC}" " Total" = "{bf:MERRA-2}" " Total " ///
						= "{bf:ARC2}" "Total  " = "{bf:ERA-5}" "  Total" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Ethiopia")
						
* malawi , sat 1
	coefplot		 (v05_rf1_x1_c2 v05_rf1_x1_c2_aez, drop(_cons) ///
						rename(v05_rf1_x1 = "Total" 311.aez#c.v05_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v05_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v05_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v05_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v05_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v05_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v05_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf2_x1_c2 v05_rf2_x1_c2_aez, drop(_cons) ///
						rename(v05_rf2_x1 = "Total " 311.aez#c.v05_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v05_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v05_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v05_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v05_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v05_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v05_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf3_x1_c2 v05_rf3_x1_c2_aez, drop(_cons) ///
						rename(v05_rf3_x1 = " Total" 311.aez#c.v05_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v05_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v05_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v05_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v05_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v05_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v05_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf4_x1_c2 v05_rf4_x1_c2_aez, drop(_cons) ///
						rename(v05_rf4_x1 = " Total " 311.aez#c.v05_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v05_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v05_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v05_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v05_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v05_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v05_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf5_x1_c2 v05_rf5_x1_c2_aez, drop(_cons) ///
						rename(v05_rf5_x1 = "Total  " 311.aez#c.v05_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v05_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v05_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v05_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v05_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v05_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v05_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf6_x1_c2 v05_rf6_x1_c2_aez, drop(_cons) ///
						rename(v05_rf6_x1 = "  Total" 311.aez#c.v05_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v05_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v05_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v05_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v05_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v05_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v05_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Total" = "{bf:CHIRPS}" "Total " ///
						= "{bf:CPC}" " Total" = "{bf:MERRA-2}" " Total " ///
						= "{bf:ARC2}" "Total  " = "{bf:ERA-5}" "  Total" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Malawi")
					
* niger , sat 1
	coefplot		 (v05_rf1_x1_c4 v05_rf1_x1_c4_aez, drop(_cons) ///
						rename(v05_rf1_x1 = "Total" 311.aez#c.v05_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v05_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v05_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v05_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v05_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v05_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v05_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf2_x1_c4 v05_rf2_x1_c4_aez, drop(_cons) ///
						rename(v05_rf2_x1 = "Total " 311.aez#c.v05_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v05_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v05_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v05_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v05_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v05_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v05_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf3_x1_c4 v05_rf3_x1_c4_aez, drop(_cons) ///
						rename(v05_rf3_x1 = " Total" 311.aez#c.v05_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v05_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v05_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v05_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v05_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v05_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v05_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf4_x1_c4 v05_rf4_x1_c4_aez, drop(_cons) ///
						rename(v05_rf4_x1 = " Total " 311.aez#c.v05_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v05_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v05_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v05_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v05_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v05_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v05_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf5_x1_c4 v05_rf5_x1_c4_aez, drop(_cons) ///
						rename(v05_rf5_x1 = "Total  " 311.aez#c.v05_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v05_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v05_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v05_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v05_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v05_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v05_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf6_x1_c4 v05_rf6_x1_c4_aez, drop(_cons) ///
						rename(v05_rf6_x1 = "  Total" 311.aez#c.v05_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v05_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v05_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v05_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v05_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v05_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v05_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Total" = "{bf:CHIRPS}" "Total " ///
						= "{bf:CPC}" " Total" = "{bf:MERRA-2}" " Total " ///
						= "{bf:ARC2}" "Total  " = "{bf:ERA-5}" "  Total" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Niger")
						
					
* nigeria , sat 1
	coefplot		 (v05_rf1_x1_c5 v05_rf1_x1_c5_aez, drop(_cons) ///
						rename(v05_rf1_x1 = "Total" 311.aez#c.v05_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v05_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v05_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v05_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v05_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v05_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v05_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf2_x1_c5 v05_rf2_x1_c5_aez, drop(_cons) ///
						rename(v05_rf2_x1 = "Total " 311.aez#c.v05_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v05_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v05_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v05_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v05_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v05_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v05_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf3_x1_c5 v05_rf3_x1_c5_aez, drop(_cons) ///
						rename(v05_rf3_x1 = " Total" 311.aez#c.v05_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v05_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v05_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v05_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v05_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v05_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v05_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf4_x1_c5 v05_rf4_x1_c5_aez, drop(_cons) ///
						rename(v05_rf4_x1 = " Total " 311.aez#c.v05_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v05_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v05_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v05_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v05_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v05_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v05_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf5_x1_c5 v05_rf5_x1_c5_aez, drop(_cons) ///
						rename(v05_rf5_x1 = "Total  " 311.aez#c.v05_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v05_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v05_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v05_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v05_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v05_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v05_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf6_x1_c5 v05_rf6_x1_c5_aez, drop(_cons) ///
						rename(v05_rf6_x1 = "  Total" 311.aez#c.v05_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v05_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v05_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v05_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v05_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v05_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v05_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Total" = "{bf:CHIRPS}" "Total " ///
						= "{bf:CPC}" " Total" = "{bf:MERRA-2}" " Total " ///
						= "{bf:ARC2}" "Total  " = "{bf:ERA-5}" "  Total" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Nigeria")
						
						
* tanzania , sat 1
	coefplot		 (v05_rf1_x1_c6 v05_rf1_x1_c6_aez, drop(_cons) ///
						rename(v05_rf1_x1 = "Total" 311.aez#c.v05_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v05_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v05_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v05_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v05_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v05_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v05_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf2_x1_c6 v05_rf2_x1_c6_aez, drop(_cons) ///
						rename(v05_rf2_x1 = "Total " 311.aez#c.v05_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v05_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v05_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v05_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v05_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v05_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v05_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf3_x1_c6 v05_rf3_x1_c6_aez, drop(_cons) ///
						rename(v05_rf3_x1 = " Total" 311.aez#c.v05_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v05_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v05_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v05_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v05_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v05_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v05_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf4_x1_c6 v05_rf4_x1_c6_aez, drop(_cons) ///
						rename(v05_rf4_x1 = " Total " 311.aez#c.v05_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v05_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v05_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v05_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v05_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v05_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v05_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf5_x1_c6 v05_rf5_x1_c6_aez, drop(_cons) ///
						rename(v05_rf5_x1 = "Total  " 311.aez#c.v05_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v05_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v05_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v05_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v05_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v05_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v05_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf6_x1_c6 v05_rf6_x1_c6_aez, drop(_cons) ///
						rename(v05_rf6_x1 = "  Total" 311.aez#c.v05_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v05_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v05_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v05_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v05_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v05_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v05_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Total" = "{bf:CHIRPS}" "Total " ///
						= "{bf:CPC}" " Total" = "{bf:MERRA-2}" " Total " ///
						= "{bf:ARC2}" "Total  " = "{bf:ERA-5}" "  Total" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Tanzania")
						
* uganda , sat 1
	coefplot		 (v05_rf1_x1_c7 v05_rf1_x1_c7_aez, drop(_cons) ///
						rename(v05_rf1_x1 = "Total" 311.aez#c.v05_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v05_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v05_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v05_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v05_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v05_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v05_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf2_x1_c7 v05_rf2_x1_c7_aez, drop(_cons) ///
						rename(v05_rf2_x1 = "Total " 311.aez#c.v05_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v05_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v05_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v05_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v05_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v05_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v05_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf3_x1_c7 v05_rf3_x1_c7_aez, drop(_cons) ///
						rename(v05_rf3_x1 = " Total" 311.aez#c.v05_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v05_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v05_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v05_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v05_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v05_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v05_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf4_x1_c7 v05_rf4_x1_c7_aez, drop(_cons) ///
						rename(v05_rf4_x1 = " Total " 311.aez#c.v05_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v05_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v05_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v05_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v05_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v05_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v05_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf5_x1_c7 v05_rf5_x1_c7_aez, drop(_cons) ///
						rename(v05_rf5_x1 = "Total  " 311.aez#c.v05_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v05_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v05_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v05_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v05_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v05_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v05_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v05_rf6_x1_c7 v05_rf6_x1_c7_aez, drop(_cons) ///
						rename(v05_rf6_x1 = "  Total" 311.aez#c.v05_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v05_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v05_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v05_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v05_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v05_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v05_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Total" = "{bf:CHIRPS}" "Total " ///
						= "{bf:CPC}" " Total" = "{bf:MERRA-2}" " Total " ///
						= "{bf:ARC2}" "Total  " = "{bf:ERA-5}" "  Total" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Uganda")
*/

/*

clear all 

* **********************************************************************
* 1 - read in cross country panel keep v08
* **********************************************************************

* read in data file
	use			"$source/lsms_panel.dta", clear

* drop aez with only a few observations
	drop		if aez ==321
	
* drop non-extraction method 1
	drop		*_x0 *_x2 *_x3 *_x4 *_x5 *_x6 *_x7 *_x8 *_x9
	
* drop temperature
	drop		*tp*
	
* drop all but mean
	drop		v01* v02* v03* v04* v05* v06* v07* v09* v10* v11* v12* v13* v14*
	
* set panel dimensions
	xtset 		hhid year
	

* **********************************************************************
* 2 - country and sat regs by aez
* **********************************************************************	
				
* create local of weather variables
	loc		weather 	v*
				
* define loop through levels of country
levelsof 	country		, local(levels)
foreach c of local levels {

	* rainfall			
		foreach 	v of varlist `weather' { 

		* reg weather only
			xtreg 		lntf_yld `v' if country == `c', ///
							fe vce(cluster hhid)
			eststo 		`v'_c`c'
		}
}	

foreach c of local levels {

	* rainfall			
		foreach 	v of varlist `weather' { 

		* reg weather by aez
			xtreg 		lntf_yld c.`v'#i.aez if country == `c', ///
							fe vce(cluster hhid)
			eststo 		`v'_c`c'_aez
		}
}	
	
* ethiopia, sat 1
	coefplot		 (v08_rf1_x1_c1 v08_rf1_x1_c1_aez, drop(_cons) ///
						rename(v08_rf1_x1 = "Days" 311.aez#c.v08_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v08_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v08_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v08_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v08_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v08_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v08_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf2_x1_c1 v08_rf2_x1_c1_aez, drop(_cons) ///
						rename(v08_rf2_x1 = "Days " 311.aez#c.v08_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v08_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v08_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v08_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v08_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v08_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v08_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf3_x1_c1 v08_rf3_x1_c1_aez, drop(_cons) ///
						rename(v08_rf3_x1 = " Days" 311.aez#c.v08_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v08_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v08_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v08_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v08_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v08_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v08_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf4_x1_c1 v08_rf4_x1_c1_aez, drop(_cons) ///
						rename(v08_rf4_x1 = " Days " 311.aez#c.v08_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v08_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v08_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v08_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v08_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v08_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v08_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf5_x1_c1 v08_rf5_x1_c1_aez, drop(_cons) ///
						rename(v08_rf5_x1 = "Days  " 311.aez#c.v08_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v08_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v08_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v08_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v08_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v08_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v08_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf6_x1_c1 v08_rf6_x1_c1_aez, drop(_cons) ///
						rename(v08_rf6_x1 = "  Days" 311.aez#c.v08_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v08_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v08_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v08_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v08_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v08_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v08_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Days" = "{bf:CHIRPS}" "Days " ///
						= "{bf:CPC}" " Days" = "{bf:MERRA-2}" " Days " ///
						= "{bf:ARC2}" "Days  " = "{bf:ERA-5}" "  Days" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Ethiopia")
						
* malawi , sat 1
	coefplot		 (v08_rf1_x1_c2 v08_rf1_x1_c2_aez, drop(_cons) ///
						rename(v08_rf1_x1 = "Days" 311.aez#c.v08_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v08_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v08_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v08_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v08_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v08_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v08_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf2_x1_c2 v08_rf2_x1_c2_aez, drop(_cons) ///
						rename(v08_rf2_x1 = "Days " 311.aez#c.v08_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v08_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v08_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v08_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v08_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v08_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v08_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf3_x1_c2 v08_rf3_x1_c2_aez, drop(_cons) ///
						rename(v08_rf3_x1 = " Days" 311.aez#c.v08_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v08_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v08_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v08_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v08_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v08_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v08_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf4_x1_c2 v08_rf4_x1_c2_aez, drop(_cons) ///
						rename(v08_rf4_x1 = " Days " 311.aez#c.v08_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v08_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v08_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v08_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v08_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v08_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v08_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf5_x1_c2 v08_rf5_x1_c2_aez, drop(_cons) ///
						rename(v08_rf5_x1 = "Days  " 311.aez#c.v08_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v08_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v08_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v08_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v08_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v08_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v08_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf6_x1_c2 v08_rf6_x1_c2_aez, drop(_cons) ///
						rename(v08_rf6_x1 = "  Days" 311.aez#c.v08_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v08_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v08_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v08_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v08_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v08_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v08_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Days" = "{bf:CHIRPS}" "Days " ///
						= "{bf:CPC}" " Days" = "{bf:MERRA-2}" " Days " ///
						= "{bf:ARC2}" "Days  " = "{bf:ERA-5}" "  Days" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Malawi")
					
* niger , sat 1
	coefplot		 (v08_rf1_x1_c4 v08_rf1_x1_c4_aez, drop(_cons) ///
						rename(v08_rf1_x1 = "Days" 311.aez#c.v08_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v08_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v08_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v08_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v08_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v08_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v08_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf2_x1_c4 v08_rf2_x1_c4_aez, drop(_cons) ///
						rename(v08_rf2_x1 = "Days " 311.aez#c.v08_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v08_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v08_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v08_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v08_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v08_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v08_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf3_x1_c4 v08_rf3_x1_c4_aez, drop(_cons) ///
						rename(v08_rf3_x1 = " Days" 311.aez#c.v08_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v08_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v08_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v08_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v08_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v08_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v08_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf4_x1_c4 v08_rf4_x1_c4_aez, drop(_cons) ///
						rename(v08_rf4_x1 = " Days " 311.aez#c.v08_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v08_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v08_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v08_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v08_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v08_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v08_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf5_x1_c4 v08_rf5_x1_c4_aez, drop(_cons) ///
						rename(v08_rf5_x1 = "Days  " 311.aez#c.v08_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v08_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v08_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v08_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v08_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v08_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v08_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf6_x1_c4 v08_rf6_x1_c4_aez, drop(_cons) ///
						rename(v08_rf6_x1 = "  Days" 311.aez#c.v08_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v08_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v08_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v08_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v08_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v08_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v08_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Days" = "{bf:CHIRPS}" "Days " ///
						= "{bf:CPC}" " Days" = "{bf:MERRA-2}" " Days " ///
						= "{bf:ARC2}" "Days  " = "{bf:ERA-5}" "  Days" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Niger")
						
					
* nigeria , sat 1
	coefplot		 (v08_rf1_x1_c5 v08_rf1_x1_c5_aez, drop(_cons) ///
						rename(v08_rf1_x1 = "Days" 311.aez#c.v08_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v08_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v08_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v08_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v08_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v08_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v08_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf2_x1_c5 v08_rf2_x1_c5_aez, drop(_cons) ///
						rename(v08_rf2_x1 = "Days " 311.aez#c.v08_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v08_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v08_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v08_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v08_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v08_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v08_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf3_x1_c5 v08_rf3_x1_c5_aez, drop(_cons) ///
						rename(v08_rf3_x1 = " Days" 311.aez#c.v08_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v08_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v08_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v08_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v08_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v08_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v08_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf4_x1_c5 v08_rf4_x1_c5_aez, drop(_cons) ///
						rename(v08_rf4_x1 = " Days " 311.aez#c.v08_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v08_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v08_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v08_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v08_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v08_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v08_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf5_x1_c5 v08_rf5_x1_c5_aez, drop(_cons) ///
						rename(v08_rf5_x1 = "Days  " 311.aez#c.v08_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v08_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v08_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v08_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v08_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v08_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v08_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf6_x1_c5 v08_rf6_x1_c5_aez, drop(_cons) ///
						rename(v08_rf6_x1 = "  Days" 311.aez#c.v08_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v08_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v08_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v08_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v08_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v08_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v08_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Days" = "{bf:CHIRPS}" "Days " ///
						= "{bf:CPC}" " Days" = "{bf:MERRA-2}" " Days " ///
						= "{bf:ARC2}" "Days  " = "{bf:ERA-5}" "  Days" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Nigeria")
						
						
* tanzania , sat 1
	coefplot		 (v08_rf1_x1_c6 v08_rf1_x1_c6_aez, drop(_cons) ///
						rename(v08_rf1_x1 = "Days" 311.aez#c.v08_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v08_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v08_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v08_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v08_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v08_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v08_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf2_x1_c6 v08_rf2_x1_c6_aez, drop(_cons) ///
						rename(v08_rf2_x1 = "Days " 311.aez#c.v08_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v08_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v08_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v08_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v08_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v08_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v08_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf3_x1_c6 v08_rf3_x1_c6_aez, drop(_cons) ///
						rename(v08_rf3_x1 = " Days" 311.aez#c.v08_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v08_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v08_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v08_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v08_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v08_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v08_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf4_x1_c6 v08_rf4_x1_c6_aez, drop(_cons) ///
						rename(v08_rf4_x1 = " Days " 311.aez#c.v08_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v08_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v08_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v08_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v08_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v08_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v08_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf5_x1_c6 v08_rf5_x1_c6_aez, drop(_cons) ///
						rename(v08_rf5_x1 = "Days  " 311.aez#c.v08_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v08_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v08_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v08_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v08_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v08_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v08_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf6_x1_c6 v08_rf6_x1_c6_aez, drop(_cons) ///
						rename(v08_rf6_x1 = "  Days" 311.aez#c.v08_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v08_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v08_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v08_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v08_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v08_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v08_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Days" = "{bf:CHIRPS}" "Days " ///
						= "{bf:CPC}" " Days" = "{bf:MERRA-2}" " Days " ///
						= "{bf:ARC2}" "Days  " = "{bf:ERA-5}" "  Days" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Tanzania")
						
* uganda , sat 1
	coefplot		 (v08_rf1_x1_c7 v08_rf1_x1_c7_aez, drop(_cons) ///
						rename(v08_rf1_x1 = "Days" 311.aez#c.v08_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v08_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v08_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v08_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v08_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v08_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v08_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf2_x1_c7 v08_rf2_x1_c7_aez, drop(_cons) ///
						rename(v08_rf2_x1 = "Days " 311.aez#c.v08_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v08_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v08_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v08_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v08_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v08_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v08_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf3_x1_c7 v08_rf3_x1_c7_aez, drop(_cons) ///
						rename(v08_rf3_x1 = " Days" 311.aez#c.v08_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v08_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v08_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v08_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v08_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v08_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v08_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf4_x1_c7 v08_rf4_x1_c7_aez, drop(_cons) ///
						rename(v08_rf4_x1 = " Days " 311.aez#c.v08_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v08_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v08_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v08_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v08_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v08_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v08_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf5_x1_c7 v08_rf5_x1_c7_aez, drop(_cons) ///
						rename(v08_rf5_x1 = "Days  " 311.aez#c.v08_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v08_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v08_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v08_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v08_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v08_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v08_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v08_rf6_x1_c7 v08_rf6_x1_c7_aez, drop(_cons) ///
						rename(v08_rf6_x1 = "  Days" 311.aez#c.v08_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v08_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v08_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v08_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v08_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v08_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v08_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Days" = "{bf:CHIRPS}" "Days " ///
						= "{bf:CPC}" " Days" = "{bf:MERRA-2}" " Days " ///
						= "{bf:ARC2}" "Days  " = "{bf:ERA-5}" "  Days" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Uganda")
*/						
												
/*
clear all

* **********************************************************************
* 1 - read in cross country panel keep v12
* **********************************************************************

* read in data file
	use			"$source/lsms_panel.dta", clear

* drop aez with only a few observations
	drop		if aez ==321
	
* drop non-extraction method 1
	drop		*_x0 *_x2 *_x3 *_x4 *_x5 *_x6 *_x7 *_x8 *_x9
	
* drop temperature
	drop		*tp*
	
* drop all but mean
	drop		v01* v02* v03* v04* v05* v06* v07* v08* v09* v10* v11* v13* v14*
	
* set panel dimensions
	xtset 		hhid year
	

* **********************************************************************
* 2 - country and sat regs by aez
* **********************************************************************	
				
* create local of weather variables
	loc		weather 	v*
				
* define loop through levels of country
levelsof 	country		, local(levels)
foreach c of local levels {

	* rainfall			
		foreach 	v of varlist `weather' { 

		* reg weather only
			xtreg 		lntf_yld `v' if country == `c', ///
							fe vce(cluster hhid)
			eststo 		`v'_c`c'
		}
}	

foreach c of local levels {

	* rainfall			
		foreach 	v of varlist `weather' { 

		* reg weather by aez
			xtreg 		lntf_yld c.`v'#i.aez if country == `c', ///
							fe vce(cluster hhid)
			eststo 		`v'_c`c'_aez
		}
}	

* ethiopia, sat 1
	coefplot		 (v12_rf1_x1_c1 v12_rf1_x1_c1_aez, drop(_cons) ///
						rename(v12_rf1_x1 = "Percent Days" 311.aez#c.v12_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v12_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v12_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v12_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v12_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v12_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v12_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf2_x1_c1 v12_rf2_x1_c1_aez, drop(_cons) ///
						rename(v12_rf2_x1 = "Percent Days " 311.aez#c.v12_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v12_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v12_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v12_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v12_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v12_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v12_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf3_x1_c1 v12_rf3_x1_c1_aez, drop(_cons) ///
						rename(v12_rf3_x1 = " Percent Days" 311.aez#c.v12_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v12_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v12_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v12_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v12_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v12_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v12_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf4_x1_c1 v12_rf4_x1_c1_aez, drop(_cons) ///
						rename(v12_rf4_x1 = " Percent Days " 311.aez#c.v12_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v12_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v12_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v12_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v12_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v12_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v12_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf5_x1_c1 v12_rf5_x1_c1_aez, drop(_cons) ///
						rename(v12_rf5_x1 = "Percent Days  " 311.aez#c.v12_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v12_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v12_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v12_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v12_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v12_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v12_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf6_x1_c1 v12_rf6_x1_c1_aez, drop(_cons) ///
						rename(v12_rf6_x1 = "  Percent Days" 311.aez#c.v12_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v12_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v12_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v12_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v12_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v12_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v12_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Percent Days" = "{bf:CHIRPS}" "Percent Days " ///
						= "{bf:CPC}" " Percent Days" = "{bf:MERRA-2}" " Percent Days " ///
						= "{bf:ARC2}" "Percent Days  " = "{bf:ERA-5}" "  Percent Days" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Ethiopia")
						
* malawi , sat 1
	coefplot		 (v12_rf1_x1_c2 v12_rf1_x1_c2_aez, drop(_cons) ///
						rename(v12_rf1_x1 = "Percent Days" 311.aez#c.v12_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v12_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v12_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v12_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v12_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v12_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v12_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf2_x1_c2 v12_rf2_x1_c2_aez, drop(_cons) ///
						rename(v12_rf2_x1 = "Percent Days " 311.aez#c.v12_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v12_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v12_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v12_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v12_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v12_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v12_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf3_x1_c2 v12_rf3_x1_c2_aez, drop(_cons) ///
						rename(v12_rf3_x1 = " Percent Days" 311.aez#c.v12_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v12_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v12_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v12_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v12_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v12_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v12_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf4_x1_c2 v12_rf4_x1_c2_aez, drop(_cons) ///
						rename(v12_rf4_x1 = " Percent Days " 311.aez#c.v12_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v12_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v12_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v12_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v12_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v12_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v12_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf5_x1_c2 v12_rf5_x1_c2_aez, drop(_cons) ///
						rename(v12_rf5_x1 = "Percent Days  " 311.aez#c.v12_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v12_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v12_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v12_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v12_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v12_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v12_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf6_x1_c2 v12_rf6_x1_c2_aez, drop(_cons) ///
						rename(v12_rf6_x1 = "  Percent Days" 311.aez#c.v12_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v12_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v12_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v12_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v12_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v12_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v12_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Percent Days" = "{bf:CHIRPS}" "Percent Days " ///
						= "{bf:CPC}" " Percent Days" = "{bf:MERRA-2}" " Percent Days " ///
						= "{bf:ARC2}" "Percent Days  " = "{bf:ERA-5}" "  Percent Days" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Malawi")
					
* niger , sat 1
	coefplot		 (v12_rf1_x1_c4 v12_rf1_x1_c4_aez, drop(_cons) ///
						rename(v12_rf1_x1 = "Percent Days" 311.aez#c.v12_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v12_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v12_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v12_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v12_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v12_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v12_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf2_x1_c4 v12_rf2_x1_c4_aez, drop(_cons) ///
						rename(v12_rf2_x1 = "Percent Days " 311.aez#c.v12_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v12_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v12_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v12_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v12_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v12_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v12_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf3_x1_c4 v12_rf3_x1_c4_aez, drop(_cons) ///
						rename(v12_rf3_x1 = " Percent Days" 311.aez#c.v12_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v12_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v12_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v12_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v12_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v12_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v12_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf4_x1_c4 v12_rf4_x1_c4_aez, drop(_cons) ///
						rename(v12_rf4_x1 = " Percent Days " 311.aez#c.v12_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v12_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v12_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v12_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v12_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v12_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v12_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf5_x1_c4 v12_rf5_x1_c4_aez, drop(_cons) ///
						rename(v12_rf5_x1 = "Percent Days  " 311.aez#c.v12_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v12_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v12_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v12_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v12_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v12_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v12_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf6_x1_c4 v12_rf6_x1_c4_aez, drop(_cons) ///
						rename(v12_rf6_x1 = "  Percent Days" 311.aez#c.v12_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v12_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v12_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v12_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v12_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v12_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v12_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Percent Days" = "{bf:CHIRPS}" "Percent Days " ///
						= "{bf:CPC}" " Percent Days" = "{bf:MERRA-2}" " Percent Days " ///
						= "{bf:ARC2}" "Percent Days  " = "{bf:ERA-5}" "  Percent Days" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Niger")
						
					
* nigeria , sat 1
	coefplot		 (v12_rf1_x1_c5 v12_rf1_x1_c5_aez, drop(_cons) ///
						rename(v12_rf1_x1 = "Percent Days" 311.aez#c.v12_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v12_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v12_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v12_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v12_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v12_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v12_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf2_x1_c5 v12_rf2_x1_c5_aez, drop(_cons) ///
						rename(v12_rf2_x1 = "Percent Days " 311.aez#c.v12_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v12_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v12_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v12_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v12_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v12_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v12_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf3_x1_c5 v12_rf3_x1_c5_aez, drop(_cons) ///
						rename(v12_rf3_x1 = " Percent Days" 311.aez#c.v12_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v12_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v12_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v12_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v12_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v12_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v12_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf4_x1_c5 v12_rf4_x1_c5_aez, drop(_cons) ///
						rename(v12_rf4_x1 = " Percent Days " 311.aez#c.v12_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v12_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v12_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v12_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v12_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v12_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v12_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf5_x1_c5 v12_rf5_x1_c5_aez, drop(_cons) ///
						rename(v12_rf5_x1 = "Percent Days  " 311.aez#c.v12_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v12_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v12_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v12_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v12_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v12_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v12_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf6_x1_c5 v12_rf6_x1_c5_aez, drop(_cons) ///
						rename(v12_rf6_x1 = "  Percent Days" 311.aez#c.v12_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v12_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v12_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v12_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v12_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v12_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v12_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Percent Days" = "{bf:CHIRPS}" "Percent Days " ///
						= "{bf:CPC}" " Percent Days" = "{bf:MERRA-2}" " Percent Days " ///
						= "{bf:ARC2}" "Percent Days  " = "{bf:ERA-5}" "  Percent Days" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Nigeria")
						
						
* tanzania , sat 1
	coefplot		 (v12_rf1_x1_c6 v12_rf1_x1_c6_aez, drop(_cons) ///
						rename(v12_rf1_x1 = "Percent Days" 311.aez#c.v12_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v12_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v12_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v12_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v12_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v12_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v12_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf2_x1_c6 v12_rf2_x1_c6_aez, drop(_cons) ///
						rename(v12_rf2_x1 = "Percent Days " 311.aez#c.v12_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v12_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v12_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v12_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v12_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v12_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v12_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf3_x1_c6 v12_rf3_x1_c6_aez, drop(_cons) ///
						rename(v12_rf3_x1 = " Percent Days" 311.aez#c.v12_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v12_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v12_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v12_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v12_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v12_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v12_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf4_x1_c6 v12_rf4_x1_c6_aez, drop(_cons) ///
						rename(v12_rf4_x1 = " Percent Days " 311.aez#c.v12_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v12_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v12_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v12_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v12_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v12_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v12_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf5_x1_c6 v12_rf5_x1_c6_aez, drop(_cons) ///
						rename(v12_rf5_x1 = "Percent Days  " 311.aez#c.v12_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v12_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v12_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v12_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v12_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v12_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v12_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf6_x1_c6 v12_rf6_x1_c6_aez, drop(_cons) ///
						rename(v12_rf6_x1 = "  Percent Days" 311.aez#c.v12_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v12_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v12_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v12_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v12_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v12_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v12_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Percent Days" = "{bf:CHIRPS}" "Percent Days " ///
						= "{bf:CPC}" " Percent Days" = "{bf:MERRA-2}" " Percent Days " ///
						= "{bf:ARC2}" "Percent Days  " = "{bf:ERA-5}" "  Percent Days" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Tanzania")
						
* uganda , sat 1
	coefplot		 (v12_rf1_x1_c7 v12_rf1_x1_c7_aez, drop(_cons) ///
						rename(v12_rf1_x1 = "Percent Days" 311.aez#c.v12_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v12_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v12_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v12_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v12_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v12_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v12_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf2_x1_c7 v12_rf2_x1_c7_aez, drop(_cons) ///
						rename(v12_rf2_x1 = "Percent Days " 311.aez#c.v12_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v12_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v12_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v12_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v12_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v12_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v12_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf3_x1_c7 v12_rf3_x1_c7_aez, drop(_cons) ///
						rename(v12_rf3_x1 = " Percent Days" 311.aez#c.v12_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v12_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v12_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v12_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v12_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v12_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v12_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf4_x1_c7 v12_rf4_x1_c7_aez, drop(_cons) ///
						rename(v12_rf4_x1 = " Percent Days " 311.aez#c.v12_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v12_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v12_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v12_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v12_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v12_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v12_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf5_x1_c7 v12_rf5_x1_c7_aez, drop(_cons) ///
						rename(v12_rf5_x1 = "Percent Days  " 311.aez#c.v12_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v12_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v12_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v12_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v12_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v12_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v12_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v12_rf6_x1_c7 v12_rf6_x1_c7_aez, drop(_cons) ///
						rename(v12_rf6_x1 = "  Percent Days" 311.aez#c.v12_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v12_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v12_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v12_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v12_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v12_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v12_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Percent Days" = "{bf:CHIRPS}" "Percent Days " ///
						= "{bf:CPC}" " Percent Days" = "{bf:MERRA-2}" " Percent Days " ///
						= "{bf:ARC2}" "Percent Days  " = "{bf:ERA-5}" "  Percent Days" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Uganda")
*/

	
clear all

* **********************************************************************
* 1 - read in cross country panel keep v14
* **********************************************************************

* read in data file
	use			"$source/lsms_panel.dta", clear

* drop aez with only a few observations
	drop		if aez ==321
	
* drop non-extraction method 1
	drop		*_x0 *_x2 *_x3 *_x4 *_x5 *_x6 *_x7 *_x8 *_x9
	
* drop temperature
	drop		*tp*
	
* drop all but mean
	drop		v01* v02* v03* v04* v05* v06* v07* v08* v09* v10* v11* v12* v13*
	
* set panel dimensions
	xtset 		hhid year
	

* **********************************************************************
* 2 - country and sat regs by aez
* **********************************************************************	
				
* create local of weather variables
	loc		weather 	v*
				
* define loop through levels of country
levelsof 	country		, local(levels)
foreach c of local levels {

	* rainfall			
		foreach 	v of varlist `weather' { 

		* reg weather only
			xtreg 		lntf_yld `v' if country == `c', ///
							fe vce(cluster hhid)
			eststo 		`v'_c`c'
		}
}	

foreach c of local levels {

	* rainfall			
		foreach 	v of varlist `weather' { 

		* reg weather by aez
			xtreg 		lntf_yld c.`v'#i.aez if country == `c', ///
							fe vce(cluster hhid)
			eststo 		`v'_c`c'_aez
		}
}	

* ethiopia, sat 1
	coefplot		 (v14_rf1_x1_c1 v14_rf1_x1_c1_aez, drop(_cons) ///
						rename(v14_rf1_x1 = "Dry Spell" 311.aez#c.v14_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v14_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v14_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v14_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v14_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v14_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v14_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf2_x1_c1 v14_rf2_x1_c1_aez, drop(_cons) ///
						rename(v14_rf2_x1 = "Dry Spell " 311.aez#c.v14_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v14_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v14_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v14_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v14_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v14_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v14_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf3_x1_c1 v14_rf3_x1_c1_aez, drop(_cons) ///
						rename(v14_rf3_x1 = " Dry Spell" 311.aez#c.v14_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v14_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v14_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v14_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v14_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v14_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v14_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf4_x1_c1 v14_rf4_x1_c1_aez, drop(_cons) ///
						rename(v14_rf4_x1 = " Dry Spell " 311.aez#c.v14_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v14_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v14_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v14_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v14_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v14_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v14_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf5_x1_c1 v14_rf5_x1_c1_aez, drop(_cons) ///
						rename(v14_rf5_x1 = "Dry Spell  " 311.aez#c.v14_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v14_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v14_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v14_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v14_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v14_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v14_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf6_x1_c1 v14_rf6_x1_c1_aez, drop(_cons) ///
						rename(v14_rf6_x1 = "  Dry Spell" 311.aez#c.v14_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v14_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v14_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v14_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v14_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v14_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v14_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Dry Spell" = "{bf:CHIRPS}" "Dry Spell " ///
						= "{bf:CPC}" " Dry Spell" = "{bf:MERRA-2}" " Dry Spell " ///
						= "{bf:ARC2}" "Dry Spell  " = "{bf:ERA-5}" "  Dry Spell" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Ethiopia")
						
* malawi , sat 1
	coefplot		 (v14_rf1_x1_c2 v14_rf1_x1_c2_aez, drop(_cons) ///
						rename(v14_rf1_x1 = "Dry Spell" 311.aez#c.v14_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v14_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v14_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v14_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v14_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v14_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v14_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf2_x1_c2 v14_rf2_x1_c2_aez, drop(_cons) ///
						rename(v14_rf2_x1 = "Dry Spell " 311.aez#c.v14_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v14_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v14_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v14_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v14_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v14_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v14_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf3_x1_c2 v14_rf3_x1_c2_aez, drop(_cons) ///
						rename(v14_rf3_x1 = " Dry Spell" 311.aez#c.v14_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v14_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v14_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v14_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v14_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v14_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v14_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf4_x1_c2 v14_rf4_x1_c2_aez, drop(_cons) ///
						rename(v14_rf4_x1 = " Dry Spell " 311.aez#c.v14_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v14_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v14_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v14_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v14_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v14_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v14_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf5_x1_c2 v14_rf5_x1_c2_aez, drop(_cons) ///
						rename(v14_rf5_x1 = "Dry Spell  " 311.aez#c.v14_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v14_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v14_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v14_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v14_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v14_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v14_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf6_x1_c2 v14_rf6_x1_c2_aez, drop(_cons) ///
						rename(v14_rf6_x1 = "  Dry Spell" 311.aez#c.v14_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v14_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v14_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v14_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v14_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v14_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v14_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Dry Spell" = "{bf:CHIRPS}" "Dry Spell " ///
						= "{bf:CPC}" " Dry Spell" = "{bf:MERRA-2}" " Dry Spell " ///
						= "{bf:ARC2}" "Dry Spell  " = "{bf:ERA-5}" "  Dry Spell" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Malawi")
					
* niger , sat 1
	coefplot		 (v14_rf1_x1_c4 v14_rf1_x1_c4_aez, drop(_cons) ///
						rename(v14_rf1_x1 = "Dry Spell" 311.aez#c.v14_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v14_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v14_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v14_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v14_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v14_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v14_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf2_x1_c4 v14_rf2_x1_c4_aez, drop(_cons) ///
						rename(v14_rf2_x1 = "Dry Spell " 311.aez#c.v14_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v14_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v14_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v14_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v14_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v14_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v14_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf3_x1_c4 v14_rf3_x1_c4_aez, drop(_cons) ///
						rename(v14_rf3_x1 = " Dry Spell" 311.aez#c.v14_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v14_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v14_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v14_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v14_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v14_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v14_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf4_x1_c4 v14_rf4_x1_c4_aez, drop(_cons) ///
						rename(v14_rf4_x1 = " Dry Spell " 311.aez#c.v14_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v14_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v14_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v14_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v14_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v14_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v14_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf5_x1_c4 v14_rf5_x1_c4_aez, drop(_cons) ///
						rename(v14_rf5_x1 = "Dry Spell  " 311.aez#c.v14_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v14_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v14_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v14_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v14_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v14_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v14_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf6_x1_c4 v14_rf6_x1_c4_aez, drop(_cons) ///
						rename(v14_rf6_x1 = "  Dry Spell" 311.aez#c.v14_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v14_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v14_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v14_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v14_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v14_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v14_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Dry Spell" = "{bf:CHIRPS}" "Dry Spell " ///
						= "{bf:CPC}" " Dry Spell" = "{bf:MERRA-2}" " Dry Spell " ///
						= "{bf:ARC2}" "Dry Spell  " = "{bf:ERA-5}" "  Dry Spell" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Niger")
						
					
* nigeria , sat 1
	coefplot		 (v14_rf1_x1_c5 v14_rf1_x1_c5_aez, drop(_cons) ///
						rename(v14_rf1_x1 = "Dry Spell" 311.aez#c.v14_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v14_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v14_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v14_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v14_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v14_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v14_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf2_x1_c5 v14_rf2_x1_c5_aez, drop(_cons) ///
						rename(v14_rf2_x1 = "Dry Spell " 311.aez#c.v14_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v14_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v14_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v14_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v14_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v14_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v14_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf3_x1_c5 v14_rf3_x1_c5_aez, drop(_cons) ///
						rename(v14_rf3_x1 = " Dry Spell" 311.aez#c.v14_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v14_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v14_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v14_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v14_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v14_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v14_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf4_x1_c5 v14_rf4_x1_c5_aez, drop(_cons) ///
						rename(v14_rf4_x1 = " Dry Spell " 311.aez#c.v14_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v14_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v14_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v14_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v14_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v14_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v14_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf5_x1_c5 v14_rf5_x1_c5_aez, drop(_cons) ///
						rename(v14_rf5_x1 = "Dry Spell  " 311.aez#c.v14_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v14_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v14_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v14_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v14_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v14_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v14_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf6_x1_c5 v14_rf6_x1_c5_aez, drop(_cons) ///
						rename(v14_rf6_x1 = "  Dry Spell" 311.aez#c.v14_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v14_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v14_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v14_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v14_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v14_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v14_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Dry Spell" = "{bf:CHIRPS}" "Dry Spell " ///
						= "{bf:CPC}" " Dry Spell" = "{bf:MERRA-2}" " Dry Spell " ///
						= "{bf:ARC2}" "Dry Spell  " = "{bf:ERA-5}" "  Dry Spell" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Nigeria")
						
						
* tanzania , sat 1
	coefplot		 (v14_rf1_x1_c6 v14_rf1_x1_c6_aez, drop(_cons) ///
						rename(v14_rf1_x1 = "Dry Spell" 311.aez#c.v14_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v14_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v14_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v14_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v14_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v14_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v14_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf2_x1_c6 v14_rf2_x1_c6_aez, drop(_cons) ///
						rename(v14_rf2_x1 = "Dry Spell " 311.aez#c.v14_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v14_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v14_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v14_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v14_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v14_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v14_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf3_x1_c6 v14_rf3_x1_c6_aez, drop(_cons) ///
						rename(v14_rf3_x1 = " Dry Spell" 311.aez#c.v14_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v14_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v14_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v14_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v14_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v14_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v14_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf4_x1_c6 v14_rf4_x1_c6_aez, drop(_cons) ///
						rename(v14_rf4_x1 = " Dry Spell " 311.aez#c.v14_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v14_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v14_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v14_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v14_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v14_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v14_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf5_x1_c6 v14_rf5_x1_c6_aez, drop(_cons) ///
						rename(v14_rf5_x1 = "Dry Spell  " 311.aez#c.v14_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v14_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v14_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v14_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v14_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v14_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v14_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf6_x1_c6 v14_rf6_x1_c6_aez, drop(_cons) ///
						rename(v14_rf6_x1 = "  Dry Spell" 311.aez#c.v14_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v14_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v14_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v14_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v14_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v14_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v14_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Dry Spell" = "{bf:CHIRPS}" "Dry Spell " ///
						= "{bf:CPC}" " Dry Spell" = "{bf:MERRA-2}" " Dry Spell " ///
						= "{bf:ARC2}" "Dry Spell  " = "{bf:ERA-5}" "  Dry Spell" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Tanzania")
						
* uganda , sat 1
	coefplot		 (v14_rf1_x1_c7 v14_rf1_x1_c7_aez, drop(_cons) ///
						rename(v14_rf1_x1 = "Dry Spell" 311.aez#c.v14_rf1_x1 = ///
						" TW/A X Rainfall " 312.aez#c.v14_rf1_x1 = ///
						" TW/SA X Rainfall " 313.aez#c.v14_rf1_x1 = ///
						" TW/SH X Rainfall " 314.aez#c.v14_rf1_x1 = ///
						" TW/H X Rainfall " 322.aez#c.v14_rf1_x1 = ///
						" TC/SA X Rainfall " 323.aez#c.v14_rf1_x1 = ///
						" TC/SH X Rainfall " 324.aez#c.v14_rf1_x1 = ///
						" TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf2_x1_c7 v14_rf2_x1_c7_aez, drop(_cons) ///
						rename(v14_rf2_x1 = "Dry Spell " 311.aez#c.v14_rf2_x1 = ///
						"TW/A X Rainfall" 312.aez#c.v14_rf2_x1 = ///
						"TW/SA X Rainfall" 313.aez#c.v14_rf2_x1 = ///
						"TW/SH X Rainfall" 314.aez#c.v14_rf2_x1 = ///
						"TW/H X Rainfall" 322.aez#c.v14_rf2_x1 = ///
						"TC/SA X Rainfall" 323.aez#c.v14_rf2_x1 = ///
						"TC/SH X Rainfall" 324.aez#c.v14_rf2_x1 = ///
						"TC/H X Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf3_x1_c7 v14_rf3_x1_c7_aez, drop(_cons) ///
						rename(v14_rf3_x1 = " Dry Spell" 311.aez#c.v14_rf1_x1 = ///
						"  TW/A X Rainfall " 312.aez#c.v14_rf3_x1 = ///
						"  TW/SA X Rainfall " 313.aez#c.v14_rf3_x1 = ///
						"  TW/SH X Rainfall " 314.aez#c.v14_rf3_x1 = ///
						"  TW/H X Rainfall " 322.aez#c.v14_rf3_x1 = ///
						"  TC/SA X Rainfall " 323.aez#c.v14_rf3_x1 = ///
						"  TC/SH X Rainfall " 324.aez#c.v14_rf3_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf4_x1_c7 v14_rf4_x1_c7_aez, drop(_cons) ///
						rename(v14_rf4_x1 = " Dry Spell " 311.aez#c.v14_rf4_x1 = ///
						"  TW/A X Rainfall  " 312.aez#c.v14_rf4_x1 = ///
						"  TW/SA X Rainfall  " 313.aez#c.v14_rf4_x1 = ///
						"  TW/SH X Rainfall  " 314.aez#c.v14_rf4_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v14_rf4_x1 = ///
						"  TC/SA X Rainfall  " 323.aez#c.v14_rf4_x1 = ///
						"  TC/SH X Rainfall  " 324.aez#c.v14_rf4_x1 = ///
						"  TC/H X Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf5_x1_c7 v14_rf5_x1_c7_aez, drop(_cons) ///
						rename(v14_rf5_x1 = "Dry Spell  " 311.aez#c.v14_rf2_x1 = ///
						"TW/A X Rainfall " 312.aez#c.v14_rf5_x1 = ///
						"TW/SA X Rainfall " 313.aez#c.v14_rf5_x1 = ///
						"TW/SH X Rainfall " 314.aez#c.v14_rf5_x1 = ///
						"TW/H X Rainfall " 322.aez#c.v14_rf5_x1 = ///
						"TC/SA X Rainfall " 323.aez#c.v14_rf5_x1 = ///
						"TC/SH X Rainfall " 324.aez#c.v14_rf5_x1 = ///
						"TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v14_rf6_x1_c7 v14_rf6_x1_c7_aez, drop(_cons) ///
						rename(v14_rf6_x1 = "  Dry Spell" 311.aez#c.v14_rf1_x1 = ///
						"  TW/A X Rainfall   " 312.aez#c.v14_rf6_x1 = ///
						"  TW/SA X Rainfall   " 313.aez#c.v14_rf6_x1 = ///
						"  TW/SH X Rainfall   " 314.aez#c.v14_rf6_x1 = ///
						"  TW/H X Rainfall  " 322.aez#c.v14_rf6_x1 = ///
						"  TC/SA X Rainfall   " 323.aez#c.v14_rf6_x1 = ///
						"  TC/SH X Rainfall   " 324.aez#c.v14_rf6_x1 = ///
						"  TC/H X Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Dry Spell" = "{bf:CHIRPS}" "Dry Spell " ///
						= "{bf:CPC}" " Dry Spell" = "{bf:MERRA-2}" " Dry Spell " ///
						= "{bf:ARC2}" "Dry Spell  " = "{bf:ERA-5}" "  Dry Spell" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) title("Uganda")
*/
	
	
	
	
	
	
	
/*	
	xline(0, lcolor(maroon) lstyle(solid)) levels(95))
				
				
	coefplot		(std_fsi_25, label(Diff-in-Diff) keep(1.post#2.sector) /// bkf
							rename(1.post#2.sector = "FIES Score") msymbol(D) ///
							mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
							(mld_fsi_25, label(Diff-in-Diff) keep(1.post#2.sector) ///
							rename(1.post#2.sector = "Mild Insecurity") msymbol(D) ///
							mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
							(mod_fsi_25, label(Diff-in-Diff) keep(1.post#2.sector) ///
							rename(1.post#2.sector = "Moderate Insecurity") msymbol(D) ///
							mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
							(sev_fsi_25, label(Diff-in-Diff) keep(1.post#2.sector) ///
							rename(1.post#2.sector = "Severe Insecurity") msymbol(D) ///
							mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
							(std_fsi_21, label(Diff-in-Diff) keep(1.post#2.sector) /// eth
							rename(1.post#2.sector = "FIES Score ") msymbol(D) ///
							mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
							(mld_fsi_21, label(Diff-in-Diff) keep(1.post#2.sector) ///
							rename(1.post#2.sector = "Mild Insecurity ") msymbol(D) ///
							mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
							(mod_fsi_21, label(Diff-in-Diff) keep(1.post#2.sector) ///
							rename(1.post#2.sector = "Moderate Insecurity ") msymbol(D) ///
							mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
							(sev_fsi_21, label(Diff-in-Diff) keep(1.post#2.sector) ///
							rename(1.post#2.sector = "Severe Insecurity ") msymbol(D) ///
							mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
							(std_fsi_22, label(Diff-in-Diff) keep(1.post#2.sector) /// mwi
							rename(1.post#2.sector = " FIES Score") msymbol(D) ///
							mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
							(mld_fsi_22, label(Diff-in-Diff) keep(1.post#2.sector) ///
							rename(1.post#2.sector = " Mild Insecurity") msymbol(D) ///
							mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
							(mod_fsi_22, label(Diff-in-Diff) keep(1.post#2.sector) ///
							rename(1.post#2.sector = " Moderate Insecurity") msymbol(D) ///
							mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
							(sev_fsi_22, label(Diff-in-Diff) keep(1.post#2.sector) ///
							rename(1.post#2.sector = " Severe Insecurity") msymbol(D) ///
							mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
							(std_fsi_23, label(Diff-in-Diff) keep(1.post#2.sector) /// nga
							rename(1.post#2.sector = " FIES Score ") msymbol(D) ///
							mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
							(mld_fsi_23, label(Diff-in-Diff) keep(1.post#2.sector) ///
							rename(1.post#2.sector = " Mild Insecurity ") msymbol(D) ///
							mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
							(mod_fsi_23, label(Diff-in-Diff) keep(1.post#2.sector) ///
							rename(1.post#2.sector = " Moderate Insecurity ") msymbol(D) ///
							mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
							(sev_fsi_23, label(Diff-in-Diff) keep(1.post#2.sector) ///
							rename(1.post#2.sector = " Severe Insecurity ") msymbol(D) ///
							mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) , ///
							xline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
							xtitle("Point Estimates and 95% Confidence Intervals") ///
							headings("FIES Score" = "{bf:Burkina Faso}" "FIES Score " ///
							= "{bf:Ethiopia}" " FIES Score" = "{bf:Malawi}" ///
							" FIES Score " = "{bf:Nigeria}")  ///
							legend(off) ///
							saving("$fig/coef_sector_did", replace)	
*/