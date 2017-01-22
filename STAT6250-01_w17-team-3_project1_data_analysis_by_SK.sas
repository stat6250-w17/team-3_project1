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

* load external file that generates analytic dataset "api_analytic_file" using
 a system path dependent on the host operating system, after setting the 
 relative file import path to the current directory, if using Windows;
  
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
Research Question - What are the top ten districts having highest API score in 
year 2012 ,2012 and 2013 ?

Rationale-This would help us determine which top 10 districts have good average
API, so that new school and underperformers can follow their best practices.

Methodology- Use PROC SORT by Dname to sort the district name in descending 
order because we will be grouping the district name together for average API's
for the district and it is a good practice to sort it first.Converted char 
varaible to numeric for mean calculation.USed PROc means to calculate average
of API's for 2011 grouped by district name.Used PROC SORT to sort the mean data
descending.Used PROC print with OBS=10 to print top 10 district name with respe-
-ct to average API for 2011.
;

proc sort data=api_analytic_file out=api_analytic_out1; /*Sorting by District*/
    by descending DNAME;
run;

data api_analytic_out2;         /*Changing CHAR to Numeric for API11 Variable*/
    set api_analytic_out1;
    new_API11 = API11*1;
run;

proc means data= api_analytic_out2 noprint mean;        /*Calculating Average*/
    var new_API11;
    class DNAME;                                         /*grouped by Distict*/
    output 
    out = api_analytic_mean_DNAME (DROP = _TYPE_)
    mean = api_mean_dname;
run;

proc sort data= api_analytic_mean_DNAME out= api_analytic_mean_DNAME_sort;
    by descending api_mean_dname;                       /*Sort by Average API*/
run;

title underlin=2 bcolor=bilg " TOP 10 District API in CA";
                                   /*Printing top 10 District by Average APIs*/
proc print data= api_analytic_mean_DNAME_sort (obs=10);
run;
title; 


*
Research Question -Which races have an average API below and above the mean of 
overall API in each county for the year 2013 ?

Rationale-This would help idetify the races that score API below the average  
of overall API.In other words races that are underperformers and are affecting
the API score needs to get more attention and resourses in order for them
to meet good API standards.

Methodology-Created new dataset with numeric value to calculate mean beacause 
the current variables were of CHAR type.Use PROC means to calculate average 
API's for each race grouped by county. 
;

data new_api_analytic_file;        /*Creating new dataset with numeric values*/
 set api_analytic_file;
    new_API13 = API13*1;
    new_AA_API13 = AA_API13*1;
    new_AI_API13 = AI_API13*1;
    new_AS_API13= AS_API13*1;
    new_FI_API13 = FI_API13*1;
    new_HI_API13 = HI_API13*1;
    new_PI_API13 = PI_API13*1;
    new_WH_API13 = WH_API13*1;
run;

title underlin=1 bcolor=bilg "Comparision of average API score for all races";
proc means data=new_api_analytic_file mean ; /*grouped by county for all race*/
    class CNAME;
    var new_API13 new_AA_API13 new_AI_API13 new_AS_API13 new_FI_API13
    new_HI_API13 new_PI_API13 new_WH_API13;
    output 
    out = api_analytic_mean (DROP = _TYPE_);
run;

*
Research Question- What is the average API score in 2013 for funded charter non 
directly funded charter and non chater schools?

Rationale-This would help us determine the performance of charters and non cha-
-rters schools following which we can look for the reasons for variation in API
scores. 

Methodology-Use PROC Sort by Charter  as best practice to sort the data according
to the type of school.Created new dataset for API value of 2013 as numeric 
and filled up blanks in column charter.Use PROC means to look at avaerage API
scores for 2013 grouped by type of charter schools.
N= NON charter , Y = Charter not directly funded , D = Directly funded charter.
;

proc sort data=new_api_analytic_file out=new_api_analytic_sort;
by descending CHARTER;          /*sorting by type of schools as best practice*/
RUN;

data new_api_analytic_sort_fill;  /*creating numeric data, fill in blank data*/
set new_api_analytic_sort;
new_API13 = API13*1;
if CHARTER='' then CHARTER='N';
run;

proc means data=new_api_analytic_sort_fill mean noprint; 
    var new_API13;                                /*mean group by school type*/
    class CHARTER;
    output 
    out = new_api_analytic_sort_grpd (DROP = _TYPE_)
    mean = mean_dname;
run;

title underlin=1 bcolor=bilg " Average API scores-By School type";
proc print data= new_api_analytic_sort_grpd(rename=(mean_dname=Average) 
rename=(_FREQ_=NumberOfSchools) rename=(CHARTER=School_Type));/*rename header*/
run;
