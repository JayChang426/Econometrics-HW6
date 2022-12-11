clear all
cd "/Users/changjay/Desktop/計量經濟學/HW6"

use "JTRAIN_revised.dta", clear

gen log_employ = log(employ)
gen year_1 = 1 if year == 1988
replace year_1 = 0 if year_1 == .
gen year_2 = 1 if year == 1989
replace year_2 = 0 if year_2 == .

* Q1 (a), (b)
xtset fcode
xtreg hrsemp grant log_employ year_1 year_2, fe // obs: 390, groups: 135, not all firms are used since missing value in employ
display _b[grant] // = 29.120188

* Q1 (c), (d)
egen years_received = total(grant), by(fcode) // This is to tell whether firms received grants in 1988 or 1989
gen grant_1988 = 1 if year == 1988 & years_received == 2 // firms recieved grants in 1988
replace grant_1988 = 0 if grant_1988 == .
gen grant_1989 = 1 if year == 1989 & years_received == 1 // firms recieved grants in 1989
replace grant_1989 = 0 if grant_1989 == .

gen grant_first = 1 if grant_1988 == 1 | grant_1989 == 1
replace grant_first = 0 if grant_first == .
gen grant_second = 1 if grant == 1 & grant_1989 == 0 & year == 1989
replace grant_second = 0 if grant_second == .

xtreg hrsemp grant_first grant_second log_employ year_1 year_2, fe
display _b[grant_first] // 34.228179
display _b[grant_second] // 0.50408042

* Q2 
clear all
use "ushouse_election.dta", clear
graph twoway (scatter win_dem demvoteshare) // sharp RD with cut-off 0.5
npregress kernel win_dem_t1 demvoteshare

* net install rdrobust, from(https://raw.githubusercontent.com/rdpackages/rdrobust/master/stata) replace
rdplot win_dem_t1 demvoteshare, c(0.5) // the RD plot
