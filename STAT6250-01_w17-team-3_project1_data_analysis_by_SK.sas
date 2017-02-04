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



title1 underlin =1 bcolor= bilg  "Research Question - What are the top ten dis"
    "tricts having highest API score in year 2013 ?";
title3 underlin =1 bcolor= bilg "Rationale-This would help us determine which "
    "top 10 district have good average API, so that new school and underperfor"
    "mers can follow their best practices.";
title4 underlin =2 bcolor= azure "TOP 10 District by Average API in 2013";
footnote1 bcolor=cornsilk "The SAS steps in the program is calculating average" 
    "API scrore for each district and dropping _TYPE_ from the output.";
footnote2 bcolor=cornsilk "The output of mean is sorted by Average API";
footnote4 bcolor=azure "We print the Top 10 Districts by Average API for 2013";  

*
Methodology-Used PROC means to calculate average of API's for 2013 grouped by
district name.Used PROC SORT to sort the mean data descending. Used PROC print
with OBS=10 to print top 10 district name with respect to average API for 2013.
;

proc means data= api_analytic_file noprint mean;        /*Calculating Average*/
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
title;                                        /*Closing titles and footnotes*/
footnote;


title1 underlin =1 bcolor= bilg  "Research Question -What are the average APIs"
    " of major races for each county as compared with Average API for 2013";
title3 underlin =1 bcolor= bilg "Rationale-This would help identify the races "
    "that scores API below the average of overall county API";
title4 underlin =2 bcolor= azure "Average API by Race for each County in 2013";
footnote1 bcolor=cornsilk "The SAS steps in the program calculates the average"
    " API of major races in each county in 2013";
footnote3 bcolor=azure "We print APIs for major races in each County for 2013";  

*
Methodology-Used PROC means to calculate average for major races for each 
county students. Used Proc print to print the API results by county for 
comparisons. 
;

proc means data=api_analytic_file noprint mean; /*group by county for races*/
    class CNAME;
    var API13 AS_API13 WH_API13 HI_API13 AA_API13;
    output 
    out = api_analytic_mean (DROP = _TYPE_ _FREQ_); 
run;

proc print data=api_analytic_mean (firstobs=2 )NOOBS label;
    WHERE _stat_ = 'MEAN';   /*Print Avg. APIs by Race and Overall County API*/
    id CNAME;
    label CNAME = 'County Name'
    API13 = 'Average API of 2013'
    AS_API13 = 'Average API of Asians 2013'
    WH_API13 = 'Average API of Whites 2013'
    HI_API13 = 'Average API of Hispanics 2013'
    AA_API13 = 'Average API of African American 2013'
    _STAT_ = 'Average APIs';
    BY _STAT_;  
run; 
title;                                        /*Closing titles and footnotes*/
footnote;



title1 underlin =1 bcolor= bilg  "Research Question -What are the average APIs"
    " of Directly funded Charter Schools Vs Non-Directly Funded Charter";
title3 underlin =1 bcolor= bilg "Rationale-This would help the state Governmen"
    "t look at API perforamce of Charter Schools and allocate proper funds";
title4 underlin =2 bcolor= azure "Y = Charter not directly funded";
title5 underlin =2 bcolor= azure "D = Charter Directly funded ";
footnote1 bcolor=cornsilk "The proc means steps in the program calculates the "
    "average API for directly Vs Not directly funded Charter schools in 2013";
footnote3 bcolor=azure "Proc prints Average APIs for Charter schools for 2013";
*
Methodology-Used PROC means to look at average API scores for 2013 
grouped by type of charter schools. 
Y = Charter not directly funded , D = Charter Directly funded .
;

proc means data = api_analytic_file mean noprint; 
    var API13;                                /*mean group by school type*/
    class CHARTER;
    output 
    out = api_analytic_file_grpd (DROP = _TYPE_)
    mean = mean_dname;
run;

proc print data= api_analytic_file_grpd (firstobs = 2)label noobs;
    label mean_dname = 'District Average API'
          _freq_ = 'Number of Schools'
          CHARTER = 'School Type';
run;
title;                                        /*Closing titles and footnotes*/
footnote;