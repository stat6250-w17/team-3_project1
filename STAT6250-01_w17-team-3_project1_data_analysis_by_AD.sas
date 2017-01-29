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
Research Question - How does the increase/decrease of African-American kids
affect the API score of the school ?

Rationale- This analysis can be applied to any race by replace the variable by that
race. This would help us to identify if increase or decrease of particular race 
will affect the API score .

Methodology - This is achieved by using PROC MEAN which calculated the  mean,
sd, maximum ,minimum score of a data used based on classification district name using 
variables of API Score and number of African-American kids in the school;


title1 underlin =1  bcolor= aquamarine "Research Question - How does the increase/decrease
of African-American kids affect the API score of the school ?";

title3 underlin =1 bcolor= aquamarine "Rationale- This analysis can be applied to any race by 
replace the variable by that race. This would help us to identify if increase or decrease of particular race 
will affect the API score .";


title4 underlin =2 bcolor= aquamarine "Effect of African-American kids in API score" ; 

footnote1 bcolor=aquamarine "This sas program uses a proc to produce the average api
of the African-American students ";


proc sort data=api_analytic_file out=api_AA; 
    by descending DNAME;
run;

proc means data= api_AA noprint mean;        
    var API11 API12 API13 AA_NUM11 AA_NUM12 AA_NUM13   ;
    class DNAME;         
    output 
    out = api_analytic_mean_DNAME (DROP = _TYPE_)
    mean = api_mean_dname;
run;

proc sort data= api_analytic_mean_DNAME out= api_analytic_mean_DNAME_sort;
    by descending api_mean_dname;                       
run;
                                
proc print data= api_analytic_mean_DNAME_sort (obs=10) label;
        label DNAME = 'District Name'
        _FREQ_='Total number of Schools'
        api_mean_dname='Average API of District';
run;
title1;                                        
title3;
title4;
footnote1;

*
Research Question - How does the increase/decrease of Socioeconomically 
disadvantaged students affect the API score of the school ?
 
Rationale- This would help to see if the rating system should be modified based on the
type of population of the school instead of using generic methodology for all schools. .

Methodology - This is achieved by using PROC MEAN which calculated the  mean,
sd, maximum ,minimum score of a data used based on classification district name using 
variables of API Score and number of Socioeconomically 
disadvantaged kids in the school ;

title1 underlin =1 bcolor=aquamarine "Research Question - How does the increase/decrease of Socioeconomically 
disadvantaged students affect the API score of the school ?";

title3 underlin =1 bcolor=aquamarine "Rationale- This would help to see if the rating system should be modified
based on the type of population of the school instead of using generic methodology for all schools.";

title4 underlin =2 bcolor=aquamarine "Effect of Socioeconomically disadvantaged students  in API score" ; 
 
footnote1 bcolor=aquamarine "This sas program uses a proc to produce the average api
 of the Socioeconomically disadvantaged students ";

proc means data= api_AA noprint mean;        
    var API11 API12 API13 SD_NUM11 SD_NUM12 SD_NUM13 ;
    class DNAME;    
    output 
    out = api_analytic_mean (DROP = _TYPE_ _FREQ_);
run;

proc print data=api_analytic_mean (obs=10) ;
    WHERE _stat_ = 'MEAN';
    id DNAME;
    label DNAME = 'District Name'
    API11 = 'Average API of 2011'
    API12 = 'Average API of 2012'
    API13 = 'Average API of 2013'
    _STAT_ = 'Average APIs';
    BY _STAT_;  
    run;
title1;                                        
title3;
title4;
footnote1;



*Research Question -  What factors have contributed to increase of API of the school ?

Rationale - This would help new schools to know what has worked so they can accomplish the same 
result using similar modelling of school.

Methodology- This is achieved by creating 2 data sets.One data set sorts school by API
the second one sorts school by district and then merging the two data sets;

title1 underlin =1  bcolor= aquamarine "Research Question -  What factors have contributed to
 increase of API of the school ?";

title3 underlin =1 bcolor= aquamarine "Rationale - This would help new schools to know what has
worked so they can accomplish the same result using similar modelling of school.";


title4 underlin =2 bcolor= aquamarine "Highest ranked API schools" ; 

footnote1 bcolor=aquamarine "This sas program uses a proc to produce the average api
 of the Top 10 schools ";


proc sort data=api_analytic_file out=api_input; 
    by descending DNAME;


proc means data= api_input noprint mean;        
    var  API13;
    class DNAME;                                        
    output 
    out = api_output 
    mean = api_mean;
run;

proc sort data= api_output out= api_sort;
    by descending api_mean;                       
run;


                                   
proc print data=  api_sort (obs=10);
run;

title1;                                        
title3;
title4;
footnote1;








