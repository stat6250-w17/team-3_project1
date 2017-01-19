*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
This file prepares the dataset described below for analysis.
Dataset Name: Student Poverty Free or Reduced Price Meals (FRPM) Data
Experimental Units: California public K-12 schools
Number of Observations: 10,453
Number of Features: 28
Data Source: The file http://www.cde.ca.gov/ds/sd/sd/documents/frpm1516.xls was
downloaded and edited to produce file frpm1516-edited.xls by deleting worksheet
"Title Page", deleting row 1 from worksheet "FRPM School-Level Data",
reformatting column headers in "FRPM School-Level Data" to remove characters
disallowed in SAS variable names, and setting all cell values to "Text" format
Data Dictionary: http://www.cde.ca.gov/ds/sd/sd/fsspfrpm.asp or worksheet
"Data Field Descriptions" in file frpm1516-edited.xls
Unique ID: The columns County_Code, District_Code, and School_Code form a
composite key
;

* setup environmental parameters;
%let inputDatasetURL =
https://raw.githubusercontent.com/stat6250/team-3_project1/Jeff_step_2/14avgtx.txt
;

* load raw FRPM dataset over the wire;
filename FRPMtemp TEMP;
proc http
    method="get" 
    url="&inputDatasetURL." 
    out=FRPMtemp
    ;
run;
proc import
    file=FRPMtemp
    out=FRPM1516_raw
    dbms=txt
    ;
run;
filename FRPMtemp clear;

data work.s_test;
	infile 'FRPMtemp';
	input s_name $ 20-59;
run;

proc print data=work.s_test;
run;
