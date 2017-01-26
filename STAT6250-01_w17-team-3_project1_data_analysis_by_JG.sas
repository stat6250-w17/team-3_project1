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



* load external file that generates analytic dataset FRPM1516_analytic_file
using a system path dependent on the host operating system, after setting the
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



*******************************************************************************
*******************************************************************************

Research Question: What are the enrollment numbers by county of students 
participating in the 2012 Academic Performance Index survey?

Rationale: Summary statistics for counties are directly correlated to funding
dollars.  This is a useful statistic to track.

Methodology: Using proc sort to sort the data by county, we then use proc
means to gather and compile stats on enrolment numbers for 2012.  We
classify by county.
;

title1 underlin=2 bcolor=bioy "Research Question: What are the enrollment numb"
    "ers by county of students participating in the 2012 Academic Performance "
    "Index survey?";
title2 underlin=2 bcolor=bioy "Rationale: Summary statistics for counties are "
    "directly correlated to funding dollars.  This is a useful statistic to tr"
    "ack.";
footnote1 underlin=2 bcolor=bioy "The SAS step output addresses the question/o"
    "bjective by dropping type, and statistic information, and outputting just"
    " raw counts.";
footnote2 underlin=2 bcolor=bioy "Additionally, we state the variable of inter"
    "est is specifically 'num12', the number of students enrolled in 2012, and"
    " classified our output by county name.";
footnote3 underlin=2 bcolor=bioy " classified our output by county name.";
proc sort data=work.api_analytic_file;
    by cname;
run;
proc means data=work.api_analytic_file noprint mean;
    var num12;
    class cname;
    output out=rrt (drop=_type_ _freq_ _stat_);
run;
proc print data=rrt (firstobs=6 obs=30) noobs label;
    label num12='# Students Participated: 2012'
          cname='County Name';
run;
title1; 
title2; 
footnote1;
footnote2;
footnote3;

*******************************************************************************
*******************************************************************************

Research Question: What are the middle values with respect to enrolment
across the years 2011-13, classified by school district?

Rationale: Looking at middle values as opposed to averages is important when
one doesn't want to let outliers influence the high probability of finding
a central tendency, like an average.

Methodology: Use the ever handy proc means with the median option.
;

title underlin=1 bcolor=bioy "The Median value across data sets for 2011-13";
proc means data=work.api_analytic_file median;
    class dname;
    var num11 num12 num13;
    output out=rrt (drop=_type_);
run;

proc print data=rrt;
run;

*******************************************************************************
*******************************************************************************

Research Question: What are the 2012 quartiles of socioeconomically 
disadvantaged students included in the 2012 Growth API, by District?

Rationale: When talking about groups it is important to know what 
quartile breakdown is all about.  Most specifically: benchmarking.  Setting up
benchmarks in the plannaing and subsequent resolving of poverty issues is often
super important in order to gague success or failure of social scholastic
programs.

Methodology: Using the proc means to run analysis on the disadvantaged students
classified by district.
;

title underlin=1 bcolor=bioy "Quartile Breakdown of Socioeconomically 
    Disadvantaged Students Included in the 2012 Growth API, by District";
proc means min q1 median q3 max data=work.api_analytic_file;
    class dname;
    var sd_num12;
run;
