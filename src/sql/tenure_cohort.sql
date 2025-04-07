select
  uid
, wh_id
, div_nbr
, div_nm
, fisc_mth_of_yr
, prcnt_chng_avg_selector_days
, prcnt_chng_cpmh
, prcnt_change_over_365_days

from
(

with SELECTORS as
(
select
  div_nm||'-'||div_nbr||'-'||wh_id||'-'||fisc_mth_of_yr as UID
, wh_id
, div_nbr
, div_nm
, fisc_yr
, fisc_yr_mth
, fisc_mth_of_yr
, usr_id
, cohort
, usr_days_active as selectors_days_active
, usr_weeks_active as selectors_wk_active
, kvi_cases cases
, measure_direct_hrs hours

from SUPPLY_CHAIN.SUPPLY_CHAIN.SC_SELECTOR_PRODUCTIVITY_P2YRS

where fisc_yr between 2019 and 2020
--AND usr_id = 'AWE2020X'
and measure_direct_hrs > 0

order by
  wh_id asc
, fisc_yr_mth desc
)
,


ALL_CPMH_AVG_SLCTR_DAYS_2019 AS
(
select
  slctr.uid
, slctr.wh_id
, slctr.div_nbr
, slctr.div_nm
, slctr.fisc_yr fisc_yr_2019
, slctr.fisc_yr_mth fisc_yr_mth_2019
, slctr.fisc_mth_of_yr
, COUNT(DISTINCT usr_id) no_of_emp_all_2019
, AVG(slctr.selectors_days_active) avg_selectors_days_active_all_2019
, SUM(slctr.cases) cases_all_2019
, SUM(slctr.hours) hours_all_2019
, SUM(slctr.cases)/ SUM(slctr.hours) cpmh_all_2019

FROM (SELECTORS) slctr

WHERE fisc_yr = 2019

GROUP BY
  slctr.uid
, slctr.wh_id
, slctr.div_nbr
, slctr.div_nm
, slctr.fisc_yr
, slctr.fisc_yr_mth
, slctr.fisc_mth_of_yr

ORDER BY
  wh_id ASC
, fisc_yr_mth DESC
)
,

ALL_CPMH_AVG_SLCTR_DAYS_2020 AS

(
select
  slctr.uid
, slctr.wh_id
, slctr.div_nbr
, slctr.div_nm
, slctr.fisc_yr fisc_yr_2020
, slctr.fisc_yr_mth fisc_yr_mth_2020
, slctr.fisc_mth_of_yr
, COUNT(DISTINCT usr_id) no_of_emp_all_2020
, SUM(slctr.cases) cases_all_2020
, SUM(slctr.hours) hours_all_2020
, AVG(slctr.selectors_days_active) avg_selectors_days_active_all_2020
, SUM(slctr.cases)/ SUM(slctr.hours) cpmh_all_2020

FROM (SELECTORS) slctr

WHERE fisc_yr = 2020

GROUP BY
  slctr.uid
, slctr.wh_id
, slctr.div_nbr
, slctr.div_nm
, slctr.fisc_yr
, slctr.fisc_yr_mth
, slctr.fisc_mth_of_yr

ORDER BY
  wh_id ASC
, fisc_yr_mth DESC
)
,

COHORT_A_CPMH_AVG_SLCTR_DAYS_2019 AS
(
select
  slctr.uid
, slctr.wh_id
, slctr.div_nbr
, slctr.div_nm
, slctr.fisc_yr fisc_yr_2019
, slctr.fisc_yr_mth fisc_yr_mth_2019
, slctr.fisc_mth_of_yr
, COUNT(DISTINCT usr_id) no_of_emp_all_2019_A
, AVG(slctr.selectors_days_active) avg_selectors_days_active_all_2019_A
, SUM(slctr.cases)/ SUM(slctr.hours) cpmh_all_2019_A

FROM (SELECTORS) slctr

WHERE slctr.fisc_yr = 2019
AND slctr.cohort = 'A'

GROUP BY
  slctr.uid
, slctr.wh_id
, slctr.div_nbr
, slctr.div_nm
, slctr.fisc_yr
, slctr.fisc_yr_mth
, slctr.fisc_mth_of_yr

ORDER BY
  slctr.wh_id ASC
, slctr.fisc_yr_mth DESC
)
,

COHORT_A_CPMH_AVG_SLCTR_DAYS_2020 AS

(
select
  slctr.uid
, slctr.wh_id
, slctr.div_nbr
, slctr.div_nm
, slctr.fisc_yr fisc_yr_2020
, slctr.fisc_yr_mth fisc_yr_mth_2020
, slctr.fisc_mth_of_yr
, COUNT(DISTINCT usr_id) no_of_emp_all_2020_A
, AVG(slctr.selectors_days_active) avg_selectors_days_active_all_2020_A
, SUM(slctr.cases)/ SUM(slctr.hours) cpmh_all_2020_A

FROM (SELECTORS) slctr

WHERE slctr.fisc_yr = 2020
AND slctr.cohort = 'A'

GROUP BY
  slctr.uid
, slctr.wh_id
, slctr.div_nbr
, slctr.div_nm
, slctr.fisc_yr
, slctr.fisc_yr_mth
, slctr.fisc_mth_of_yr

ORDER BY
  slctr.wh_id ASC
, slctr.fisc_yr_mth DESC
)


select
  a.uid
, a.wh_id
, a.div_nbr
, a.div_nm
, a.fisc_mth_of_yr
, a.no_of_emp_all_2019
, a.avg_selectors_days_active_all_2019
, a.cpmh_all_2019
, c.no_of_emp_all_2019_A
, c.avg_selectors_days_active_all_2019_A
, c.cpmh_all_2019_A
, b.no_of_emp_all_2020
, b.avg_selectors_days_active_all_2020
, b.cpmh_all_2020
, d.no_of_emp_all_2020_A
, d.avg_selectors_days_active_all_2020_A
, d.cpmh_all_2020_A
, c.no_of_emp_all_2019_A / a.no_of_emp_all_2019 prcnt_of_emp_2019_A
, d.no_of_emp_all_2020_A / b.no_of_emp_all_2020 prcnt_of_emp_2020_A
, (b.avg_selectors_days_active_all_2020 - a.avg_selectors_days_active_all_2019)/ b.avg_selectors_days_active_all_2020 prcnt_chng_avg_selector_days
, (b.cpmh_all_2020 - a.cpmh_all_2019)/ b.cpmh_all_2020 prcnt_chng_cpmh
, (prcnt_of_emp_2020_A - prcnt_of_emp_2019_A)/ prcnt_of_emp_2020_A prcnt_change_over_365_days


FROM (select * from ALL_CPMH_AVG_SLCTR_DAYS_2019) a

INNER JOIN (select * from ALL_CPMH_AVG_SLCTR_DAYS_2020) b
ON a.uid = b.uid

INNER JOIN (select * from COHORT_A_CPMH_AVG_SLCTR_DAYS_2019) c
ON a.uid = c.uid

INNER JOIN (select * from COHORT_A_CPMH_AVG_SLCTR_DAYS_2020) d
ON a.uid = d.uid

ORDER BY
  a.wh_id ASC
, a.fisc_mth_of_yr ASC
)

;



