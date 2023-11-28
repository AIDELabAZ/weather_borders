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

	clear		all

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
						rename(v01_rf1_x1 = "Rainfall" 312.aez#c.v01_rf1_x1 = ///
						"Tropic-warm/semiarid X Rainfall" 322.aez#c.v01_rf1_x1 = ///
						"Tropic-cool/semiarid") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf2_x1_c1 v01_rf2_x1_c1_aez, drop(_cons) ///
						rename(v01_rf2_x1 = "Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf3_x1_c1 v01_rf3_x1_c1_aez, drop(_cons) ///
						rename(v01_rf3_x1 = " Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf4_x1_c1 v01_rf4_x1_c1_aez, drop(_cons) ///
						rename(v01_rf4_x1 = " Rainfall ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf5_x1_c1 v01_rf5_x1_c1_aez, drop(_cons) ///
						rename(v01_rf5_x1 = "Rainfall  ") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ) ///
					 (v01_rf6_x1_c1 v01_rf6_x1_c1_aez, drop(_cons) ///
						rename(v01_rf6_x1 = "  Rainfall") msymbol(D) ///
						mcolor(gs8) mfcolor(white) ciopts(color(edkblue)) ), ///
					yline(0, lcolor(maroon)) levels(95) ciopts(lwidth(*3) lcolor(*3) ) ///
						ytitle("Point Estimates and 95% Confidence Intervals") ///
						groups("Rainfall" = "{bf:CHIRPS}" "Rainfall " ///
						= "{bf:CPC}" " Rainfall" = "{bf:MERRA-2}" " Rainfall " ///
						= "{bf:ARC2}" "Rainfall  " = "{bf:ERA-5}" "  Rainfall" ///
						= "{bf:TAMSAT}" ) vertical xlabel( , angle(45) ///
						labsize(vsmall)) legend(off) 
						
						
						
						
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