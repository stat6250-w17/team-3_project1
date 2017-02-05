*******************************************************************************
**************** 80-character banner for column width reference ***************
* (set window width to banner width to calibrate line length to 80 characters *
*******************************************************************************


This file prepares the dataset described below for analysis.

Dataset Name: 3-Year Average Academic Performance Index (API) Data File.

Experimental Units: California public K-12 schools

Number of Observations: 9,596

Number of Features: 107

Data Source: The file http://www3.cde.ca.gov/researchfiles/api/14avgtx.zip was
downloaded and converted to an Excel file.  The data dile is now called
14avgtx.xls.  Originally the data file did not have field headings.
From the Data Dictionary field headings were added to the the Excel data file.

Data Dictionary: http://www.cde.ca.gov/ta/ac/ap/reclayoutApiAvg.asp

Unique ID: The columns County_Code, District_Code, and School_Code form a
composite key, field 1 known as: CDS.
;

* Setting up the Environmental Variable. ;
%let inputDatasetURL =
  /*https://github.com/stat6250/team-3_project1/blob/master/14avgtx.xls?raw=true */
  http://filebin.ca/39hWjpiY6HZ5/14avgtx.xls
;

* Loading raw datafile via Internet;
filename APItemp TEMP;

proc http
    method="get" 
    url="&inputDatasetURL." 
    out=APItemp
    ;
run;

proc import
    file=APItemp
    out=API_raw
    dbms=xls
    ;
run;

filename APItemp clear;

* Build Data Set.  All data fields will be visible and accessed by field name.;
data api_analytic_file;
    retain
        CDS
        RTYPE
        STYPE
        SPED
        SIZE
        CHARTER
        SNAME
        DNAME
        CNAME
        FLAG
        NUM11
        API11
        NUM12
        API12
        NUM13
        API13
        AVG_NW
        AVG_W
        AA_NUM11
        AA_API11
        AA_NUM12
        AA_API12
        AA_NUM13
        AA_API13
        AA_AVG_NW
        AA_AVG_W
        AI_NUM11
        AI_API11
        AI_NUM12
        AI_API12
        AI_NUM13
        AI_API13
        AI_AVG_NW
        AI_AVG_W
        AS_NUM11
        AS_API11
        AS_NUM12
        AS_API12
        AS_NUM13
        AS_API13
        AS_AVG_NW
        AS_AVG_W
        FI_NUM11
        FI_API11
        FI_NUM12
        FI_API12
        FI_NUM13
        FI_API13
        FI_AVG_NW
        FI_AVG_W
        HI_NUM11
        HI_API11
        HI_NUM12
        HI_API12
        HI_NUM13
        HI_API13
        HI_AVG_NW
        HI_AVG_W
        PI_NUM11
        PI_API11
        PI_NUM12
        PI_API12
        PI_NUM13
        PI_API13
        PI_AVG_NW
        PI_AVG_W
        WH_NUM11
        WH_API11
        WH_NUM12
        WH_API12
        WH_NUM13
        WH_API13
        WH_AVG_NW
        WH_AVG_W
        MR_NUM11
        MR_API11
        MR_NUM12
        MR_API12
        MR_NUM13
        MR_API13
        MR_AVG_NW
        MR_AVG_W
        SD_NUM11
        SD_API11
        SD_NUM12
        SD_API12
        SD_NUM13
        SD_API13
        SD_AVG_NW
        SD_AVG_W
        EL_NUM11
        EL_API11
        EL_NUM12
        EL_API12
        EL_NUM13
        EL_API13
        EL_AVG_NW
        EL_AVG_W
        DI_NUM11
        DI_API11
        DI_NUM12
        DI_API12
        DI_NUM13
        DI_API13
        DI_AVG_NW
        DI_AVG_W
        IRG5
    ;
    keep
        CDS
        RTYPE
        STYPE
        SPED
        SIZE
        CHARTER
        SNAME
        DNAME
        CNAME
        FLAG
        NUM11
        API11
        NUM12
        API12
        NUM13
        API13
        AVG_NW
        AVG_W
        AA_NUM11
        AA_API11
        AA_NUM12
        AA_API12
        AA_NUM13
        AA_API13
        AA_AVG_NW
        AA_AVG_W
        AI_NUM11
        AI_API11
        AI_NUM12
        AI_API12
        AI_NUM13
        AI_API13
        AI_AVG_NW
        AI_AVG_W
        AS_NUM11
        AS_API11
        AS_NUM12
        AS_API12
        AS_NUM13
        AS_API13
        AS_AVG_NW
        AS_AVG_W
        FI_NUM11
        FI_API11
        FI_NUM12
        FI_API12
        FI_NUM13
        FI_API13
        FI_AVG_NW
        FI_AVG_W
        HI_NUM11
        HI_API11
        HI_NUM12
        HI_API12
        HI_NUM13
        HI_API13
        HI_AVG_NW
        HI_AVG_W
        PI_NUM11
        PI_API11
        PI_NUM12
        PI_API12
        PI_NUM13
        PI_API13
        PI_AVG_NW
        PI_AVG_W
        WH_NUM11
        WH_API11
        WH_NUM12
        WH_API12
        WH_NUM13
        WH_API13
        WH_AVG_NW
        WH_AVG_W
        MR_NUM11
        MR_API11
        MR_NUM12
        MR_API12
        MR_NUM13
        MR_API13
        MR_AVG_NW
        MR_AVG_W
        SD_NUM11
        SD_API11
        SD_NUM12
        SD_API12
        SD_NUM13
        SD_API13
        SD_AVG_NW
        SD_AVG_W
        EL_NUM11
        EL_API11
        EL_NUM12
        EL_API12
        EL_NUM13
        EL_API13
        EL_AVG_NW
        EL_AVG_W
        DI_NUM11
        DI_API11
        DI_NUM12
        DI_API12
        DI_NUM13
        DI_API13
        DI_AVG_NW
        DI_AVG_W
        IRG5
    ;
    set api_raw;
run;