* Environmental Variables ;
%let dataPrepFileName = STAT6250-01_w17-team-3_project1_data_preparation.sas;
%let sasUEFilePrefix = proj1/team-3_project1;



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

proc print data=work.api_analytic_file (obs=100) noobs;
    title 'Title';
    var dname sname;
run;

proc means data=work.api_analytic_file;
    class dname;
    var num12;
    title 'Number of Students Included in the 2012 Growth API'