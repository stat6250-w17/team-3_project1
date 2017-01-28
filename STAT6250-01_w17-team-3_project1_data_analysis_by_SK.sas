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
%let sasUEFilePrefix = team-3_project1;

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
year 2013 ?

Rationale-This would help us determine which top 10 districts have good average
API, so that new school and underperformers can follow their best practices.

Methodology- Use PROC SORT by Dname to sort the district name in descending 
order because we will be grouping the district name together for average API's
for the district and it is a good practice to sort it first.Used PROC means to 
calculate average of API's for 2013 grouped by district name.Used PROC SORT to
sort the mean data descending. Used PROC print with OBS=10 to print top 10 dist
rict name with respect to average API for 2013.
;

title1 underlin =1 bcolor= bilg  "Research Question - What are the top ten dis"
    "tricts having highest API score in year 2013 ?";
title3 underlin =1 bcolor= bilg "Rationale-This would help us determine which "
    "top 10 district have good average API, so that new school and underperfor"
    "mers can follow their best practices.";
title4 underlin =2 bcolor= azure "TOP 10 District by Average API in 2013";
footnote1 bcolor=cornsilk "The SAS steps in the program sort the raw data by v"
    "ariable DNAME before calculating average API scrore for each district and"
    "dropping _TYPE_ from the output.";
footnote2 bcolor=cornsilk "The output of mean is sorted by Average API";
footnote4 bcolor=azure "We print the Top 10 Districts by Average API for 2013";  
    
proc sort data=api_analytic_file out=api_analytic_out1; /*Sorting by District*/
    by descending DNAME;
run;

proc means data= api_analytic_out1 noprint mean;        /*Calculating Average*/
    var API13;
    class DNAME;                                         /*grouped by Distict*/
    output 
    out = api_analytic_mean_DNAME (DROP = _TYPE_)
    mean = api_mean_dname;
run;

proc sort data= api_analytic_mean_DNAME out= api_analytic_mean_DNAME_sort;
    by descending api_mean_dname;                       /*Sort by Average API*/
run;
                                   /*Printing top 10 District by Average APIs*/
proc print data= api_analytic_mean_DNAME_sort (obs=10) label;
        label DNAME = 'District Name'
        _FREQ_='Total number of Schools'
        api_mean_dname='Average API of District';
run;
title1;
title3;
title4; 
footnote1;
footnote2;
footnote4;

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


title1 underlin=1 bcolor=bilg "Comparision of average API score for all races";

proc means data=api_analytic_file noprint mean; /*group by county for races*/
    class CNAME;
    var API13 AS_API13 AA_API13;
    output 
    out = api_analytic_mean (DROP = _TYPE_ _FREQ_); 
run;

proc print data=api_analytic_mean (firstobs=2 )NOOBS label;
    WHERE _stat_ = 'MEAN';
    id CNAME;
    label CNAME = 'County Name'
    API13 = 'Average API of 2013'
    AS_API13 = 'Average API of Asians 2013'
    AA_API13 = 'Average API of African American 2013'
    _STAT_ = 'Average APIs';
    BY _STAT_;
    
run; 

title1;

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

proc sort data = api_analytic_file out = api_analytic_sort;
by descending CHARTER;          /*sorting by type of schools as best practice*/
RUN;

proc means data = api_analytic_sort mean noprint; 
    var API13;                                /*mean group by school type*/
    class CHARTER;
    output 
    out = api_analytic_sort_grpd (DROP = _TYPE_)
    mean = mean_dname;
run;

title underlin=1 bcolor=bilg " Average API scores-By School type";
proc print data= api_analytic_sort_grpd label noobs;
    
    label mean_dname = 'District Average API'
          _freq_ = 'Number of Schools'
          CHARTER = 'School Type';
run;
