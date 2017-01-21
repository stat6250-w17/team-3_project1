*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;
* 
 Dataset Name: Academic Performance Index(API)_analytic_file created in external
 file STAT6250-01_w17-team-3_project1_data_preparation.sas, which is assumed to 
 be in the same directory as this file

* Environmental setup;

* set relative file import path to current directory (using standard SAS trick);

* Environmental Variables ;
%let dataPrepFileName = STAT6250-01_w17-team-3_project1_data_preparation.sas;
%let sasUEFilePrefix = proj1/team-3_project1;

* load external file that generates analytic dataset Academic Performance 
  Index(API)_analytic_file using a system path dependent on the host operating 
  system, after setting the relative file import path to the current directory, 
  if using Windows;
  
%macro setup;
%if
	&SYSSCP. = WIN
%then
	%do;
		X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";			
		%include ".\&dataPrepFileName.";
	%end;
%else
	%do;
		%include "~/&sasUEFilePrefix./&dataPrepFileName.";
	%end;
%mend;
%setup;

*
Research Question : What are the top ten districts having highest API score in 
year 2012 ,2012 and 2013 ?

Rationale: This would help us determine which top 10 districts have good average
API, so that new school and underperformers can follow their best practices.

Methodology: Use PROC SORT by Dname to sort the district name in descending 
order because we will be grouping the district name together for average API's
for the district and it is a good practice to sort it first.Converted char 
varaible to numeric for mean calculation.USed PROc means to calculate average
of API's for 2011 grouped by district name.Used PROC SORT to sort the mean data
descending.Used PROC print with OBS=10 to print top 10 district name with resppect
to average API for 2011.



*
Research Question :Which races have an average API below and above the mean of 
overall API in each county for the year 2013 ?

Rationale:This would help idetify the races that score API below the average  
of overall API.In other words races that are underperformers and are affecting
the API score needs to be get more attention and resourses in order for them
to meet good API standards.

Methodology:
;
*
Research Question :What is the average API score in 2013 for funded charter non 
directly funded charter and non chater schools?

Rationale:This will help us determine the performance of charters and non charters
schools following which we can look for the reasons for variation in API scores. 

Methodology:
;