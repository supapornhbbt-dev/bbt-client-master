-- PND.51 FY2569: mark clients that only have an Estimate worksheet as NOT FILED
-- Thai text is Unicode-escaped so clipboard encoding cannot corrupt it.
-- 31 clients: ATD, BMK, CE1, CE10, CE11, CE12, CE14, CE15, CE16, CE2, CE3, CE4, CE7, CE8, CE9, CE99, CET, FGP, GBT, GFM, GOV, HOW, KPB, NCP, NLN, SPB, TBS, TKS, TOY, TRT, TSE

update tax_year t
   set status = U&'\0e22\0e31\0e07\0e44\0e21\0e48\0e44\0e14\0e49\0e22\0e37\0e48\0e19',
       note = U&'\0e22\0e31\0e07\0e44\0e21\0e48\0e1e\0e1a\0e41\0e1a\0e1a\0e17\0e35\0e48\0e22\0e37\0e48\0e19 - \0e43\0e19\0e42\0e1f\0e25\0e40\0e14\0e2d\0e23\0e4c OneDrive \0e21\0e35\0e41\0e15\0e48\0e44\0e1f\0e25\0e4c Estimate PND.51 (\0e23\0e48\0e32\0e07\0e1b\0e23\0e30\0e21\0e32\0e13\0e01\0e32\0e23) \0e15\0e23\0e27\0e08 4 \0e01.\0e22. 2569',
       filed_date = null
  from client c
 where c.tax_id = t.tax_id
   and t.fy_be = 2569 and t.form = 'PND51'
   and c.client_code in ('ATD', 'BMK', 'CE1', 'CE10', 'CE11', 'CE12', 'CE14', 'CE15', 'CE16', 'CE2', 'CE3', 'CE4', 'CE7', 'CE8', 'CE9', 'CE99', 'CET', 'FGP', 'GBT', 'GFM', 'GOV', 'HOW', 'KPB', 'NCP', 'NLN', 'SPB', 'TBS', 'TKS', 'TOY', 'TRT', 'TSE');
